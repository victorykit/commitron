require 'skypemac'

module Commitron
  module Skype
    DEFAULT_CHATROOM = "VictoryKit Chat"

    def chatroom
      ENV["SKYPE_CHATROOM"] || DEFAULT_CHATROOM
    end

    def broadcast_on_skype message
      chat = SkypeMac::Chat.recent_chats.find {|c|c.topic == chatroom}
      if(chat)
        chat.send_message message
        log "Sent to Skype: #{message}"
      else
        log "Could not find #{chatroom} chat on Skype"
      end
    end
  end
end