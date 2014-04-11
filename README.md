creator
=======

Processing source for creating "apps"

Requires:

- Processing 2 [https://www.processing.org/]
- ControlP5 library for processing [http://www.sojamo.de/libraries/controlP5/]

===

To use it:

1. Click in the box "length_secs"
2. Enter the length of the "app" in seconds (e.g. enter '180' for 3 minutes). Press enter
3. Vertical axis is brainwave frequency (31 -> 0), horizontal axis is time (0s -> length_secs, marked in 10s intervals)
4. Choose a colour from the right hand side colour picker
5. Click on the graph to set a point (frequency, time, colour)
6. Do this for several points. The program interpolates between them.
7. Once done, click "save". A file is created called "c:/arrays.txt"
8. Take these r,g,b,freq arrays and paste into the Arduino code.
9. Also modify the Arduino code to set the length of the program - i.e. change this line "for (int i = 0; i <60; i++)" and replace the '60' with the value you used for length_secs (e.g. 180)
10. Upload to Arduino
11. Relax, enjoy
