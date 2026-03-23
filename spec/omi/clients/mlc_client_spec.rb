# frozen_string_literal: true

require 'spec_helper'

RSpec.describe MlcClient do
  let(:client) { described_class.new }

  it 'searches works' do
    allow(client).to receive(:request).with(
      method: :post,
      base: MlcClient::API_2_BASE,
      path: 'search/works',
      query: { page: 1, size: 100 },
      body: { title: 'Test Title' }.to_json
    ).and_return({ 'results' => [] })

    expect(client.search_works('Test Title')).to eq({ 'results' => [] })
  end

  it 'gets matched recordings' do
    allow(client).to receive(:request).and_return([])
    expect(client.matched_recordings('SONG123')).to eq([])
  end

  it 'gets a work' do
    allow(client).to receive(:request).and_return({ 'id' => 'WORK123' })
    expect(client.get_work('WORK123')).to eq({ 'id' => 'WORK123' })
  end
end
