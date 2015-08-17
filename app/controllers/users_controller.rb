class UsersController < ApplicationController
  def show
    respond_to do |format|
      format.svg { render inline: user.avatar.render }
    end
  end

  protected

  def user
    @user ||= UserPresenter.new(User.find(params[:id]))
  end
end
