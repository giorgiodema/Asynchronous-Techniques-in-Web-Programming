class MailboxChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    #stream_from "mailbox"
    stream_for self.current_user.id
    puts "CHANNEL::: #{self.current_user.username} is online"
    
    self.current_user.status = "online"
    self.current_user.save
    # Sends the "update_status" event to all his contacts
    self.current_user.chats.each do |c|
      contact = nil
      if c.owner == self.current_user
        contact = c.guest
      else
        contact = c.owner
      end

      msg = {
        type:"update_status",
        chat_id:c.id,
        status:"online"
      }

      MailboxChannel.broadcast_to(
          contact.id,
          msg
      )
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    puts "CHANNEL::: #{self.current_user.username} is offline"
    self.current_user.status = "offline"
    self.current_user.save
    # Sends the "update_status" event to all his contacts
    self.current_user.chats.each do |c|
      contact = nil
      if c.owner == self.current_user
        contact = c.guest
      else
        contact = c.owner
      end

      msg = {
        type:"update_status",
        chat_id:c.id,
        status:"offline"
      }

      MailboxChannel.broadcast_to(
        contact.id,
        msg
    )
    end
  end
end
