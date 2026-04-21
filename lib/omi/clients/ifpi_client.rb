# frozen_string_literal: true

require 'literal'
require_relative './http_client'

# Client for IFPI ISRC API
class IfpiClient < Literal::Object
  include HttpClient

  API_BASE   = 'https://isrc-api.soundexchange.com/api/ext'
  USER_AGENT = 'Mozilla/5.0 (X11; Linux x86_64) ' \
               'AppleWebKit/537.36 (KHTML, like Gecko) ' \
               'Chrome/138.0.0.0 Safari/537.36'
  TOKEN_TTL  = 3600

  class RateLimitError < StandardError; end

  prop :token, _String?
  prop :token_fetched_at, _String?

  def login!
    resp = request(
      method: :get,
      base: API_BASE,
      path: 'login',
      headers: login_headers
    )

    @token = resp.fetch('token')
    @token_fetched_at = Time.now
    self
  end

  def search_recordings(**args)
    raise 'Call login! first' unless valid_token?

    request(
      method: :post,
      base: API_BASE,
      path: 'recordings',
      body: build_search_payload(**args).to_json,
      headers: default_headers.merge('Authorization' => "Token #{@token}")
    )
  end

  private

  def handle_response(res)
    raise RateLimitError, '429 rate limited' if res.code == '429'

    super
  end

  def build_search_payload(**kwargs)
    {
      searchFields: {
        recordingArtistName: { value: kwargs[:recording_artist_name].to_s },
        recordingTitle: { value: kwargs[:recording_title].to_s },
        releaseName: { value: kwargs[:release_name].to_s }
      },
      start: kwargs.fetch(:start, 0),
      number: kwargs.fetch(:number, 100),
      showReleases: kwargs.fetch(:show_releases, true)
    }
  end

  def valid_token?
    @token &&
      @token_fetched_at &&
      (Time.now - @token_fetched_at) < TOKEN_TTL
  end

  def default_headers
    {
      'Accept' => 'application/json',
      'Content-Type' => 'application/json',
      'User-Agent' => USER_AGENT
    }
  end

  def login_headers
    {
      'Accept' => 'application/json',
      'Authorization' => 'Token undefined',
      'Content-Type' => 'application/json',
      'User-Agent' => USER_AGENT
    }
  end
end
