# frozen_string_literal: true

require 'gmo_coin/config'

module GmoCoin
  # GMOCoin cryptocurrency trading API wrapper
  class Client
    def initialize(api_key: nil, api_secret: nil)
      @api_key = api_key
      @api_secret = api_secret
      @public_mode = @api_key&.blank? || @api_secret&.blank?
    end

    #
    # Public API
    #

    # /v1/status
    #
    # @return [String] Response body
    def read_status
      path = '/v1/status'
      public_request_for_get(path)
    end

    # /v1/ticker
    #
    # @param symbol [String] symbol
    # @return [String] Response body
    def read_ticker(symbol = nil)
      path = '/v1/ticker'
      query = {
        symbol: symbol
      }
      query.compact!
      public_request_for_get(path, query)
    end

    # /v1/orderbooks
    #
    # @param symbol [String] symbol
    # @return [String] Response body
    def read_order_books(symbol)
      path = '/v1/orderbooks'
      query = {
        symbol: symbol
      }
      public_request_for_get(path, query)
    end

    # /v1/trades
    #
    # @param symbol [String] symbol
    # @param page [Integer] page
    # @param count [Integer] count
    # @return [String] Response body
    def read_trades(symbol, page: nil, count: nil)
      path = '/v1/trades'
      query = {
        symbol: symbol,
        page: page,
        count: count
      }
      query.compact!
      public_request_for_get(path, query)
    end

    # /v1/klines
    #
    # @param symbol [String] symbol
    # @param interval [String] interval
    # @param date [String] date
    # @return [String] Response body
    def read_klines(symbol, interval, date)
      path = '/v1/klines'
      query = {
        symbol: symbol,
        interval: interval,
        date: date
      }
      public_request_for_get(path, query)
    end

    # /v1/symbols
    #
    # @return [String] Response body
    def read_symbols
      path = '/v1/symbols'
      public_request_for_get(path)
    end

    #
    # Private API
    #

    # /v1/account/margin
    #
    # @return [String] Response body
    def read_margin
      path = '/v1/account/margin'
      private_request_for_get(path)
    end

    # /v1/account/assets
    #
    # @return [String] Response body
    def read_assets
      path = '/v1/account/assets'
      private_request_for_get(path)
    end

    # /v1/account/tradingVolume
    #
    # @return [String] Response body
    def read_trading_volume
      path = '/v1/account/tradingVolume'
      private_request_for_get(path)
    end

    # /v1/orders/
    #
    # @param order_id [String] order_id
    # @return [String] Response body
    def read_orders(order_id)
      path = '/v1/account/orders'
      query = {
        orderId: order_id
      }
      private_request_for_get(path, query)
    end

    # /v1/activeOrders
    #
    # @param symbol [String] symbol
    # @param page [Integer] page
    # @param count [Integer] count
    # @return [String] Response body
    def read_active_orders(symbol, page: nil, count: nil)
      path = '/v1/activeOrders'
      query = {
        symbol: symbol,
        page: page,
        count: count
      }
      query.compact!
      private_request_for_get(path, query)
    end

    # /v1/executions
    #
    # @param order_id [Integer] order_id
    # @param execution_id [String] execution_id
    # @return [String] Response body
    def read_executions(order_id: nil, execution_id: nil)
      path = '/v1/executions'
      query = {
        orderId: order_id,
        executionId: execution_id
      }
      query.compact!
      private_request_for_get(path, query)
    end

    # /v1/latestExecutions
    #
    # @param symbol [String] symbol
    # @param page [Integer] page
    # @param count [Integer] count
    # @return [String] Response body
    def read_latest_executions(symbol, page: nil, count: nil)
      path = '/v1/latestExecutions'
      query = {
        symbol: symbol,
        page: page,
        count: count
      }
      query.compact!
      private_request_for_get(path, query)
    end

    # /v1/openPositions
    #
    # @param symbol [String] symbol
    # @param page [Integer] page
    # @param count [Integer] count
    # @return [String] Response body
    def read_open_positions(symbol, page: nil, count: nil)
      path = '/v1/openPositions'
      query = {
        symbol: symbol,
        page: page,
        count: count
      }
      query.compact!
      private_request_for_get(path, query)
    end

    # /v1/positionSummary
    #
    # @param symbol [String] symbol
    # @return [String] Response body
    def read_position_summary(symbol = nil)
      path = '/v1/positionSummary'
      query = {
        symbol: symbol
      }
      query.compact!
      private_request_for_get(path, query)
    end

    # /v1/account/transfer
    #
    # @param amount [String] amount
    # @param transfer_type [String] transfer_type
    # @return [String] Response body
    def account_transfer(amount, transfer_type)
      path = '/v1/account/transfer'
      request_body = {
        amount: amount,
        transferType: transfer_type
      }
      private_request_for_post(path, request_body)
    end

    # /v1/order
    #
    # @param [Hash] params he args to order.
    # @option params [String] :symbol Required symbol
    # @option params [String] :side Required BUY SELL
    # @option params [String] :execution_type Required MARKET LIMIT STOP
    # @option params [String] :size Required amounts
    # @option params [String] :price Required if LIMIT STOP. Not required if MARKET.
    # @option params [String] :time_in_force FAK FAS FOK ((SOK is Post-only order) LIMIT can only be specified )
    #   *If timeInForce is not specified, FAK for MARKET and STOP, FAS for LIMIT. SOK can be specified for all ticker symbols when order is spot trading, and BTC_JPY when order is margin trading.
    # @option params [String] :losscut_price Available only when order is margin trading and executionType is LIMIT or STOP.
    # @option params [Boolean] :cancel_before true Cancellation of active orders and creating new orders will occur at the same time based on the below rule:
    #   *You can only specify cancelBefore as true for orders which are spot trading, executionType: MARKET, timeInforce: FAK and side: SELL.
    # @return [String] Response body
    # @example Sell MONA coins by limit order
    #   @gmo_client = GmoCoin::Client.new(api_key: ENV['GMO_KEY'], api_secret: ENV['GMO_SECRET'])
    #   @gmo_client.order(symbol: 'MONA', side: 'SELL', execution_type: 'LIMIT', size: '1', price: '100.123')
    def order(**params)
      path = '/v1/order'
      request_body = transform_keys_to_lower_camel_case(params)
      private_request_for_post(path, request_body)
    end

    # Buy limit order by calling /v1/order
    #
    # @param symbol [String] symbol
    # @param size [String] amount
    # @param price [String] price
    # @return [String] Response body
    # @example Sell coins by limit order
    #   @gmo_client = GmoCoin::Client.new(api_key: ENV['GMO_KEY'], api_secret: ENV['GMO_SECRET'])
    #   @gmo_client.bid_limit_order(symbol: 'MONA', size: '1', price: '40.123')
    def bid_limit_order(symbol:, size:, price:)
      order(symbol: symbol, side: 'BUY', execution_type: 'LIMIT', size: size, price: price)
    end

    # Sell limit order by calling /v1/order
    #
    # @param symbol [String] symbol
    # @param size [String] amount
    # @param price [String] price
    # @return [String] Response body
    # @example Sell coins by limit order
    #   @gmo_client = GmoCoin::Client.new(api_key: ENV['GMO_KEY'], api_secret: ENV['GMO_SECRET'])
    #   @gmo_client.ask_limit_order(symbol: 'MONA', size: '1', price: '65.123')
    def ask_limit_order(symbol:, size:, price:)
      order(symbol: symbol, side: 'SELL', execution_type: 'LIMIT', size: size, price: price)
    end

    # /v1/changeOrder
    #
    # @param order_id [Integer] order_id
    # @param price [String] price
    # @param losscut_price [String] losscut_price
    # @return [String] Response body
    def change_order(order_id, price, losscut_price: nil)
      path = '/v1/changeOrder'
      request_body = {
        orderId: order_id,
        price: price,
        losscutPrice: losscut_price
      }
      request_body.compact!
      private_request_for_post(path, request_body)
    end

    # /v1/cancelOrder
    #
    # @param order_id [Integer] order_id
    # @return [String] Response body
    def cancel_order(order_id)
      path = '/v1/cancelOrder'
      request_body = {
        orderId: order_id
      }
      private_request_for_post(path, request_body)
    end

    # /v1/cancelOrders
    #
    # @param order_ids [Array<Integer>] order_ids
    # @return [String] Response body
    def cancel_orders(order_ids)
      path = '/v1/cancelOrders'
      request_body = {
        orderIds: order_ids
      }
      private_request_for_post(path, request_body)
    end

    # /v1/cancelBulkOrder
    #
    # @param symbols [Array<String>] symbols
    # @param side [String] side
    # @param settle_type [String] settle_type
    # @param desc [Boolean] desc
    # @return [String] Response body
    def cancel_bulk_order(symbols, side: nil, settle_type: nil, desc: nil)
      path = '/v1/cancelBulkOrder'
      request_body = {
        symbols: symbols,
        side: side,
        settleType: settle_type,
        desc: desc
      }
      request_body.compact!
      private_request_for_post(path, request_body)
    end

    # /v1/closeOrder
    #
    # @param [Hash] params he args to order.
    # @option params [String] :symbol Required symbol
    # @option params [String] :side Required BUY SELL
    # @option params [String] :execution_type Required MARKET LIMIT STOP
    # @option params [String] :time_in_force FAK FAS FOK ((SOK is Post-only order) LIMIT can only be specified )
    #   *If timeInForce is not specified, FAK for MARKET and STOP, FAS for LIMIT. SOK can be specified for BTC_JPY.
    # @option params [String] :price Required if LIMIT STOP. Not required if MARKET.
    # @option params [Array<Hash>] :settle_position
    # @option params [Integer] settle_position.positionId Allowed to set one position.
    # @option params [String] settle_position.size Allowed to set one position.
    # @option params [Boolean] :cancel_before true Cancellation of active orders and creating new orders will occur at the same time based on the below rule:
    #   *You can only specify cancelBefore as true for orders which are spot trading, executionType: MARKET, timeInforce: FAK and side: SELL.
    # @return [String] Response body
    # @example Close BTC_JPY by limit order
    #   @gmo_client = GmoCoin::Client.new(api_key: ENV['GMO_KEY'], api_secret: ENV['GMO_SECRET'])
    #   @gmo_client.close_order(symbol: 'BTC_JPY', side: 'SELL', execution_type: 'LIMIT', price: '6000000' , settle_position: [{positionId: 123, size: '1'}])
    def close_order(**params)
      path = '/v1/closeOrder'
      request_body = transform_keys_to_lower_camel_case(params)
      private_request_for_post(path, request_body)
    end

    # /v1/closeBulkOrder
    #
    # @param [Hash] params he args to order.
    # @option params [String] :symbol Required symbol
    # @option params [String] :side Required BUY SELL
    # @option params [String] :execution_type Required MARKET LIMIT STOP
    # @option params [String] :time_in_force FAK FAS FOK ((SOK is Post-only order) LIMIT can only be specified )
    #   *If timeInForce is not specified, FAK for MARKET and STOP, FAS for LIMIT. SOK can be specified for BTC_JPY.
    # @option params [String] :price Required if LIMIT STOP. Not required if MARKET.
    # @option params [String] :size Required
    # @return [String] Response body
    # @example Close BTC_JPY by limit order
    #   @gmo_client = GmoCoin::Client.new(api_key: ENV['GMO_KEY'], api_secret: ENV['GMO_SECRET'])
    #   @gmo_client.close_bulk_order(symbol: 'BTC_JPY', side: 'SELL', execution_type: 'LIMIT', price: '6000000' , size: '1')
    def close_bulk_order(**params)
      path = '/v1/closeBulkOrder'
      request_body = transform_keys_to_lower_camel_case(params)
      private_request_for_post(path, request_body)
    end

    # /v1/changeLosscutPrice
    #
    # @param position_id [Integer] position_id
    # @param losscut_price [String] losscut_price
    # @return [String] Response body
    def change_losscut_price(position_id, losscut_price)
      path = '/v1/changeLosscutPrice'
      request_body = {
        positionId: position_id,
        losscutPrice: losscut_price
      }
      private_request_for_post(path, request_body)
    end

    private

    # Call PublicAPI endpoint for Get
    #
    # @param path [String] Path beginning with /v1
    # @param query [String] Query string
    # @return [String] Response body
    def public_request_for_get(path, query = {})
      uri = URI.parse(GmoCoin::Config::PUBLIC_END_POINT + path)
      uri.query = URI.encode_www_form(query) if query.present?
      JSON.parse(RestClient.get(uri.to_s)&.to_s)
    end

    # Call PrivateAPI endpoint for Get
    #
    # @param path [String] Path beginning with /v1
    # @param query [String] Query string
    # @return [String] Response body
    def private_request_for_get(path, query = {})
      http_method = Net::HTTP::Get::METHOD # GET
      # generate uri http
      uri = URI.parse(GmoCoin::Config::PRIVATE_END_POINT + path)
      uri.query = URI.encode_www_form(query) if query.present?
      http = http_client(uri)

      headers = private_headers(http_method, path) # Get header
      # http request
      response = http.get(uri.to_s, headers)
      JSON.parse(response.body)
    end

    # Call PrivateAPI endpoint for Post
    #
    # @param path [String] Path beginning with /v1
    # @param request_body [String] Request body
    # @return [String] Response body
    def private_request_for_post(path, request_body)
      # raise GmoCoinAuthError if public_mode # TODO: FIXME: Behavior when api_secret is missing.
      http_method = Net::HTTP::Post::METHOD # POST
      # generate uri http
      uri = URI.parse(GmoCoin::Config::PRIVATE_END_POINT + path)
      http = http_client(uri)

      headers = private_headers(http_method, path, request_body) # Post header
      # http request
      response = http.post(uri.path, request_body.to_json, headers)
      JSON.parse(response.body)
    end

    # Return HTTP client based on Uri
    #
    # @param uri [URI::HTTP] Uri
    # @return [Net::HTTP] HTTP
    def http_client(uri)
      http_client = Net::HTTP.new(
        uri.host,
        uri.port
      )
      http_client.use_ssl = uri.scheme == 'https'
      http_client.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http_client.open_timeout = GmoCoin::Config::OPEN_TIME_OUT
      http_client.read_timeout = GmoCoin::Config::READ_TIME_OUT
      http_client
    end

    # Return headers for authentication
    #
    # @param http_method [String] HTTP method
    # @param path [String] Path beginning with /v1
    # @param request_body [Hash] Request body
    # @return [Hash] Request Headers
    def private_headers(http_method, path, request_body = nil)
      # raise GmoCoinAuthError if public_mode # TODO: FIXME: Behavior when api_secret is missing.
      timestamp = current_unix_millis
      plane_text = timestamp + http_method + path + request_body&.to_json.to_s
      api_signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('SHA256'), @api_secret, plane_text)
      {
        'API-KEY' => @api_key,
        'API-TIMESTAMP' => timestamp,
        'API-SIGN' => api_signature
      }
    end

    # Current unix millis
    #
    # @return [String] Unix millis
    def current_unix_millis
      DateTime.now.strftime('%Q')
    end

    # lowerCamelize the hash key
    #
    # @param hash [Hash] hash data
    # @return [Hash] Lower camelized hashed beef
    def transform_keys_to_lower_camel_case(hash)
      hash.transform_keys { |k| k.to_s.camelize(:lower).to_sym }
    end
  end
end
