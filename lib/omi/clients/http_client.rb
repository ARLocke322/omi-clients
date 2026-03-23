# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'

# A module to make HTTP requests
module HttpClient
  def request(method:, base:, path:, **options)
    uri = build_uri(base, path, options[:query])
    req = prepare_request(method, uri, options)
    res = execute_request(req, uri)
    handle_response(res)
  end

  private

  def prepare_request(method, uri, options)
    req = build_request(method, uri)
    headers = options[:headers] || {}
    default_headers.merge(headers).each { |k, v| req[k] = v }
    req.body = options[:body] if options[:body]
    req
  end

  def execute_request(req, uri)
    Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(req)
    end
  end

  def handle_response(res)
    raise "#{self.class} API error: #{res.code} – #{res.body}" unless res.is_a?(Net::HTTPSuccess)

    JSON.parse(res.body)
  end

  def build_uri(base, path, query)
    uri = URI.join(base.end_with?('/') ? base : "#{base}/", path)
    uri.query = URI.encode_www_form(query) if query&.any?
    uri
  end

  def build_request(method, uri)
    case method
    when :get  then Net::HTTP::Get.new(uri)
    when :post then Net::HTTP::Post.new(uri)
    else
      raise ArgumentError, "Unsupported HTTP method: #{method}"
    end
  end
end
