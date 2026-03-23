# Omi Clients - Agent Guide

Welcome to the `omi-clients` codebase! This document outlines what you need to know to work effectively in this repository.

## Project Type
This is a Ruby gem project that provides various client implementations (like `HttpClient`, `IfpiClient`, `MlcClient`, etc.) under the `Omi::Clients` module.

## Essential Commands

The project uses `rake` to orchestrate common tasks.

* **Run all tests and linting (Default):** `bundle exec rake`
* **Run tests only:** `bundle exec rake spec` or `bundle exec rspec`
* **Run linting only:** `bundle exec rake rubocop` or `bundle exec rubocop`

## Code Organization & Structure

* **`lib/omi/clients.rb`**: The main entry point for the gem, defining the `Omi::Clients` module.
* **`lib/omi/clients/`**: Contains the core logic and various client implementations (e.g., `http_client.rb`, `ifpi_client.rb`).
* **`spec/`**: Contains all the RSpec tests. Follows the structure of the `lib/` directory.
* **`HttpClient`**: The `HttpClient` module (`lib/omi/clients/http_client.rb`) provides a standardized way to make HTTP requests (`request(method:, base:, path:, ...)`).

## Coding Conventions & Style

* **String Literals**: Use **double quotes** for strings and string interpolation. This is strictly enforced by RuboCop in `.rubocop.yml`.
* **Frozen String Literal**: All Ruby files should begin with `# frozen_string_literal: true`.
* **Linting**: The project uses RuboCop. Always ensure your code passes `bundle exec rubocop` after making changes.

## Testing Approach

* The project uses **RSpec** for testing.
* Tests should be placed in the `spec/` directory, mirroring the structure of the `lib/` directory.
* Run tests frequently using `bundle exec rake spec` to verify your changes. Note that the default generated tests may contain an intentionally failing test (`expect(false).to eq(true)`), be mindful when running tests on a fresh codebase.
