# GmoCoin

This is API wrapper for trading with GMO Coin.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gmo_coin'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gmo_coin

## Usage

```ruby
require 'gmo_coin'

# initialize
gmo_client = GmoCoin::Client.new(api_key: "YOUR API KEY", api_secret: "YOUR SECRET KEY")

# v1/ticker
gmo_client.read_ticker('MONA')

# v1/order_books
gmo_client.read_order_books('MONA')

# Buy limit order by calling /v1/order
gmo_client.bid_limit_order(symbol: 'MONA', size: '1', price: '40.123')

# Sell limit order by calling /v1/order
gmo_client.ask_limit_order(symbol: 'MONA', size: '1', price: '65.123')

# v1/account/assets
gmo_client.read_assets

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/akiraNuma/gmo_coin.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
