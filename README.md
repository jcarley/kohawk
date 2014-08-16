# Kohawk

[![Build Status](https://travis-ci.org/jcarley/kohawk.svg?branch=master)](https://travis-ci.org/jcarley/kohawk)

## Installation

Add this line to your application's Gemfile:

    gem 'kohawk'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kohawk

## Usage

### Setting up the routes file

#### Given you have an event handler class defined as follows

    class PersonHandler
      def create(event, message_store)
      end

      def update(event, message_store)
      end
    end

#### An example routes file could look like the following

    topic 'app_exchange' do
      queue 'app:person:create', :bindings => ['app.person.create'], :as => :person_create
      queue 'app:person:update', :bindings => ['app.person.update'], :as => :person_update
    end

    subscribe queue: :person_create, handler: 'person#create'
    subscribe queue: :person_update, handler: 'person#update'

This routes file would create two queues ('app:person:create' & 'app:person:update').  The person
handler class would receive messages from the 'app:person:create' queue to its create method, and
from 'app:person:update' to its update method. 

## Contributing

1. Fork it ( https://github.com/[my-github-username]/kohawk/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
