require './lib/joystick.rb'
require './lib/kodi.rb'
require './lib/es_input.rb'
require 'yaml'


es_input = EsInput.new("/home/pi/.emulationstation/es_input.cfg").parse
kodi = Kodi.new YAML.load_file('kodi.yml')
joystick = Joystick.new 

keybindings = YAML.load_file('keybindings.yml')

while true do
  joystick.update
  es_input.each do |input|
    if joystick.check input
      if keybindings.has_key? input[:name]
        kodi.exec keybindings[input[:name]]
      else
        print "no binding for #{input[:name]}\n"
      end
    end
  end
  sleep 0.05
end