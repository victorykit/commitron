require 'github_api'
require 'time-lord'
require 'skypemac'
require 'selenium-webdriver'

require 'commitron/version'
require 'commitron/build_checker'
require 'commitron/rails_on_fire'

module Commitron

  DEFAULT_USER = "victorykit"
  DEFAULT_REPO = "victorykit"
  DEFAULT_CHATROOM = "VictoryKit Chat"
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
  
    def user
      ENV["COMMITRON_USER"] || DEFAULT_USER
    end

    def repo
      ENV["COMMITRON_REPO"] || DEFAULT_REPO
    end

    def chatroom
      ENV["SKYPE_CHATROOM"] || DEFAULT_CHATROOM
    end

    def poll_interval
      ( ENV["COMMITRON_POLL_INTERVAL"] || DEFAULT_POLL_INTERVAL ).to_i
    end

    def site_uri
      ENV["COMMITRON_SITE_URI"] || DEFAULT_SITE_URI
    end

    def rof_user
      ENV['ROF_USER']
    end

    def rof_password
      ENV['ROF_PASSWORD']
    end

    def find_new_commits
      begin
        all_commits = Github.new.repos.commits.all(user, repo)
        index_of_last_known_commit = all_commits.index {|c| c['sha'] == last_known_commit}

        #TODO: handle case where last_known_commit is not in the first page of results
        if(index_of_last_known_commit && index_of_last_known_commit > 0)
          new_commits = all_commits[0..index_of_last_known_commit - 1]

          new_commits.each do |c|
            committer = c['commit']['committer']['name']
            commit_time = Time.parse(c['commit']['committer']['date']).ago_in_words
            message = c['commit']['message']
            small_sha = c['sha'][0..6]
            url = "https://github.com/#{user}/#{repo}/commit/#{c['sha']}"
            broadcast_on_skype "New commit: #{small_sha} - #{committer}, #{commit_time} : #{message} \n #{url}"
          end
        end

        store all_commits.first['sha']
      rescue => ex
        log ex
        log ex.backtrace.join
      end
    end

    def last_known_commit
      IO.read(state_file).strip
    end

    def store(sha)
      File.open(state_file, 'w') do |file|
        file.puts sha
      end

      log "updated last known commit to #{sha}"
    end

    def file_path
      "/var/tmp/commitron/#{user}/#{repo}/"
    end

    def state_file
      [file_path, "last_commit"].join
    end

    def jerks
      INSULTS[rand(INSULTS.length)]
    end

    def check_site
      log("Checking status of site #{site_uri}")
      status = `curl --head -s #{site_uri} | awk 'NR==1{print $2}'`
      status.strip!
      if status == '500'
        broadcast_on_skype "hey #{jerks}, the site is broken: #{site_uri}"
      end
    end

    def build_checker
      @checker ||= BuildChecker.new(rof_user, rof_password)
    end

    def check_build
      if build_message = build_checker.run
        broadcast_on_skype build_message
      end
    end

    def log(message)
      puts "%-20s | %s" % [ Time.now.to_s, message ]
    end

    def broadcast_on_skype message
      chat = SkypeMac::Chat.recent_chats.find {|c|c.topic == chatroom}
      if(chat)
        chat.send_message message
        log("Sent to Skype: #{message}")
      else
        log("Could not find #{chatroom} chat on Skype")
      end
    end

  end
end
