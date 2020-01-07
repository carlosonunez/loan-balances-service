# frozen_string_literal: true

require 'net/http'

module Helpers
  module Integration
    module HTTP
      def self.fetch_endpoint
        return $api_gateway_url unless $api_gateway_url.nil?

        puts "Waiting up to #{seconds_to_wait} seconds for endpoint \
to become available..."
        attempts = 1
        until timed_out?(attempts)
          return endpoint_name unless endpoint_name.nil?

          attempts += 1
          sleep 1
        end
        raise "Secret 'endpoint_name' not found."
      end

      def self.endpoint_name
        Helpers::Integration::SharedSecrets.read(secret_name: 'endpoint_name')
      end

      def self.timed_out?(seconds_elapsed)
        seconds_elapsed == ENV['API_GATEWAY_URL_FETCH_TIMEOUT'] || 60
      end
    end
  end
end
