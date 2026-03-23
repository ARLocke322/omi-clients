# frozen_string_literal: true

require_relative 'clients/version'
require 'literal'
require_relative 'clients/http_client'
require_relative 'clients/ifpi_client'
require_relative 'clients/mlc_client'
require_relative 'clients/usco_client'

module Omi
  module Clients
    class Error < StandardError; end
    # Your code goes here...
  end
end
