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
      redirect_to game_path(@game), notice: "The horror is coming. You must get out of this room, and you can't get out the way you came in."
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
    if params[:paper].present?
      all_writing = @game.paper_content
      content_hash = params[:paper]
      all_writing << content_hash[:content]
      @game.assign_attributes(:paper_content => all_writing)
      @game.save
      @game_message = "You wrote on the paper."
      return redirect_to game_url(@game), notice: @game_message, alert: @horror_message
    end

    if params[:puzzlebox].present?
      puzzle_guess = params[:puzzlebox]
      @game_message, @attempt_result = @game.attempt_puzzle(puzzle_guess[:attempt])
      @game.assign_attributes(:puzzlebox_open => @attempt_result)

      @remaining_turns = @game.turns_remain - 1
      @game.assign_attributes(:turns_remain => @remaining_turns)
      if @game.end_count > 0
        @end_countdown = @game.end_count - 1
        @game.assign_attributes(:end_count => @end_countdown)
      end
      if @game.turns_remain <= 0 && @game.end_count <= 0
        @game.assign_attributes(:game_over => true)
      end

      @game.save

      if @game.game_over
        return redirect_to endgame_path(@game)
      end

      return redirect_to game_url(@game), notice: @game_message, alert: @horror_message
    end

    if params[:action_select].present? && params[:object_select].present?

      @game_message, @action_result, @secondary_result = @game.act_on_object(params[:action_select], params[:object_select], params[:use_on])

      if !@action_result.nil?
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
        when 'door'
          if @action_result == 'door_open'
            @game.assign_attributes(:door_open => true, :game_over => true)
          end
        when 'desk'
          @game.assign_attributes(:desk_open => @action_result)
        when 'pen'
          if @action_result == true
            @game.assign_attributes(:pen_has => true)
          elsif @action_result == 'write_paper'
            return redirect_to paper_content_path(@game)
          end
        when 'paper'
          if @action_result == true
            @game.assign_attributes(:paper_has => true)
          elsif @action_result == 'write_paper'
            return redirect_to paper_content_path(@game)
          end
        when 'puzzlebox'
          if @action_result == true
            @game.assign_attributes(:puzzlebox_has => true)
          elsif @action_result == 'puzzle_attempt'
            return redirect_to puzzlebox_path(@game)
          end
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
        @remaining_turns = @game.turns_remain - 1
        @game.assign_attributes(:turns_remain => @remaining_turns)
        if @game.end_count > 0
          @end_countdown = @game.end_count - 1
          @game.assign_attributes(:end_count => @end_countdown)
        end
        
        if @game.turns_remain <= 0 && @game.end_count <= 0
          @game.assign_attributes(:game_over => true)
        end
        
        @game.save

        if @game.game_over
          return redirect_to endgame_path(@game)
        end
      end

      # flash.keep(:notice)
      # redirect_to game_url(@game)
      redirect_to game_url(@game), notice: @game_message, alert: @horror_message
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

  def endgame
    
  end

  def paper_content
    @game = Game.find(params[:id])
  end

end
