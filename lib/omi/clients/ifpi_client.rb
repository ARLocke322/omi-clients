# frozen_string_literal: true

require 'literal'
require_relative './http_client'

# Client for the SoundExchange Repertoire Search API (official IFPI ISRC data)
class IfpiClient < Literal::Object
  include HttpClient

  API_BASE = 'https://api.soundexchange.com'
  PATH     = 'repertoire/v1_0/recordings/search'

  class RateLimitError < StandardError; end

  prop :api_key, _String?, default: -> { ENV.fetch('IFPI_API_KEY', nil) }
  prop :token, _String?, reader: :public
  prop :token_fetched_at, _Time?, reader: :public

  # Retained for interface compatibility. The official API authenticates via a
  # static API key, so no login round-trip is required.
  def login!
    @token_fetched_at = Time.now
    self
  end

  def search_recordings(**args)
    request(
      method: :post,
      base: API_BASE,
      path: PATH,
      body: build_search_payload(**args).to_json
    )
  end

  private

  def handle_response(res)
    raise RateLimitError, '429 rate limited' if res.code == '429'

    super
  end

  def build_search_payload(**kwargs)
    search_fields = {}

    add_field(search_fields, :recordingArtistName, kwargs[:recording_artist_name])
    add_field(search_fields, :recordingTitle, kwargs[:recording_title])
    add_field(search_fields, :releaseName, kwargs[:release_name])

    {
      searchFields: search_fields,
      start: kwargs.fetch(:start, 0),
      number: kwargs.fetch(:number, 100)
    }
  end

  def add_field(fields, key, value)
    value = value.to_s
    fields[key] = { value: value } unless value.empty?
  end

  def default_headers
    {
      'Accept' => 'application/json',
      'Content-Type' => 'application/json',
      'x-api-key' => @api_key.to_s
    }
  end
end
