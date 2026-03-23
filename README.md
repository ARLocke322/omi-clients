# Omi::Clients

Welcome to the `omi-clients` gem! This library provides easy-to-use API clients for communicating with various music rights and data organizations:
- **MLC Client**: Connects to The Mechanical Licensing Collective (MLC) API to search for works and matched recordings.
- **USCO Client**: Connects to the US Copyright Office API to search public records.
- **IFPI Client**: Connects to the IFPI ISRC API (via SoundExchange) to search for recordings and ISRCs.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'omi-clients'
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install omi-clients
```

## Usage

Below are examples of how to initialize and use each of the available clients.

### MLC Client

The `MlcClient` allows you to search for works and recordings in The Mechanical Licensing Collective database.

```ruby
require 'omi/clients'

client = MlcClient.new

# Search for a work by title
works = client.search_works('yesterday', size: 1)
```

**Example Response:**
```json
{
  "content": [
    {
      "id": 992933336,
      "title": "YESTERDAY",
      "songCode": "YP8CWO",
      "writers": [
        {
          "fullName": "JESSE J SANDERS",
          "ipiNumber": "00819749198",
          "roleCode": 11
        }
      ]
    }
  ],
  "number": 1,
  "size": 1,
  "totalElements": 10835
}
```

### USCO Client

The `UscoClient` interacts with the US Copyright Office API to query registered copyright records.

```ruby
require 'omi/clients'

client = UscoClient.new

# Search the USCO public records
records = client.search('yesterday', size: 1)
```

**Example Response:**
```json
{
  "metadata": {
    "took_ms": 43,
    "hit_count": 31849,
    "max_score": 54.251675
  },
  "data": [
    {
      "score": 54.251675,
      "hit": {
        "author": ["MARVIN F. MOODY"],
        "title_of_work": ["Today and Yesterday"],
        "registration_number": ["AA 448496"],
        "registration_status": "published",
        "first_published_date": ["1944-02-10"]
      }
    }
  ]
}
```

### IFPI Client

The `IfpiClient` searches the IFPI ISRC database to find recording information and ISRCs. *Note: You must call `login!` before performing any searches to fetch the required authentication token.*

```ruby
require 'omi/clients'

client = IfpiClient.new

# Fetch authentication token
client.login!

# Search for recordings (number must be between 10 and 100)
recordings = client.search_recordings(recording_title: 'yesterday', number: 10)
```

**Example Response:**
```json
{
  "numberOfRecordings": 10000,
  "show_releases": true,
  "recordings": [
    {
      "duration": "5:23",
      "recordingType": "Audio",
      "recordingYear": "2017",
      "recordingArtistName": "Eric Reed",
      "isrc": "USL4Q1776253",
      "recordingTitle": "Yesterday - Yesterdays",
      "id": "USL4Q1776253"
    }
  ]
}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rake` to run the tests and linter. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
