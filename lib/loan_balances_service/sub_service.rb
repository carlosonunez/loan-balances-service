# frozen_string_literal: true

require 'yaml'

module LoanBalancesService
  module Subservice
    PROVIDER_YAML_FILE = 'include/providers.yml'
    def self.find(provider_name)
      return nil unless provider_file_exist?

      providers = YAML.safe_load(File.read(Subservice::PROVIDER_YAML_FILE))
      return nil unless providers.key? provider_name

      providers[provider_name]
    end

    def self.provider_file_exist?
      File.exist? Subservice::PROVIDER_YAML_FILE
    end

    private_class_method :provider_file_exist?
  end
end
