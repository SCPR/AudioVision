# AudioVision

KPCC's Media Blog

[![Build Status](https://circleci.com/gh/SCPR/AudioVision.png?circle-token=6b0598955b109f205b4210062884cc34d7480797)](https://circleci.com/gh/SCPR/AudioVision)

## Dependencies
* Ruby (>= 1.9.3)
* MySQL
* Redis

## Setup
**Please read this entire section before running the setup command**

It is recommended to use an RVM Gemset for this application.
Run the following command from the root of the app:

    rvm gemset use 1.9.3@audio_vision --create && echo "rvm $(rvm current)" > .rvmrc

Then execute `bin/setup`. This does a few things:

1. Copies `config/templates/development.rb` to `config/environments/`
2. Copies `config/templates/database.yml` to `config/`
3. Generates a `secret_token` and stores it in `config/app_config.yml`
4. Runs `bundle install`
5. Creates the database
6. Syncs your local database with the production database using `dbsync` 
7. Finally, runs all of the tests to ensure you're setup properly.

If your database information is different than what's in the `database.yml`
template file, then copy it in `config/` manually prior to running `bin/setup`,
and modify the information as necessary. Then run `bin/setup` to perform the
rest of the steps (your custom `database.yml` will not be overwritten).

## Running Tests
Run `rake` to run the test suite.
