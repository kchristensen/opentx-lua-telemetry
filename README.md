## LUA telemetry screen for OpenTX

This was originally written by [NI0X](http://rcsettings.com/index.php/viewdownload/13-lua-scripts/144-dji-phantom-naza-icon-telemetry-script) and modified by [pobskil](http://www.reddit.com/r/Multicopter/comments/37eskq/getting_in_on_the_lua_telemetry_scripts_running_a/).

I integrated the bits of their code I liked and refactored it to slim it down.

### Features
* Auto detects battery cell count
* Displays the following information:
  * RSSI signal strength
  * TX battery voltage reading
  * LiPo battery voltage reading
  * Flight mode
  * Flight timer
  * Arm Status

### Configuration
You may have to edit the LUA script based on how you have your model configured. On my model, I arm via the SA switch, and use the SE switch to toggle between flight modes. Changing these channels is as easy as replacing MIXSRC_SX in the code with whichever switch you prefer.

### Installation
* Copy the images in the `BMP` directory to `/SCRIPTS/BMP/` on your transmitter's SD card.
* Copy the `modelname` directory to `/SCRIPTS/<modelname>` on your transmitter's SD card, where <modelname> is the exact name of the model you want to associate this script with.

Once installation is complete, the first telemetry screen of your model should look something like this:

![Screenshot](screenshot.png)

### License

Feel free to modify and redistribute as you like.
