class Game < ActiveRecord::Base
  belongs_to :user
  after_initialize :init
  serialize :objects_hash

  def init
    self.gloves_has = false if self.gloves_has.nil?
    self.mop_has = false if self.mop_has.nil?
    self.knife_has = false if self.knife_has.nil?
    self.door_locked = true if self.door_locked.nil?
    self.door_open = false if self.door_open.nil?
    self.desk_open = false if self.desk_open.nil?
    self.pen_has = false if self.pen_has.nil?
    self.paper_has = false if self.paper_has.nil?
    self.paper_content ||= ""
    self.puzzlebox_open = false if self.puzzlebox_open.nil?
    self.key_has = false if self.key_has.nil?
    self.glassbox_open = false if self.glassbox_open.nil?
    self.circuitbox_open = false if self.circuitbox_open.nil?
    self.lights_on = true if self.lights_on.nil?
    self.outlets_on = true if self.outlets_on.nil?
    self.horror_in_room = false if self.horror_in_room.nil?
    self.horror_staggered = false if self.horror_staggered.nil?
    self.horror_stabbed = false if self.horror_stabbed.nil?
    self.floor_wet = true if self.floor_wet.nil?
    self.turns_remain ||= 8
    self.game_over = false if self.game_over.nil?
    self.end_count ||= 0
    # self.objects_array = ["Gloves", "Mop", "Knife", "Door", "Desk", "Pen", "Paper", "Key", "Glass Box", "Circuit Box", "Outlet", "Puzzle Box", "Nameless Horror"]
    # self.objects_array << "Gloves"
    # self.objects_array << "Mop"

    # ["Gloves", "Mop", "Knife", "Door", "Desk", "Pen", "Paper", "Key", "Glass Box", "Circuit Box", "Outlet", "Puzzle Box", "Nameless Horror"]
            
  end


  def act_on_object(action, object)
    # binding.pry
    if object == 'gloves'
      # binding.pry
      self.gloves_action(action)
    elsif object == 'glassbox'
      self.glassbox_action(action)
    end
  end

  def gloves_action(action)
    if action == 'get' || action == 'use'
      self.get_gloves
    elsif action == 'open'
      return "The gloves can't be opened.", self
    elsif action == 'inspect'
      return "The gloves are yellow and appear to made entirely of a reasonably thick rubber. 
        They look like a well made, pricy, pair of dishwashing gloves.", self
    end
  end

  def get_gloves
    binding.pry
    if self.glassbox_open == true
      if self.gloves_has == true
        message = "You are already wearing the rubber gloves."
      else
        self.gloves_has = true
        message = "You put on the rubber gloves."
      end
    else
      message = "You can't get to the gloves. They are still locked in the glass box."
    end
    
    binding.pry
    return message, self
  end

  def glassbox_action(action)
      self.glassbox_open = true
      return "Glassbox is open.", self
  end

end
