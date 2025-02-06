require 'gmo_coin'

# initialize
gmo_client = GmoCoin::Client.new(api_key: "YOUR API KEY", api_secret: "YOUR SECRET KEY")

# v1/ticker
puts gmo_client.read_ticker('MONA')
