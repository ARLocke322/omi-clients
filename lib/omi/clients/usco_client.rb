# frozen_string_literal: true

require_relative './http_client'

# Client for US Copyright Office API
class UscoClient
  include HttpClient

  API_BASE = 'https://api.publicrecords.copyright.gov'

  USER_AGENT = 'Mozilla/5.0 (X11; Linux x86_64) ' \
               'AppleWebKit/537.36 (KHTML, like Gecko) ' \
               'Chrome/138.0.0.0 Safari/537.36'

  def search(query, **options)
    request(
      method: :get,
      base: API_BASE,
      path: 'search_service_external/simple_search_dsl',
      query: build_search_query(query, **options)
    )
  end

  private

  def build_search_query(query, **options)
    {
      query:,
      page_number: options.fetch(:page, 1),
      records_per_page: options.fetch(:size, 100),
      field_type: options.fetch(:field_type, 'keyword'),
      sort_order: options.fetch(:sort, 'asc'),
      model: options.fetch(:model, '')
    }
  end

  def default_headers
    {
      'Accept' => 'application/json',
      'User-Agent' => USER_AGENT,
      'Content-Type' => 'application/json'
    }
  end
end
