# frozen_string_literal: true

require 'spec_helper'

RSpec.describe IfpiClient do
  let(:client) { described_class.new(api_key: 'fake_key') }

  describe '#login!' do
    it 'is a no-op that stamps the fetch time and returns self' do
      expect(client.login!).to eq(client)
      expect(client.token_fetched_at).to be_a(Time)
    end
  end

  describe '#search_recordings' do
    it 'posts to the repertoire search endpoint with the api key header' do
      expect(client).to receive(:request).with(
        method: :post,
        base: IfpiClient::API_BASE,
        path: IfpiClient::PATH,
        body: {
          searchFields: {
            recordingArtistName: { value: 'Adele' },
            recordingTitle: { value: 'Hello' }
          },
          start: 0,
          number: 100
        }.to_json
      ).and_return({ 'recordings' => [], 'numberOfRecordings' => 0 })

      expect(
        client.search_recordings(recording_artist_name: 'Adele', recording_title: 'Hello')
      ).to eq({ 'recordings' => [], 'numberOfRecordings' => 0 })
    end

    it 'omits empty search fields' do
      expect(client).to receive(:request).with(
        hash_including(
          body: {
            searchFields: { recordingTitle: { value: 'Hello' } },
            start: 0,
            number: 100
          }.to_json
        )
      ).and_return({})

      client.search_recordings(recording_title: 'Hello')
    end
  end

  describe '#handle_response' do
    it 'raises RateLimitError on 429' do
      res = instance_double(Net::HTTPResponse, code: '429')
      expect { client.send(:handle_response, res) }.to raise_error(IfpiClient::RateLimitError)
    end
  end
end
