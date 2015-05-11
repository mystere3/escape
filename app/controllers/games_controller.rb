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
    @game = Game.new
    # @game.init
    # binding.pry
    if params[:action_select].present? && params[:object_select].present?
      # binding.pry
      @game_message, @game = @game.act_on_object(params[:action_select], params[:object_select])
      binding.pry
      if @game.update_attributes(glassbox_open: true)
        render :show, notice: 'Game was updated successfully'
        binding.pry
      else
        @error_msg = 'There was an error updating the game'
        binding.pry
        render :show
      end
      # if !@action_select.nil?
      #   case params[:object_select]
      #   when 'glassbox'
      #     @game.glassbox_open = @action_result
      #   when 'gloves'
      #     @game.gloves_has = @action_result
      #   else
      #     @game_message = "Outside of scope."
      #   end

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
