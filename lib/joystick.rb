require 'ruby-sdl-ffi'

class Joystick
  def initialize
    SDL.Init( SDL::INIT_JOYSTICK )
    raise "No SDL joystick available" if SDL.NumJoysticks == 0
    @joystick = SDL.JoystickOpen(0)
    print "Got joystick with #{buttons} buttons, #{hats} hats, and #{axes} axes.\n"
  end

  def button(n)
    SDL.JoystickGetButton @joystick, n
  end

  def buttons
    SDL.JoystickNumButtons @joystick
  end

  def hat(n)
    SDL.JoystickGetHat @joystick, n
  end

  def hats
    SDL.JoystickNumHats @joystick
  end

  def axis(n)
    SDL.JoystickGetAxis @joystick, n
  end

  def axes
    SDL.JoystickNumAxes @joystick
  end

  def update
    SDL.JoystickUpdate
  end
 
  def check(input)
    send( input[:type].to_sym, input[:id].to_i ).to_i == input[:value].to_i
  end

  def button_events
    (0...buttons).map { |n| button n }
  end

  def hat_events
    (0...hats).map { |n| hat n }
  end

  def axis_events
    (0...axes).map { |n| axis n }
  end

  def events
    {
      hat_events: hat_events,
      axis_events: axis_events,
      button_events: button_events
    }
  end

end