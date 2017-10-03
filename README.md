# Raterr

[![codecov](https://codecov.io/gh/wizardone/raterr/branch/master/graph/badge.svg)](https://codecov.io/gh/wizardone/raterr)

`Raterr` allows you to enforce rate limiting restrictions on visitors

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
For Rails application you need to tell `Raterr` what store to use.
Currently it supports a simple hash or a `ActiveSupport::Cache::MemoryStore`
It is best to do that in an initializer like so:
```ruby
# Use either
Raterr::Cache.store = ActiveSupport::Cache::MemoryStore.new
# Or
Raterr::Cache.store = Hash.new
```

Then you can add the limiting on a controller level.
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
    end
  end
end
```
If you want to add limiting to the whole app you would put it in an
application controller and so on...

You can configure the period and the max attempts. The allowed periods
are: `:minute, :hour, :day, :week`

Currently `Raterr` checks the unique ip address of the visitor to
determine the amount the visits.
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Stefan Slaveykov/raterr. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

