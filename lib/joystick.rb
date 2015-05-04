require 'ruby-sdl-ffi'

class Joystick
  def initialize
    init_sdl
  end
  def init_sdl
    SDL.Init( SDL::INIT_JOYSTICK )
    raise "No SDL joystick available" if SDL.NumJoysticks == 0
    @joystick = SDL.JoystickOpen(0)
  end

  def buttons
    SDL.JoystickNumButtons(@joystick)
  end

  def button_events
    (0...buttons).map { |button| SDL.JoystickGetButton(@joystick, button) }
  end

  def hats
    SDL.JoystickNumHats(@joystick)
  end

  def hat_events
    (0...hats).map { |hat| SDL.JoystickGetHat(@joystick, hat) }
  end

  def axes
    SDL.JoystickNumAxes(@joystick)
  end

  def axis_events
    (0...axes).map { |axis| SDL.JoystickGetAxis(@joystick,axis) }
  end

  def update
    SDL.JoystickUpdate
  end

  def events
    update
    {
      hat_events: hat_events,
      axis_events: axis_events,
      button_events: button_events
    }
  end

end