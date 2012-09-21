require 'github_api'
require 'selenium-webdriver'
require 'open-uri'
require 'json'

require 'commitron/version'
require 'commitron/rails_on_fire'
require 'commitron/skype'
require 'commitron/logger'

module Commitron

  DEFAULT_USER = "victorykit"
  DEFAULT_REPO = "victorykit"
  DEFAULT_POLL_INTERVAL = "60"
  DEFAULT_SITE_URI = "act.watchdog.net"

  INSULTS = [
    "softheads",
    "dingus",
    "dingoes",
    "morans",
    "softheads",
    "haters",
    "gits",
    "weenies",
    "softheads",
    "roundheads",
    "commies",
    "commit bastards",
    "closet Bush supporters",
    "friends",
    "comrades"
  ]

  class << self
    include Skype
    include Logger

    def poll_interval
      ( ENV["COMMITRON_POLL_INTERVAL"] || DEFAULT_POLL_INTERVAL ).to_i
    end

    def site_uri
      ENV["COMMITRON_SITE_URI"] || DEFAULT_SITE_URI
    end

    def dudley_uri
      ENV["DUDLEY_URI"]
    end

    def jerks
      INSULTS.sample
    end

    def check_announcements
      uri = dudley_uri.dup
      uri << "?since=#{last_announcement_timestamp}" if last_announcement_timestamp

      log "checking dudley: #{uri}"

      response = JSON.parse(open(uri).read)
      if last_announcement_timestamp
        response.each {|message| broadcast_on_skype message['content'] }
      end
      self.last_announcement_timestamp = response.last['created_at'] unless response.empty?
    end

    def timestamp_filename
      Pathname.new(__FILE__).dirname.join(".last_announcement_timestamp")
    end

    def last_announcement_timestamp=(timestamp)
      timestamp_filename.open('w') {|io| io.write(timestamp)}
    end

    def last_announcement_timestamp
      timestamp_filename.exist? && timestamp_filename.read
    end

    def check_site
      status = `curl --head -s #{site_uri} | awk 'NR==1{print $2}'`.strip
      log "#{site_uri} returned #{status}"

      if status != '200'
        broadcast_on_skype "hey #{jerks}, the site is broken: #{site_uri}"
      end
    end
  end
end