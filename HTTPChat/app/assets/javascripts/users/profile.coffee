
chat_controller = {}

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
            alert "ERROR"+jqXHR.status+": could not send message"
        success: (data, textStatus, jqXHR) ->
            if jqXHR.status >= 200 && jqXHR.status<300
                $("#"+msg.chat_id).children(".input_box").val("")
                $("#"+msg.chat_id).children(".message_box").append("<li class=sent_message><p class=message_text> "+msg.text+" </p></li>")
                $("#"+msg.chat_id).children(".message_box").animate({scrollTop: $("#"+msg.chat_id).children(".message_box").prop("scrollHeight")}, 500);
            else
                alert "ERROR: "+textStatus
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



$(document).ready ->

    search_users()

    chat_controller.show_chat()
    chat_controller.hide_chat()

    chat_controller.send_message()
    chat_controller.delete_chat()
    chat_controller.create_chat()

    return

    