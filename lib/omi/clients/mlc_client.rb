# frozen_string_literal: true

require_relative './http_client'

# Client for MLC API
class MlcClient
  include HttpClient

  API_BASE = 'https://api.ptl.themlc.com/api'
  API_2_BASE = 'https://api.ptl.themlc.com/api2v/public'
  DSP_BASE   = 'https://api.ptl.themlc.com/api/dsp-recording'
  USER_AGENT = 'Mozilla/5.0 (X11; Linux x86_64) ' \
               'AppleWebKit/537.36 (KHTML, like Gecko) ' \
               'Chrome/138.0.0.0 Safari/537.36'

  def search_works(title, writer_names: nil, page: 1, size: 100)
    request(
      method: :post,
      base: API_2_BASE,
      path: 'search/works',
      query: { page:, size: },
      body: { title:, writerFullNames: writer_names }.compact.to_json
    )
  end

  def matched_recordings(song_code, limit: 100, page: 1, order: 'matchedAmount', direction: 'desc')
    request(
      method: :get,
      base: DSP_BASE,
      path: "matched/#{song_code}",
      query: { limit:, page:, order:, direction: }
    )
  end

  def get_work(work_id)
    request(
      method: :get,
      base: API_BASE,
      path: "catalog/work/#{work_id}"
    )
  end

  private

  def default_headers
    {
      'Accept' => 'application/json',
      'User-Agent' => USER_AGENT,
      'Content-Type' => 'application/json'
    }
  end
end
