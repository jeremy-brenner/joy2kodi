require './lib/joystick.rb'
require './lib/kodi.rb'
require './lib/es_input.rb'

es_input = EsInput.new("/home/pi/.emulationstation/es_input.cfg",'keybindings.yml')
kodi = Kodi.new YAML.load_file('kodi.yml')
joystick = Joystick.new 

while kodi.wait_for_it do
  joystick.update
  es_input.each do |input|
    kodi.exec input[:mapping] if joystick.check input
  end
  sleep 0.1
end
