# Raterr
[![Build Status](https://travis-ci.org/wizardone/raterr.svg?branch=master)](https://travis-ci.org/wizardone/raterr)
[![codecov](https://codecov.io/gh/wizardone/raterr/branch/master/graph/badge.svg)](https://codecov.io/gh/wizardone/raterr)

`Raterr` allows you to enforce rate limiting restrictions based on ip
address.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'raterr'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install raterr

## Usage
For Ruby based application you need to tell `Raterr` what store to use.
Currently it supports a simple hash or a `ActiveSupport::Cache::MemoryStore`
It is best to load the store in an initializer of any other kind of file
that is loaded initially.
```ruby
# Use either
Raterr::Cache.store = ActiveSupport::Cache::MemoryStore.new
# Or
Raterr::Cache.store = Hash.new
```
To enforce rate limiting use:
```ruby
Raterr.enforce(request, period: :minute, max: 200, code: 429)
```
`request` might be any data type that has an `ip` method. For Rails
applications that would be the request method.

The result of `Raterr.enforce` is always a pseudo status. In case the
rate limit has not been reached you will get a pseudo `200` status + the
number of attempts made. This allows you to do additional checks (say a
warning if you are about to reach the threshhold). If
it has been reached you will get whatever status you configured, or the
default one, which is 429 + a text message.

An example usage in a Rails application would be:
```ruby
class MyController < Base::ApplicationController
  before_action :rate_limit, only: :index

  def index
    # Do something cool
  end

  private

  def rate_limit
    result = Raterr.enforce(request, period: :minute, max: 10)
    if result[:status] == 429
      # Do whatever you want to do when the rate limit is reached
      render plain: result[:text], status: result[:status] and return
    else
      puts "Number of attempts: #{result[:attempts]}"
    end
  end
end
```
If you want to add limiting to the whole app you would put it in an
application controller and so on...

You can configure the period error code and the max attempts. The allowed periods
are: `:minute, :hour, :day`.
The default error code is `429`.
The default max attempts is `100`.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/wizardone/raterr. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

