

App.mailbox = App.cable.subscriptions.create "MailboxChannel",
  connected: ->
    # Called when the subscription is ready for use on the server
    console.log("MailboxChannel ::: Opened")
  disconnected: ->
    # Called when the subscription has been terminated by the server
    console.log("MailboxChannel ::: Closed")
  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    console.log("MailboxChannel ::: Received data")
    
    if data.type == "message"
      console.log("Type = MESSAGE")
      $("#"+data.chat_id).children(".input_box").val("")
      $("#"+data.chat_id).children(".message_box").append("<li class=received_message><p class=message_text> "+data.text+" </p></li>")
      $("#"+data.chat_id).children(".message_box").animate({scrollTop: $("#"+data.chat_id).children(".message_box").prop("scrollHeight")}, 500);

    if data.type == "delete_chat"
      console.log("Type = DELETE_CHAT")
      #console.log("deleting chat:"+"chat_item_"+data.chat_id)
      $("#chat_item_"+data.chat_id).remove()
      $("#"+data.chat_id).remove()
      $(".chat_div").css("display","none")
      $(".left_panel").css("display","block")
      $(".list-group").css("display","block")

    if data.type == "create_chat"
      console.log("Type = CREATE_CHAT")
      $("*").off()
      $("#chats_list").append(window.chat_controller.render_chat_list_item(data.chat_id,data.username,"online"))
      $("#profilepage").append(window.chat_controller.render_chat_div(data.chat_id))

      window.search_users()
      window.chat_controller.show_chat()
      window.chat_controller.hide_chat()
      window.chat_controller.send_message()
      window.chat_controller.delete_chat()
      window.chat_controller.create_chat()

    if data.type == "update_status"
      console.log("Type = UPDATE_STATUS")
      if data.status == "online"
        
        $("#chat_item_"+data.chat_id).children(".status_online").css("display","block")
        $("#chat_item_"+data.chat_id).children(".status_offline").css("display","none")

      else
        
        $("#chat_item_"+data.chat_id).children(".status_online").css("display","none")
        $("#chat_item_"+data.chat_id).children(".status_offline").css("display","block")
