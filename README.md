# joy2kodi
Joystick library for kodi + emulationstation on the raspberry pi

The RetroPie project: http://blog.petrockblock.com/retropie/

Kodi for the Raspberry Pi does NOT support joysticks.  It relys on X + SDL to get joystick input.  This is a hack that will allow you to control kodi with the same joystick you use for emulationstation.  For some reason Kodi freezes up joystick input even though they do not work.  

The first thing to do is run kodi under a user that does NOT have access to the joystick device.  The kodi user should probaly already exist and is perfect for this.

    vim /home/pi/RetroPie/roms/ports/Kodi.sh

change:

    kodi-standalone
to:

    sudo -ukodi kodi-standalone

Also the kodi user will need permission to run chvt as root:

    sudo vim /etc/sudoers

Then add this line:

    kodi ALL=(root) NOPASSWD: /bin/chvt

Keep in mind, if you mess up sudoers you will have to connect your sd card to another computer and fix it because you wont be able to sudo.

Next install dependencies:

    sudo apt-get update
    sudo apt-get install ruby ruby-dev
    sudo gem install bundler
    
Then clone the joy2kodi repository and install gems:

    git clone https://github.com/jeremy-brenner/joy2kodi
    cd joy2kodi
    bundle install
  
Make sure you have kodi accessible via http.   Under System > Settings > Services > Webserver.  Choose allow control of Kodi via HTTP and make sure the username/password are set.  The kodi.yml file in the joy2kodi dir can be edited if you use anything other than 8080 kodi/kodi.
    
You can run joy2kodi from the console like this:

    ruby joy2kodi.rb 

Optionally you can point to a different input config:

    ruby joy2kodi.rb /home/pi/.emulationstation/es_input.cfg
  
You should get output similar to:

    Starting joy2kodi
    Got joystick with 11 buttons, 1 hats, and 6 axes.
    Waiting for Kodi...
    Waiting for Kodi...
    Waiting for Kodi...
    Waiting for Kodi...
    Waiting for Kodi...
    Kodi is alive!
    Calling Input.Right
    Calling Input.Left
    Calling Input.Left
    Calling Input.Down
    Calling Input.Down

If all is well you can add it to your profile

    sudo vim /etc/profile

Add this line at the bottom BEFORE emulationstation. If you forget the "&" emulationstation will never start.

    [ -n "${SSH_CONNECTION}" ] || ( cd /home/pi/joy2kodi; ruby joy2kodi.rb > joy2kodi.log ) &

Reboot and pray to the diety of your choice.
If all goes well you should have seemless joystick support for emulationstation + kodi.
