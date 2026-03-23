# frozen_string_literal: true

require_relative 'lib/omi/clients/version'

Gem::Specification.new do |spec|
  spec.name = 'omi-clients'
  spec.version = Omi::Clients::VERSION
  spec.authors = ['Open Music Initiative']
  spec.email = ['chris@chrsgrrtt.com']

  spec.summary = 'A range of clients to access critical music data repositories.'
  spec.description = 'Access datasets like the MLC, IFPI and USCO to access data critical to songwriters and artists.'
  spec.homepage = 'https://github.com/open-music-initiative/omi-clients'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 4.0.1'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/open-music-initiative/omi-clients'
  spec.metadata['changelog_uri'] = 'https://github.com/open-music-initiative/omi-clients'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore .rspec spec/ .github/ .rubocop.yml])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_dependency 'literal', '~> 1.9'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
