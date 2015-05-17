class WelcomeController < ApplicationController
  def index
    @game = Game.new
  end

  def show
  end
  
end
