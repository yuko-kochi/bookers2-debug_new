class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    # @word = params[:word]
    # @range = params[:range]
    # if @range == "User"
    #   @users = User.looks(params[:search], params[:word])
    # elsif
    #   @books = Book.looks(params[:search], params[:word])
    # else
    #   redirect_back(fallback_location: root_path)
    # end
  end
  
end
