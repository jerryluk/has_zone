# HasZone

Provides a way to convert from TZinfo time zone identifer to ActiveSupport TimeZone for your Rails application.

## Installation

Add this line to your application's Gemfile:

    gem 'has_zone'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install has_zone

## Usage

Assuming you have an attribute time_zone in your User model:

    class User < ActiveRecord::Base
      include HasZone
      has_zone with: time_zone
    end

Then you can use the time zone with:

    user.time_zone = "America/Los_Angeles"
    user.zone # returns ActiveSupport::TimeZone of "Pacific Time (US & Canada)"

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
