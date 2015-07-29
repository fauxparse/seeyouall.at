class EventsController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show]

  def index
  end

  def show
  end

  def new
  end
end
