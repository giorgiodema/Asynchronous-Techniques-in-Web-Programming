class PollController < ApplicationController

    def poll

        data = {}
        data["active_chats"] = []
        data["new_messages"] = []

        current_user.chats.each do |c|
            data["active_chats"].append({
                "chat_id":c.id,
                "username":c.owner.username
            })
            c.messages.each do |m|
                if m.to? == current_user && m.read == false
                    m.read = true
                    m.save
                    data["new_messages"].append({
                        "chat_id":c.id,
                        "text":m.text
                    })
                end
            end
        end
        render json: data
    end

end
