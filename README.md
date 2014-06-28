# AudioVision

KPCC's Media Blog

[![Build Status](https://circleci.com/gh/SCPR/AudioVision.png?circle-token=6b0598955b109f205b4210062884cc34d7480797)](https://circleci.com/gh/SCPR/AudioVision)

## Dependencies
* Ruby (>= 1.9.3)
* MySQL
* Redis

## Setup
1. Copy `config/templates/development.rb` into `config/environments` and update it as necessary.
2. Copy all YML files in `config/templates/` into `config/`, switch the environments to `development`, and update as necessary.

## Running Tests
Run `bundle exec rspec` to run the test suite.
