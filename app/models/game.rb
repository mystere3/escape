class Game < ActiveRecord::Base
  belongs_to :user
  after_initialize :init
  # serialize :objects_hash

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
    self.puzzlebox_has = false if self.puzzlebox_has.nil?
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

    case object
    when 'gloves'
      self.gloves_action(action)
    when 'mop'
      self.mop_action(action, use_on)
    when 'knife'
      self.knife_action(action, use_on)
    when 'door'
      self.door_action(action)
    when 'desk'
      self.desk_action(action)
    when 'pen'
      self.pen_action(action, use_on)
    when 'paper'
      self.paper_action(action, use_on)
    when 'puzzlebox'
      self.puzzlebox_action(action)
    when 'key'
      self.key_action(action, use_on)
    when 'glassbox'
      self.glassbox_action(action)
    when 'circuitbox'
      self.circuitbox_action(action)
    when 'outlet'
      self.outlet_action(action)
    else

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
          # Not sure why the following line doesn't work, claims no implicit conversion of false to string.
          # message << self.gloves_has ? "\nThere is nothing else in the box." : "\nThe rubber gloves are in the glass box."
          if self.gloves_has
            message << "\nThere is nothing else in the box."
          else
            message << "\nThe rubber gloves are in the glass box."
          end
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
      self.inspect_knife
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

  def inspect_knife
    if self.desk_open
      return "The knife is sufficiently sharp, has an weathered ivory handle and a 4 inch blade. The tip has quite a few scrapes and dings."
    else
      return "You don't see a knife in the room."
    end
  end

  def door_action(action)
    case action
    when 'get'
      return "You can't get the door."
    when 'use', 'open'
        self.open_door
      when 'inspect'
        self.inspect_door
    else  
      return "Door action outside of scope."
    end
  end

  def open_door
    if self.door_locked
      if self.floor_wet && self.outlets_on
        return "When your bare feet touch the water on the floor as you go to the door you are jolted by an electric shock and thrown back away from the door."
      else
        return "You try the handle but the door is locked."
      end
    else
      # door_open
      return "The unlocked doorhandle turns and you open the door.", 'door_open'
    end
  end

  def inspect_door
    message = "This is an old style door made of solid wood that won't break easily. The door jamb also appears to be constructed of quality materials that will withstand considerable punishment. There is a keyhole below the doorhandle. "
    if self.door_open
      message << "The door is open."
    elsif self.floor_wet && self.outlets_on
      message << "The door is closed but you have not been able to test to see if it is locked."
    elsif self.door_locked
      message << "The door is closed and appears to be locked."
    else
      message << "The door is closed but unlocked."
    end
  end

  def desk_action(action)
    case action
    when 'get'
      return "You can't get the desk."
    when 'use'
      return "Spending time sitting at a desk doesn't seem like the wisest use of your time."
    when 'open'
      self.open_desk
    when 'inspect'
      self.inspect_desk
    else
      return "Desk action outside of scope."
    end
  end

  def open_desk
    if self.desk_open
      return "The desk drawer is already open."
    else
      return "You open the desk drawer. Inside you see a pen and a knife with an ivory handle and 4 inch blade. The blade tip is considerbly scratched and dinged.", true
    end
  end

  def inspect_desk
    description = "This is a beautiful mohagany desk that has been very well taken care of. "
    if self.paper_has == false
      if self.paper_content.length == 0
        description << "A blank piece of paper lays on top of the desk. "
      else
        description << 'There is a piece of paper on the desk on which you have written "' << self.paper_content << '". '
      end
    end
    if self.puzzlebox_has == false
      description << "There is a puzzle box on top of the desk. "
    end
    if self.desk_open
      description << "The drawer on the front of the desk is open.  "
      if self.pen_has == false
        description << "A pen is in the drawer. "
      end
      if self.knife_has == false
        description << "There is an ivory handled 4 inch knife in the drawer. "
      end
    else
      description << "The drawer on the front of the desk is closed."
    end
    return description
  end

  def pen_action(action, use_on)
    case action
    when 'get'
      self.get_pen
    when 'use'
      self.use_pen(use_on)
    when 'open'
      return "You can't open this pen."
    when 'inspect'
      self.inspect_pen
    else
      return "Pen action outside of scope."
    end
  end

  def get_pen
    if self.desk_open
      if self.pen_has
        return "You already have the pen."
      else
        return "You take the pen.", true
      end
    else
      return "You don't see a pen in the room."
    end
  end

  def use_pen(use_on)
    if self.pen_has
      if use_on == 'paper'
        return " ", "write_paper"
      else
        return "You scribble on the #{use_on}"
      end
    else
      return "You don't have the pen."
    end
  end

  def inspect_pen
    if self.desk_open
      return "This is a fairly expensive but tasteful refillable ball point pen."
    else
      return "You don't see a pen in the room."
    end
  end

  def paper_action(action, use_on)
    case action
    when 'get'
      self.get_paper
    when 'use'
      self.use_paper(use_on)
    when 'open'
      return "The paper can't be opened, it's an uncrumpled sheet with no folds."
    when 'inspect'
      self.inspect_paper
    end
  end

  def get_paper
    if paper_has
      return "You already have the piece of paper."
    else
      return "You now have a blank piece of paper.", true
    end
  end

  def use_paper(use_on)
    if use_on == 'pen'
      if self.pen_has
        return " ", "write_paper"
      else
        return "You don't have the pen."
      end
    elsif use_on == ""
      return "You can't use paper with or on nothing."
    else
      return "You can't use the paper with #{use_on}"
    end
  end

  def inspect_paper
    if self.paper_content.length == 0
      return "It is a blank piece of 28lb bright white paper. Probably from Staples."
    else
      return "On this paper you have written: " << self.paper_content
    end
  end

  def puzzlebox_action(action)
    case action
    when 'get'
      self.get_puzzlebox
    when 'use', 'open'
      self.use_puzzlebox
    when 'inspect'
      self.inspect_puzzlebox
    end
  end

  def get_puzzlebox
    if self.puzzlebox_has
      return "You already have the puzzle box."
    else
      return "You take the puzzle box.", true
    end
  end

  def use_puzzlebox
    if self.puzzlebox_open
      message = "The puzzle box is already open. "
      if self.key_has == false
        message << "The key is still inside."
      end
      return message
    else
      return " ", 'puzzle_attempt'
    end
  end

  def inspect_puzzlebox
    description = "This puzzle box has an image of a key and five buttons on the lid. Four are labelled with letters. These buttons, in order left to right, are labelled: E U N Q. In front of the buttons is an additional button labelled ENTER. "
    if self.puzzlebox_open
      description << "Having solved the puzzle, the lid is now open. "
      if self.key_has
        description << "You have taken the key that was in the box. There is nothing in here now. "
      else
        description << "There is a key inside the box. "
      end
    else
      description << "The box is locked shut."
    end
    return description
  end

  def attempt_puzzle(entry)
    
    entry.upcase!
    entry.tr!(' ,.;:()[]{}"\'!@#$%^&*|/><?`~\-_1234567890=+WRTYIOPASDFGHJKLZXCVBM', '')
    if entry.length < 5
      return "You enter '#{entry}' but the box fails to open.", false
    else
      if entry == 'QUEEN'
        return "You enter #{entry}. The box emits a click and then opens. Inside you see a key.", true
      else
        return "You enter '#{entry}' but the box fails to open.", false
      end
    end
  end

  def key_action(action, use_on)
    case action
    when 'get'
      self.get_key
    when 'use', 'open'
      self.use_key(use_on)
    when 'inspect'
      return "It's a pretty standard key. Made of metal, round head, grooves along the length, teeth along the bottom."
    else
      return "Key action outside of scope."
    end
  end

  def get_key
    if self.key_has
      return "You already have the key."
    else
      if self.puzzlebox_open
        return "You take the key from inside the box.", true
      else
        return "You don't see a key in the room."
      end
    end
  end

  def use_key(use_on)
    if self.key_has
      case use_on
      when 'door'
        if self.door_locked == false
          return "The door is already unlocked."
        else
          if self.floor_wet && self.outlets_on
            # still has key, door still locked. Costs an action even though fail.
            return "When you step into the puddle to try the key in the door you recieve an electric shock and are knocked back away from the door.", true
          else
            # still has key, door unlocked
            return "The key slides in the lock easily. You unlock the door.", true, 'door_unlocked'
          end
        end
      when 'glassbox'
        return "The key doesn't fit in the glass box's lock."
      when 'circuitbox'
        return "The circuit box doesn't have a lock to use a key on."
      when 'puzzlebox'
        return "The puzzle box doesn't have a keyed lock."
      else
        return "You can't use the key with the #{use_on}"
      end
    else
      return "You don't have the key."
    end
  end

  def glassbox_action(action)
    case action
    when 'get'
      return "The glass box is embedded in the wall and can't be removed."
    when 'use', 'open'
      self.use_glassbox
    when 'inspect'
      self.inspect_glassbox
    end
  end

  def use_glassbox
    if self.glassbox_open == false
      message = "The glass box is locked and securely attached to the wall."
    else
      message = "The glass box has been smashed open allowing access to its contents."
      if self.gloves_has
        message << "You have taken the rubber gloves that were in here."
      else
        message << "There is a pair of rubber gloves inside."
      end
    end
    return message
  end

  def inspect_glassbox
    message = "This is a 'glass box' embedded in the wall much like one you would see in many buildings containing emergency fire equipment. It has a metal door with a keyable lock. "
    if self.glassbox_open == false
      message << "A large portion of the door is made of glass, revealing the glass box's contents."
    else
      message << "The glass has been broken out of the door allowing access to the box. "
    end
    if self.gloves_has
      message << "You have taken the rubber gloves that were in here. There is nothing else in the box."
    else
      message << "There is a pair of yellow rubber gloves inside the box."
    end
    return message
  end

  def circuitbox_action(action)
    case action
    when 'get'
      return "The circuit box is embedded in the wall and can't be removed"
    when 'use'
      self.use_circuitbox
    when 'open'
      self.open_circuitbox
    when 'inspect'
      self.inspect_circuitbox
    else
      return "Circuitbox action outside of scope."
    end
  end

  def use_circuitbox
    if self.circuitbox_open
      return " ", 'circuits'
    else
      return "The circuit box is closed."
    end
  end

  def lights_toggle(lights)
    # binding.pry
    if self.lights_on
      if lights == 'on'
        # binding.pry
        return "You left the lights circuit on. ", true
      else
        # binding.pry
        return "You flip the lights circuit to the off position. ", false
      end
    else
      if lights == 'off'
        # binding.pry
        return "You left the lights circuit off. ", false
      else
        # binding.pry
        return "You flipped the lights circuit into the on position. ", true
      end
    end
  end

  def outlets_toggle(outlets)
    # binding.pry
    if self.outlets_on
      if outlets == 'on'
        # binding.pry
        return "You left the outlets circuit on. ", true
      else
        # binding.pry
        return "You flip the outlets circuit to the off position. ", false
      end
    else
      if outlets == 'off'
        # binding.pry
        return "You left the outlets circuit off. ", false
      else
        # binding.pry
        return "You flipped the outlets circuit back into the on position. ", true
      end
    end
  end

  def open_circuitbox
    if self.circuitbox_open
      return "The circuit box door is already open."
    else
      return "There is a small lip on the circuit box door that's used to open it but the door is very tight and your fingers can't get enough purchase to open it. You see many scratches worn into area next to the lip. "
    end
  end

  def inspect_circuitbox
    description = "The circuit box is in the wall near the door. You don't have to step in the puddle to get to it. "
    if self.circuitbox_open == false
      description << "The door to the circuit box is closed. On the right side of the door is a small lip intended to assist in opening the box. There are a lot of scratches in the wall immediately next to the lip. "
    else
      description << "The door to the circuit box is open, inside you see two circuit breakers. One is marked 'Lights', the other 'Outlets'. "
      if self.lights_on
        description << "The breaker for the lights is in the on position. "
      else
        description << "The breaker for the lights is in the off position. "
      end
      if self.outlets_on
        description << "The outlets breaker is #{"also " if self.lights_on == true}set to on. "
      else
        description << "The outlets breaker is #{"also " if self.lights_on == false}set to off. "
      end
    end
    return description
  end

  def outlet_action(action)
    case action
    when 'get'
      return "You can't take the outlet. "
    when 'use'
      return "There is nothing to plug into the outlet. And it doesn't look entirely safe. "
    when 'open'
      return "The outlets are already dangling, they can't get more open than that. "
    when 'inspect'
      self.inspect_outlet
    else
      return "Outlet action outside of scope. "
    end
  end

  def inspect_outlet
    description = "The outlet is to the right of the door you want to exit through. The outlet no longer has plugs or a faceplate. All that's left are exposed wires which reach down far enough to touch the floor. "
    if self.floor_wet
      description << "The ends of the wires are sitting in the pool of water on the floor. "
    end
    if self.outlets_on
      description << "The wires appear to be live, which is evident because the wires spark periodically. "
    else
      description << "The wires are no longer sparking every few seconds, the power feeding them seems to have been successfully turned off. "
    end
    return description
  end

  def move_horror
    if self.end_count == 0
      case self.turns_remain
      when 8
        return "You shudder as you hear the nameless horror getting closer as it moves down the hall to the door you locked behind you. "
      when 7
        return "The horror has picked up speed. You hear him almost at the door."
      when 6
        return "The horror is just outside the door. You see the door handle turn and the door press in toward you. Thankfully the bolt holds and the horror remains outside the room. "
      when 5
        return "You nearly jump out of your skin as a deafening blast issues from the door. The nameless horror wants in, and it appears it will get what it wants. "
      when 4
        return "Again the nameless horror slams against the door. This time you see that it is getting results. The jamb is beginning to crack as the bolt also seems to be desperately trying to escape the horror. The bolt is pushing the entire lockplate and jamb out of the wall and in your direction. "
      when 3
        return "You don't know if it's using body or some unknown force, but the result is the same. The nameless horror has taken this door to the brink of destruction. The door jamb has splintered and the door is bowed in and riddled with cracks. One more blow and the door will no longer separate you. "
      when 2
        return "With a final shattering blast, the nameless horror obliterates the door. Standing just outside the room, as his gaze bores into you, you feel an emptiness as if your very soul is being pulled out of you. "
      when 1
        return "The nameless horror has stepped into the room. ", true
      when 0
        return "0", true
      else
        return "below 0"
      end
    else
      if self.horror_stabbed && self.horror_staggered
        case end_count
        when 4
          return "Reeling from your blows the horror is visibly staggered. The blood issuing from the stab wound you inflicted is a dark crimson bordering on black and has a consistency that can't quite decide if it's a sludgy liquid or a heavy gas. "
        when 3
          return "Beginning to recover again, the horrors gaze locks on you. The fury emanating from it is palpable, it can almost be tasted. "
        when 2
          return "Recovered and filled with liquid hate that is literally pouring out of him, the nameless horror prepares to obliterate you. "
        else
          return "move_horror end_count out of scope. (stabbed/staggered)"
        end
      elsif self.horror_stabbed
        case end_count
        when 4
          return "Visibly shocked at what happened, the horror's attention focuses at itself as it surveys the damage you inflicted. "
        when 3
          return "Though the nearly black smoky sludge it uses for blood still ooses from its wound, the horror has recovered. It won't be long now. "
        when 2
          return "You sense the horror's hunger and satisfaction. You feel like a mouse captured by a cat, seconds before the cat stops playing games and finally ends the mouses torment. "
        else
          return "move_horror end_count out of scope. (stabbed)"
        end
      elsif self.horror_staggered
        case end_count
        when 4
          return "Your blow has managed to knock the horror to the ground. It is very clearly staggered. "
        when 3
          return "The nameless horror wastes no time recovering. It's regained it's feet and has refocused its attention on you. "
        when 2
          return "Fully recovered and looming over you, the horror's revenge won't have time to get cold. It's being served now. "
        else
          return "move_horror end_count out of scope. (staggered)"
        end
      else 
        return "Move horror end_count, horror damage out of scope. " 
      end
    end
  end

  def end_game
    if self.lights_on == false
      return "Lights out ending."
    elsif self.door_open
      return "Door open, escape room."
    elsif self.turns_remain <= 0 && self.end_count <= 0
      if self.horror_staggered && self.horror_stabbed
        return "Horror got you ending, stabbed and staggered."
      elsif self.horror_staggered
        return "Horror got you ending, staggered."
      elsif self.horror_stabbed
        return "Horror got you ending, stabbed."
      else
        return "Horror got you ending, no damage."
      end
    end
  end

end







