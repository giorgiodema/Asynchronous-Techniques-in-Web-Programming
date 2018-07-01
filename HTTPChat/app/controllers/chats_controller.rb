class ChatsController < ApplicationController


    def receive
        @answer = {}
        @chat = Chat.find(params["msg"]["chat_id"])

        new_message = Message.create()
        new_message.chat = @chat
        new_message.text = params["msg"]["text"]

        new_message.set_from self.current_user.username
        new_message.save
        @chat.messages.append(new_message)

        receiver_id = new_message.to?.id

        @answer = {status:"saved"}
        render json: @answer

    end

    def create_chat

        owner = current_user
        guest = User.find(params[:guest_id])

        c = Chat.create(owner:owner,guest:guest)

        @answer = {status:"created"}
        render json: @answer
    end


    def delete_chat
        @answer = {}
        @chat = Chat.find(params["chat_id"])

        owner_id = @chat.owner.id
        guest_id = @chat.guest.id
        
        @chat.destroy

        @answer = {status:"deleted"}
        render json: @answer
    end


end