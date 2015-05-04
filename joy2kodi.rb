require './lib/joystick.rb'
require './lib/kodi.rb'
require './lib/es_input.rb'

print "Starting joy2kodi\n"

es_input_cfg = (!ARGV[0]) ? "/home/pi/.emulationstation/es_input.cfg" : ARGV[0]
es_input = EsInput.new(es_input_cfg,'keybindings.yml')
kodi = Kodi.new YAML.load_file('kodi.yml')
joystick = Joystick.new 

while true do
  kodi.wait_for_it unless kodi.running
  joystick.update
  es_input.each do |input|
    kodi.exec input[:mapping] if joystick.check input
  end
  sleep 0.1
end
