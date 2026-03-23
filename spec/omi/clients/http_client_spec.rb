# frozen_string_literal: true

require 'spec_helper'

RSpec.describe HttpClient do
  let(:dummy_class) do
    Class.new do
      include HttpClient
      def default_headers
        { 'X-Custom' => 'header' }
      end
    end
  end
  let(:client) { dummy_class.new }
  let(:response) do
    instance_double(Net::HTTPSuccess, code: '200', body: '{"key":"value"}', is_a?: true)
  end
  let(:http_double) { instance_double(Net::HTTP) }

  before do
    allow(Net::HTTP).to receive(:start).and_yield(http_double)
    allow(http_double).to receive(:request).and_return(response)
  end

  it 'makes a GET request' do
    result = client.request(method: :get, base: 'https://example.com/api', path: 'test')
    expect(result).to eq({ 'key' => 'value' })
  end
end
