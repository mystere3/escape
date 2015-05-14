class WelcomeController < ApplicationController
  def index
    if current_user
      redirect_to "/games"
    end
  end

  def show
  end
  
end
