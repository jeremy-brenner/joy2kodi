require './lib/joystick.rb'
require './lib/kodi.rb'
require 'yaml'

kodi = Kodi.new YAML.load_file('kodi.yml')
joystick = Joystick.new 

keybindings = YAML.load_file('keybindings.yml')


while true do
  events = joystick.events
  keybindings["hats"].each do |hat,values|
    values.each do |key,value|
      if events[:hat_events][hat] == key
        kodi.exec value
      end
    end
  end
  keybindings["buttons"].each do |button,value|
    if events[:button_events][button] == 1
      kodi.exec value
    end
  end
  sleep 0.05
end