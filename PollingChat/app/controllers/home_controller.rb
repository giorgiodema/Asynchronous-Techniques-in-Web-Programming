class HomeController < ApplicationController
    
    before_action :authenticate_user!

    def profile
        @user = current_user
        @chats = @user.chats
        @aux = {} # serve per memorizzare l'altro utente della chat
                  # all'interno della view
    end

    def users_list
        @user = params[:search][0] 
        @users = User.where( "username iLIKE?", "%#{@user}%") #ORDINARE?
        if @users.size.zero?
            flash[:alert] = "No result found"
            redirect_to root_path
        end
    end

end
