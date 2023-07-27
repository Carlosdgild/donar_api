# Donation API

Donation API exercise.

## Installation

1. Clone or download repository.
2. Have PostreSQL 10.X (or greater) and Ruby 3.0.3 installed.
3. Have Redis running
4. Create a `.env` file at the root of the project with the specified values in `.env.sample`. Modify accordingly the values where needed
5. Run:

    ```bash
    bin/setup
    ```
6. Run tests with:
    ```bash
    RAILS_ENV=test bundle exec rspec
    ```
7. You can start the API with:
    ```bash
    bundle exec rails s
    ```
8. To start processing async jobs, in a terminal run:
    ```bash
    bundle exec sidekiq
    ```
9. To run rubocop (linter):
    ```bash
    bundle exec rubocop -a
    ```
