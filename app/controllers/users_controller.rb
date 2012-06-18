class UsersController < ApplicationController
   before_filter :signed_in_user,   only: [:index, :edit, :update, :destroy]
   before_filter :correct_user,     only: [:edit, :update]
   before_filter :admin_user,       only: :destroy

   def destroy
      user = User.find(params[:id])
      if current_user?(user)
         flash[:error] = "Don't delete yourself."
      else
         user.destroy
         flash[:success] = "User destroyed."
      end
      redirect_to users_path
   end

   def index
      if current_user.admin?
         @users = User.paginate(:page => params[:page], :per_page => 20)
      else
         redirect_to root_path
      end
   end

   def new
      if signed_in?
         redirect_to root_path
      else
         @user = User.new
      end
   end
   
   def show
      @user = User.find(params[:id])
   end

   def create
      if signed_in?
         redirect_to root_path
      else
         @user = User.new(params[:user])
         if @user.save
            sign_in @user
            flash[:success] = "Welcome to your tools collection, #{@user.name}."
            redirect_to @user
         else
            render 'new'
         end
      end
   end

   def edit
   end

   def update
      if @user.update_attributes(params[:user])
         flash[:success] = "Your profile is now updated."
         sign_in @user
         redirect_to @user
      else
         render 'edit'
      end
   end


   private

      def signed_in_user
         unless signed_in?
            store_location
            redirect_to signin_path, notice: "Please sign in." 
         end
      end

      def correct_user
         @user = User.find(params[:id])
         redirect_to(root_path) unless current_user?(@user)
      end

      def admin_user
         redirect_to(root_path) unless current_user.admin?
      end
end
