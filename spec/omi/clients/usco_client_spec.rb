# frozen_string_literal: true

require 'spec_helper'

RSpec.describe UscoClient do
  let(:client) { described_class.new }

  it 'searches for works' do
    allow(client).to receive(:request).with(
      method: :get,
      base: UscoClient::API_BASE,
      path: 'search_service_external/simple_search_dsl',
      query: hash_including(query: 'test query')
    ).and_return({ 'data' => [] })

    expect(client.search('test query')).to eq({ 'data' => [] })
  end
end
