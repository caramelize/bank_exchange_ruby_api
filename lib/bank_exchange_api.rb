# Core
require 'bank_exchange_api/version'
require 'bank_exchange_api/errors'
require 'bank_exchange_api/config'
require 'bank_exchange_api/connection'
require 'bank_exchange_api/bm'
require 'bank_exchange_api/param'
require 'bank_exchange_api/response'
require 'bank_exchange_api/request'

module BankExchangeApi
  class Cli
    # @param config_params [Hash]
    def initialize(config_params={})
      config_params.each{ |key, value| config.public_send("#{key}=", value) }
    end

    def config
      @config ||= Config.new
    end

    def logger
      @logger ||= config.logger
    end

    def connection
      @connection ||= Connection.new(self)
    end

    def info(value)
      logger && logger.info(value)
    end

    def error(value)
      logger && logger.error(value)
    end

    def warn(value)
      logger && logger.warn(value)
    end

    # @return [Boolean]
    def ping
      Request::Ping.new(self).json.success?
    rescue BankExchangeApi::UnsuccessfulResponse
      false
    end

    def banks(params={})
      Request::Banks.new(self, params)
    end

    def bank(swift, params={})
      Request::Bank.new(self, params.merge(swift: swift))
    end

    def rates(params={})
      Request::Rates.new(self, params)
    end

    def rate(iso_code, params={})
      Request::Rate.new(self, params.merge(iso_code: iso_code))
    end
  end
end
