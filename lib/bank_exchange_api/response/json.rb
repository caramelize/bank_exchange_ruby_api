require 'json'

module BankExchangeApi::Response
  class Json < Base
    def body
      @body ||= JSON.parse(http.body)
    end

    def params
      body.fetch('params', {})
    end

    def data
      root ? body[root.to_s] : body
    end
  end
end
