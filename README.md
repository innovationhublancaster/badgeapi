# Lancaster University Badge API Gem [![Gem Version](https://badge.fury.io/rb/badgeapi.svg)](https://badge.fury.io/rb/badgeapi)

The <strong>badgeapi</strong> gem provides Ruby bindings for the [Lancaster University Badge API](http://innovationhub.lancaster.ac.uk/projects/gamification) platform. It allows for quicker and easier access, insertion and consumption of data from the API.

## Documentation

You can find API documentation and examples of how to use this gem at the [Badge API Docs](http://badgeapi.lancaster.ac.uk).

## Requirements

Your application will need to make request via SSL/HTTPS. If you are developing locally the [rechampoulier/tunnelss](https://github.com/rchampourlier/tunnelss) can be used but you will need to follow the Certificate Authority Fix below.

## Installation

Add this line to your application's Gemfile:

```ruby
gem badgeapi
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install badgeapi

You will need to provide your api key to the gem:

```ruby
Badgeapi.api_key = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
```    

### Certificate Authority Fix

The gem relies on Faraday to make the http requests to the API. If you get get any Farday SSL errors, this is because Farday cannot find your CA Certificate. More info at [Faraday: Setting up SSL certificates](https://github.com/lostisland/faraday/wiki/Setting-up-SSL-certificates).

Once you know the location of your CA certificates path your can provide this to the gem via:

```ruby
Badgeapi.ssl_ca_cert='/usr/lib/ssl/certs'
```  

If using [rechampoulier/tunnelss](https://github.com/rchampourlier/tunnelss) for local development.

```ruby
Badgeapi.ssl_ca_cert='/Users/your_user/.tunnelss/ca/cert.pem'
```  

## Development

Use the gems console:

    $ rake console

Run all tests:

    $ bundle exec rake

Run a single test suite:

    $ruby test/badge/badge_test.rb
