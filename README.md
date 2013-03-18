# AudioVision

KPCC's Media Blog

## Dependencies
* Ruby (>= 1.9.3)
* MySQL
* Sphinx
* Redis

## Setup
**Please read this entire section before running the setup command**

It is recommended to use an RVM Gemset for this application.
Create the gemset and put in `.rvmrc`:

    rvm gemset use 1.9.3@audio_vision --create && echo "rvm $(rvm current)" > .rvmrc

From the root of the app, execute `bin/setup`. This does a few things:

1. Copies `config/templates/development.rb` to `config/environments/`
2. Copies `config/templates/database.yml` to `config/`
3. Generates a `secret_token` and stores it in `config/app_config.yml`
4. Runs `bundle install`
5. Creates and loads the schema into the databases (development and test)
6. Finally, runs all of the tests to ensure you're setup properly.

If your database information is different than what's in the `database.yml` template file, then copy it in `config/` manually prior to running `bin/setup`, and modify the information as necessary. Then run `bin/setup` to perform the rest of the steps (your custom `database.yml` will not be overwritten).

## Running Tests
Run `rspec` to run the test suite.
