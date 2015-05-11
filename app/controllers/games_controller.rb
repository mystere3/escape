class GamesController < ApplicationController

before_action :authenticate_user!

  def index
    @game = Game.new

  end

  def show
    @game = Game.find(params[:id])
    # binding.pry
  end

  def new
    @game = Game.new
    binding.pry
  end

  def create
    @game = Game.new
    @game.user_id = current_user.id
    binding.pry

    if @game.save
      redirect_to game_path(@game), notice: 'New game started.'
    else
      flash[:alert] = "There was an error starting new game."
      render :root
    end

  end

  def edit
    

  end

  def update
    binding.pry
    
    @game = Game.find(params[:game_id])
   
    
    # @game.init

    if params[:action_select].present? && params[:object_select].present?
      binding.pry

      @game_message, @action_result = @game.act_on_object(params[:action_select], params[:object_select])

      
      binding.pry
      if !params[:action_select].nil?
        case params[:object_select]
        when 'glassbox'
          @game.assign_attributes(:glassbox_open => @action_result)
          binding.pry
          @game.save
          binding.pry
        when 'gloves'
          @game.assign_attributes(:gloves_has => @action_result)
          binding.pry
          @game.save
          binding.pry
        else
          @game_message = "Outside of scope."
        end
        
      end

      # flash.keep(:notice)
      # redirect_to game_url(@game)
      redirect_to game_url(@game), notice: @game_message
      # I'm just trying to get this to update ANY attibute
      # @game.assign_attributes(:glassbox_open => true)
      # if @game.save
      #   redirect_to game_url(@game), notice: 'Game was updated successfully'
      #   binding.pry
      # else
      #   @error_msg = 'There was an error updating the game'
      #   binding.pry
      #   redirect_to game_url(@game)
      # end


    end
    
    # render :show
  end

  def destroy
    @game = Game.find(params[:id])
    @game.destroy
    
    redirect_to games_path, notice: 'Game save deleted.'
  end

    def game_params
    # binding.pry
    params.require(:game).permit(:name, :student_id)
  end

end
