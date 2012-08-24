# Commitron

Look for new commits and post to our Skype chatroom.

## Installation

Add this line to your application's Gemfile:

    gem 'commitron'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install commitron

## Usage

After installation, start as a demon:

    $ bundle exec commitron start

It will log to /var/tmp/$COMMITRON_REPO/$COMMITRON_USER, and update the chatroom $SKYPE_CHATROOM at intervals of $COMMITRON_POLL_INTERVAL (default: 60 seconds).

To stop demon:

    $ bundle exec commitron stop

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
