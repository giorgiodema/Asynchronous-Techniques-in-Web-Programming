
chat_controller = {}

chat_controller.render_chat_list_item = (chat_id,username)->

    return '<li class="list-group-item list-group-item-action chat_list_item" id="chat_item_'+chat_id+'">
            <meta name="chat_id" content="'+chat_id+'">
            <img alt="Image" class="chat_user_img" src="/assets/fallback/default-9edf194a00f1dcda7e15e43175301617516db9056902d19fc5f13b4e73afcec4.jpg">
            
            <p>
                '+username+'
            </p>

            <input type="button" class="delete_chat btn-sm" value="delete">
        </li>'

chat_controller.render_chat_div = (chat_id) ->
    return '<div class="col-md-8 chat_div" id="'+chat_id+'" style="display: none;">
            <div class="col-md-12 list-group-item list-group-item-action active chat_top">
                <input type="button" name="close_chat" value="close">
            </div>
            <ul class="jumbotron message_box">
            </ul>
            <textarea class="form-control input_box"></textarea>
        </div>'

# Hides chat when close button is clicked
chat_controller.hide_chat = () ->   
    $("[name='close_chat']").click ->
        $(".chat_div").css("display","none")
        $(".left_panel").css("display","block")
        $(".list-group").css("display","block")
        return


# View the selected chat from the chat index
chat_controller.show_chat = () ->   
    $(".chat_list_item").click ->
        $(".left_panel").css("display","none")
        $(".list-group").css("display","none")
        $(".chat_div").css("display","none")
        id = $(this).children("[name='chat_id']").attr("content")
        $("#"+id.toString()).css("display","block")
        $("#"+id).children(".message_box").animate({scrollTop: $("#"+id).children(".message_box").prop("scrollHeight")}, 500);
        return

chat_controller.send_message = () ->
    $(".chat_div").keypress (e) ->
        if e.keyCode == 13
            msg = {
                chat_id: $(this).attr("id")
                text: $(this).children(".input_box").val()
            }
            chat_controller.post_message(msg)
            

        
chat_controller.post_message = (msg) ->

    token = $("[name='csrf-token']").attr("content")
    $.ajax '/send_message',
        type: 'POST'
        dataType: 'json'
        data: { msg }
        headers: {"X-CSRF-Token":token}
        error: (jqXHR, textStatus, errorThrown) ->
            console.log "error:chat_controller.post_message"
        success: (data, textStatus, jqXHR) ->
            console.log "Status:"+textStatus
            console.log "Data:"+data["myanswer"]
            $("#"+msg.chat_id).children(".input_box").val("")
            $("#"+msg.chat_id).children(".message_box").append("<li class=sent_message><p class=message_text> "+msg.text+" </p></li>")
            $("#"+msg.chat_id).children(".message_box").animate({scrollTop: $("#"+msg.chat_id).children(".message_box").prop("scrollHeight")}, 500);

chat_controller.delete_chat = () ->
    $(".chat_list_item input").click ->
        chat_id = $(this).parent().children("meta[name='chat_id']").attr("content")
        token = $("[name='csrf-token']").attr("content")

        $.ajax '/delete_chat',
            type: 'POST'
            dataType: 'json'
            data:{
                "chat_id":chat_id
            }  
            headers: {"X-CSRF-Token":token}
            error: (jqXHR, textStatus, errorThrown) ->
                console.log "error:chat_controller.delete_chat"
            success: (data, textStatus, jqXHR) ->
                console.log "Status:"+textStatus
                
                $("#chats_list").children().each (index,element) ->
                    id = $(element).children("meta[name='chat_id']").attr("content")
                    if id == chat_id
                        element.remove()

                $("#"+chat_id).remove()
                $(".chat_div").css("display","none")
                $(".left_panel").css("display","block")
                $(".list-group").css("display","block")
                        
chat_controller.create_chat = () ->
    $('.start_chat').click ->
        console.log("chat_controller.create_chat")
        guest_id = $(this).parent().children("[name='user_id']").attr('content')
        console.log("guest_id:"+guest_id)
        token = $("[name='csrf-token']").attr("content")
        $.ajax '/create_chat',
            type: 'POST'
            dataType: 'json'
            data: {
                "guest_id":guest_id
            }
            headers: {"X-CSRF-Token":token}
            error: (jqXHR, textStatus, errorThrown) ->
                console.log "error:chat_controller.create_chat"
                alert("Error: could not create chat")
            success: (data, textStatus, jqXHR) ->
                if data["status"]=="created"
                    location.reload()
                else
                    alert("Error: could not create chat") 


search_users = () ->
    $("#users_searchbar").keyup ->


        filter = $('#users_searchbar').val().toUpperCase()
        ul = $("#admin_users_list")

        for item in $(ul).children()
            a = $(item).children("a")
            if $(a).text().toUpperCase().indexOf(filter) ==0
                $(item).css("display","")
            else
                $(item).css("display","none")

        return


poll = () ->

    token = $("[name='csrf-token']").attr("content")
    $.ajax '/poll',
        type: 'GET'
        dataType: 'json'
        data: {}
        headers: {"X-CSRF-Token":token}
        error: (jqXHR, textStatus, errorThrown) ->
            console.log "polling:::ajax request failed"

        success: (data, textStatus, jqXHR) ->
            # regex to get the index of a chat element
            regex = /chat_item_(.*)/

            # add new created chat
            if $(".chat_list_item").length < data.active_chats.length
                # ids of the chats in the chat index
                chat_index_ids = []
                $(".chat_list_item").each (index,elem) ->
                    chat_index_ids.push( parseInt(regex.exec($(elem).attr("id"))[1]) )
                for c in data.active_chats
                    unless c.chat_id in chat_index_ids
                        $("*").off()
                        $("#chats_list").append(chat_controller.render_chat_list_item(c.chat_id,c.username))
                        $("#profilepage").append(chat_controller.render_chat_div(c.chat_id))
                        chat_controller.show_chat()
                        chat_controller.hide_chat()
                        chat_controller.send_message()
                        chat_controller.delete_chat()
                        chat_controller.create_chat()
                        search_users()

            

            # delete inactive chats
            chat_ids = []
            for c in data.active_chats
                chat_ids.push(c.chat_id)
            $(".chat_list_item").each (index,elem) ->
                id = regex.exec($(elem).attr("id"))[1]
                unless parseInt(id) in chat_ids
                    $(elem).remove()
                    $("#"+id).remove()
            
            # add new message to chats
            for m in data.new_messages
                id = m.chat_id
                html = "<li class='received_message'><p class='message_text'>"+m.text+"</p></li>"
                $("#"+id).children(".message_box").append(html)
                $("#"+id).children(".message_box").animate({scrollTop: $("#"+id).children(".message_box").prop("scrollHeight")}, 500);

    setTimeout(poll, 5000)
    return

$(document).ready ->

    search_users()

    chat_controller.show_chat()
    chat_controller.hide_chat()

    chat_controller.send_message()
    chat_controller.delete_chat()
    chat_controller.create_chat()

    poll()

    return

    