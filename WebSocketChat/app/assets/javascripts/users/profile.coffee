
window.chat_controller = {}

window.chat_controller.render_chat_list_item = (chat_id,username,status)->

    res =  '<li class="list-group-item list-group-item-action chat_list_item" id="chat_item_'+chat_id+'">
            <meta name="chat_id" content="'+chat_id+'">
            <img alt="Image" class="chat_user_img" src="/assets/fallback/default-9edf194a00f1dcda7e15e43175301617516db9056902d19fc5f13b4e73afcec4.jpg">
            
            <p>
                '+username+'
            </p>'
    if status == "online"
        res += '
        <p class="status_online" style="display:block;"> online </p>
        <p class="status_offline" style="display:none;"> offline </p>
        '
    else
        res += '
        <p class="status_online" style="display:none;"> online </p>
        <p class="status_offline" style="display:block;"> offline </p>
        '
    res += '
            <input type="button" class="delete_chat btn-sm" value="delete">
        </li>'
    return res

window.chat_controller.render_chat_div = (chat_id) ->
    return '<div class="col-md-8 chat_div" id="'+chat_id+'" style="display: none;">
            <div class="col-md-12 list-group-item list-group-item-action active chat_top">
                <input type="button" name="close_chat" value="close">
            </div>
            <ul class="jumbotron message_box">
            </ul>
            <textarea class="form-control input_box"></textarea>
        </div>'

# Hides chat when close button is clicked
window.chat_controller.hide_chat = () ->   
    $("[name='close_chat']").click ->
        $(".chat_div").css("display","none")
        $(".left_panel").css("display","block")
        $(".list-group").css("display","block")
        return


# View the selected chat from the chat index
window.chat_controller.show_chat = () ->   
    $(".chat_list_item").click ->
        $(".left_panel").css("display","none")
        $(".list-group").css("display","none")
        $(".chat_div").css("display","none")
        id = $(this).children("[name='chat_id']").attr("content")
        $("#"+id.toString()).css("display","block")
        $("#"+id).children(".message_box").animate({scrollTop: $("#"+id).children(".message_box").prop("scrollHeight")}, 500);
        return

window.chat_controller.send_message = () ->
    $(".chat_div").keypress (e) ->
        if e.keyCode == 13
            msg = {
                chat_id: $(this).attr("id")
                text: $(this).children(".input_box").val()
            }
            window.chat_controller.post_message(msg)
            

        
window.chat_controller.post_message = (msg) ->
    console.log('post_message')
    token = $("[name='csrf-token']").attr("content")
    $.ajax '/send_message',
        type: 'POST'
        dataType: 'json'
        data: { msg }
        headers: {"X-CSRF-Token":token}
        error: (jqXHR, textStatus, errorThrown) ->
            console.log "error:window.chat_controller.post_message"
        success: (data, textStatus, jqXHR) ->
            console.log "Status:"+textStatus
            console.log "Data:"+data["myanswer"]
            $("#"+msg.chat_id).children(".input_box").val("")
            $("#"+msg.chat_id).children(".message_box").append("<li class=sent_message><p class=message_text> "+msg.text+" </p></li>")
            $("#"+msg.chat_id).children(".message_box").animate({scrollTop: $("#"+msg.chat_id).children(".message_box").prop("scrollHeight")}, 500);

window.chat_controller.delete_chat = () ->
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
                console.log "error:window.chat_controller.delete_chat"
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
                        
window.chat_controller.create_chat = () ->
    $('.start_chat').click ->
        console.log("window.chat_controller.create_chat")
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
                console.log "error:window.chat_controller.create_chat"
                alert("Error: could not create chat")
            success: (data, textStatus, jqXHR) ->
                $("*").off()
                $("#chats_list").append(window.chat_controller.render_chat_list_item(data.chat_id,data.username,"offline"))
                $("#profilepage").append(window.chat_controller.render_chat_div(data.chat_id))

                window.search_users()
                window.chat_controller.show_chat()
                window.chat_controller.hide_chat()
                window.chat_controller.send_message()
                window.chat_controller.delete_chat()
                window.chat_controller.create_chat()


window.search_users = () ->
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



$(document).ready ->

    window.search_users()

    window.chat_controller.show_chat()
    window.chat_controller.hide_chat()

    window.chat_controller.send_message()
    window.chat_controller.delete_chat()
    window.chat_controller.create_chat()

    return

    