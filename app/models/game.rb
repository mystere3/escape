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


  def act_on_object(action, object, use_on=nil)
    # binding.pry
    if object == 'gloves'
      # binding.pry
      self.gloves_action(action)
    elsif object == 'mop'
      self.mop_action(action, use_on)
    elsif object == 'glassbox'
      self.glassbox_action(action)
    elsif object == 'knife'
        self.knife_action(action, use_on)
    end
  end

  def gloves_action(action)
    if action == 'get' || action == 'use'
      self.get_gloves
    elsif action == 'open'
      return "The gloves can't be opened."
    elsif action == 'inspect'
      return "The gloves are yellow and appear to made entirely of a reasonably thick rubber. 
        They look like a well made, pricy, pair of dishwashing gloves."
    else
      return "Glove action outside of scope."
    end
  end

  def get_gloves
    if self.glassbox_open == true
      if self.gloves_has == true
        message = "You are already wearing the rubber gloves."
      else
        has_gloves = true
        message = "You put on the rubber gloves."
      end
    else
      message = "You can't get to the gloves. They are still locked in the glass box."
    end
    
    return message, has_gloves
  end

  def mop_action(action, use_on)
    if action == 'get'
      self.get_mop
    elsif action == 'use'
      self.use_mop(use_on)
    elsif action == 'open'
      return "You can't open a mop."
    elsif action == 'inspect'
      return "This is a very impressive mop. It has a strong metal handle and what appears to be a very modern mop head. This mop is so good that if you place it in a damp basement you could throw out the humidifier."
    else
      return "Mop action outside of scope."
    end
  end

  def get_mop
    if self.mop_has
      return "You already have the mop."
    else
      return "You are now holding the mop.", true
    end
  end

  def use_mop(use_on)
    if self.mop_has == true
      if use_on == ""
        return "You have to choose something to use the mop on."
      end
      case use_on
      when 'puddle'
        if self.floor_wet == true && self.outlets_on == true
          if self.gloves_has == true
            # still have mop, floor_wet = false
            return "Although the metal handled mop recieves an electric charge when it sops up the electrified water, the rubber gloves have insulated you and you are unaffected. This miraculous mop has left the floor perfectly dry.", true, 'floor_dry'
          else
            return "When you touch the mop to the puddle you feel a considerable electic shock that blows you back away from the puddle and the door."
          end
        else
          return "This fantastic state-of-the-art mop has left the floor completely dry.", true, 'floor_dry'
        end
      when 'glassbox'
        if self.glassbox_open == true
          message = "The glass box is already open so striking it with the mop would be pointless. It is also perfectly dry."
          message << self.gloves_has ? "\nThere is nothing else in the box." : "\nThe rubber gloves are in the glass box."
          return message
        else
          # still have mop, glassbox_open = true
          return "You smash open the glass box with the heavy metal handle of the mop. The rubber gloves inside have some glass on them but are undamaged.", true, 'glassbox_open'
        end
      when 'horror'
        if self.horror_in_room == true
          if self.horror_staggered == false
            # still have mop, horror_staggered = true
            return "You swing the heavy handled mop at the nameless horror. It staggers back a few steps mildly stunned.", true, 'horror_staggered'
          else
            return "The horror ignores additional attacks with the mop."
          end
        else
          return "The nameless horror isn't in the room with you."
        end
      else
        return "Swinging the mop at the #{use_on} has no effect. It has however left it perfectly dry. Although it probably already was."
      end
    else
      return "You don't have the mop."
    end
  end

  def knife_action(action, use_on)
    case action
    when 'get'
      self.get_knife
    when 'use'
      self.use_knife(use_on)
    when 'open'
      return "This knife can't be opened."
    when 'inspect'
      return "The knife is sufficiently sharp, has an weathered ivory handle and a 4 inch blade. The tip has quite a few scrapes and dings."
    else
      return "Knife action outside of scope."
    end
  end

  def get_knife
    if self.desk_open
      if self.knife_has
        return "You already have the knife."
      else
        return "You now have the knife.", true
      end
    else
      return "You don't see a knife in the room."
    end
  end

  def use_knife(use_on)
    if self.knife_has
      case use_on
      when 'circuitbox'
        if self.circuitbox_open
          return "You jab the knife in the open circuit box. You manage to scratch it up a bit."
        else
          # still have knife, circuitbox_open
          return "You stick the knife behind the edge of the door and manage to pry it open. Inside you see two circuit breakers. One is labelled 'Lights', the other 'Outlets'. They are both in the 'ON' position.", true, 'circuitbox_open'
        end
      when 'horror'
        if self.horror_in_room
          if self.horror_stabbed
            return "The horror is ready for additional next knife attacks and parries your attempt with ease."
          else
            return "You stab the nameless horror and it jumps back away from you granting you a quick moment of safety.", true, 'horror_stabbed'
          end
        else
          return "The nameless horror isn't in the room with you."
        end
      else
        return "Using the knife on that succeeds in nothing more than creating some scratches."
      end
    else
      return "You don't have the knife."
    end
  end

  def glassbox_action(action)
    return "Glassbox is open.", true
  end

end
