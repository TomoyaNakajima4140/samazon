class Dashboard::UsersController < ApplicationController
    before_action :authenticate_admin!
  layout "dashboard/dashboard"

 def index
   @users = User.display_list(params[:pages])
   if params[:keyword].present?
     keyword = trim(params[:keyword])
     @users = User.search_infomation(keyword).display_list(params[:pages])
   else
     keyword = ""
     @users = User.display_list(params[:pages])
   end
 end
 
 def destroy
     
     
     user = User.find(params[:id])
    #  user.update(deleted_flg: User.switch_flg(user.deleted_flg))
     user.deleted_flg = User.switch_flg(user.deleted_flg)
     user.save
     redirect_to dashboard_users_path
 end
end
