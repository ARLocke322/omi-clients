# frozen_string_literal: true

require 'spec_helper'

RSpec.describe IfpiClient do
  let(:client) { described_class.new }

  describe '#login!' do
    it 'fetches and stores token' do
      allow(client).to receive(:request).with(
        method: :get,
        base: IfpiClient::API_BASE,
        path: 'login',
        headers: hash_including('Authorization' => 'Token undefined')
      ).and_return({ 'token' => 'fake_token' })

      expect(client.login!).to eq(client)
      expect(client.token).to eq('fake_token')
    end
  end

  describe '#search_recordings' do
    it 'raises error if not logged in' do
      expect { client.search_recordings }.to raise_error('Call login! first')
    end

    it 'makes post request when logged in' do
      client = described_class.new(token: 'fake_token', token_fetched_at: Time.now)

      allow(client).to receive(:request).and_return({ 'results' => [] })
      expect(client.search_recordings).to eq({ 'results' => [] })
    end
  end
end
