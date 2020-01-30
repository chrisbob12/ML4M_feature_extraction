• The URL of the GitHub repository
https://github.com/chrisbob12/ML4M_feature_extraction

• Description of feature extractor and use

Some years ago, I built a copy of a gestural controller for speak and spell chip. Here are links to the original, and one I made earlier
http://www.audiocommander.de/blog/kempelen-exhibition-in-budapest/
https://vimeo.com/user650910
And here's a video of the original in operation:
https://www.youtube.com/watch?v=laMlpooPvy8

The original project uses a PIC chip to process the sensor data and convert it to MIDI signals, so the feature extraction algorithms and translation to MIDI is somewhat opaque, and dedicated to driving the SpeakJet chip. This submission uses an Arduino NG to gather raw data from the sensors and stream them to a computer.
The hand controller uses four Sharp GP2D120 infrared distance sensors. This page covers the strengths and weaknesses of the sensors:
https://itp.nyu.edu/archive/physcomp-spring2014/sensors/Reports/GP2D120.html

After a lot of work and some unsuccessful model training, I tackled the bulk of the sensor noise electronically, by adding simple low pass filters to each of the (buffered) sensor outputs, and a very large capacitor across the supply rails. This gave usable signals.

For this submission, I used a Max patch to gather the sensor data from an arduino, and send it via OSC to the input helper. I experimented with using the Max patch to smooth and linearise the sensor responses, but chose to simply use the patch to get the information onto OSC.

I have used the input helper to average the already smoothed sensor data, the advantage being that I don't have to do extreme smoothing, so keeping latency and computational load down. I have also used the input helper to mute the output if there is no interaction with the controller. I also spent some time experimenting with using the input helper to linearise the logarithmic response from the sensors and to derive the gestural features which I wanted. These all worked individually, and with the electronic smoothing, could be revisited.

The Wekinator model deals with compensating for the non-linearity of the responses, and combines different inputs to derive three quantised features: pitch, roll and thumb (roll and thumb correspond with jaw and tongue movement in driving the SpeakJet chip in the original).

Finally, the submission includes a processing dashboard showing roll as five arc segments at the top, thumb as three concentric arcs below, and pitch as a numerical reading at the bottom.

• How to compile it

This submission does not need to be compiled, although if you are not set up to run an Arduino board, you will need to compile and load the Arduino2max sketch in the Arduino IDE and load it into the Arduino board (this was done with an NG, but an Uno should work too). You may also need to install FTDI drivers: this should have happened in the Arduino IDE installation, or drivers can be found at FTDIchip.com
Wire up four IR sensors into a0-a3 of your Arduino and load it with the Arduino2max sketch. 

• How to run it and use it

The submission contains four components:
Arduino2max.ino			-Arduino sketch	
K2 simple outputs to OSC.maxpat	-Max patch
K2_input_help.inputproj		-Weki Input Helper project
K2_weki_models.wekproj		-Wekinator project
K2_simple_rcvr.pde		-Processing sketch


Once your Arduino is up and running, sort out the COM ports for the Max patch, and enable it (click the appropriate COM port message and then click the big X toggle) to confirm that it is picking up the sensor signals. You may need to modify the Max patcher by editing one of the COM port message buttons. This may require some trial and error. Note that the Arduino may not be hot swappapble, so Max will need stopping and restarting for changes in COM port.
Once the Max/Arduino combination is running, the input helper project should pick up the input data via OSC. Check the inputs and outputs tab: sensor 1 needs to see something before the input helper sends data.
Give the Wekinator project a little time to load properly. Once it is loaded, set it to run. The OSC input will not show green until you put your hand(s) int the hand controller! 
Open the Processing sketch and run it. This gives a graphical representation of the three features and their states.
