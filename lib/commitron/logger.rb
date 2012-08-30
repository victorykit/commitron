module Commitron
  module Logger
    def log(message)
      puts "%-20s | %s" % [ Time.now.to_s, message ]
    end
  end
end