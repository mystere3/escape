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
  end

  def create
    @game = Game.new
    @game.user_id = current_user.id

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
    
    @game = Game.find(params[:game_id])
   
    
    # @game.init

    if params[:action_select].present? && params[:object_select].present?

      @game_message, @action_result, @secondary_result = @game.act_on_object(params[:action_select], params[:object_select], params[:use_on])

      if !params[:action_select].nil? && !@action_result.nil?
        case params[:object_select]
        when 'glassbox'
          @game.assign_attributes(:glassbox_open => @action_result)
          # @game.save
        when 'gloves'
          @game.assign_attributes(:gloves_has => @action_result)
          # @game.save
        when 'mop'
          @game.assign_attributes(:mop_has => @action_result)
          # @game.save
        when 'knife'
          @game.assign_attributes(:knife_has => @action_result)
        else
          @game_message = "Object outside of scope."
        end

        if !@secondary_result.nil?
          case @secondary_result
          when 'floor_dry'
            @game.assign_attributes(:floor_wet => false)
          when 'glassbox_open'
            @game.assign_attributes(:glassbox_open => true)
          when 'horror_staggered'
            @game.assign_attributes(:horror_staggered => true, :end_count => 3)
          when 'circuitbox_open'
            @game.assign_attributes(:circuitbox_open => true)
          else
            # do nothing.
          end
          
        end
        @game.save
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
  end

  def destroy
    @game = Game.find(params[:id])
    @game.destroy
    
    redirect_to games_path, notice: 'Game save deleted.'
  end

end
