/*  
 *  RAnDome by TVHeadedRobots is licensed under a Creative Commons 
 *  Attribution-ShareAlike 3.0 Unported License.
 * 
 *  This Processing Sketch uses the JKLabs monomic & oscP5 libraries to generate a random animation
 *  using the monome as a display.
 *  
 *  To use this Sketch start MonomeSerial (or other monome serial interface app) & make suer the I/O 
 *  protocol is set to OpenSoundControl. Then set the address pattern prefix to "/box" (no quotes.)
 *  Now run this sketch and u should see lots-o-blinkinlights!! 
 * 
*/

import oscP5.*;
import netP5.*;
import jklabs.monomic.*;

Monome m;
int mWidth = 8;  // the number of leds across
int mHeight = 8; // the number of leds down
int cntr = 0; // global counter
int delayTm = 0;
int j = 0; // init the reset counter
int rsetCntJ = 1023; // init a reset value to compare against j

byte rowVals = byte(0); // monome row as byte
byte columnVals = byte(0); // monome column as byte
byte rB = byte(0); // the random byte

float noiseSrc = 0; // noise container
float ledNoise = 0; 

void setup() {
  m = new MonomeOSC( this );
  frameRate( 15 );
}

void draw() {
  // configure the noise generator
  noiseSeed(0);
  noiseDetail(12, .25); // generate noise over 12 octaves with 0.25 falloff
  
  // iterate through each row of the monome and set that row's value to a random byte
  for (int i = 0; i < mHeight; i++) {
    // get the value of the current row/column as a byte
    rowVals = m.getRowValues(i);
    columnVals = m.getColValues(i);
    
    // do stuff
    noiseSrc = int(map(noise(PI, columnVals), 0, 1, 1, 255)); // generate a random value between 1 & 255 using the Perlin noise generator
    ledNoise = noise(float(rowVals), cntr); // generate another random value for the LED brightness
    rB = byte(noiseSrc); // make the random byte to set the monome row value
    m.setRow(i, rB); // set monome row value
    m.setLedIntensity(ledNoise); // set the LEDs
    delay(delayTm);
    
    //println(ledNoise); // debug
    
    // reset the screen after j cycles
    if (j == rsetCntJ) {
      //m.setRow(7, byte(0));
      m.lightsOff();
      j = 0;
      println("reset the display " + rsetCntJ + " j = " + j);
    }
    else {
    //  m.setRow(i-1, byte(0));
    println("rsetCntJ = " + rsetCntJ + " j = " + j);
    j++;
    }
    
    cntr++; // increment global counter to keep things changing
  }
}

void monomePressed( int x, int y ) {
 if (x == 0 && y == 0) delayTm = 0;
 if (x == 1 && y == 0) delayTm = 100;
 if (x == 2 && y == 0) delayTm = 200;
 if (x == 3 && y == 0) delayTm = 300;
 if (x == 4 && y == 0) delayTm = 500;
 if (x == 5 && y == 0) delayTm = 800;
 if (x == 6 && y == 0) delayTm = 1300;
 if (x == 7 && y == 0) delayTm = 2100;
 
 if (x == 0 && y == 1) rsetCntJ = 1023;
 if (x == 1 && y == 1) rsetCntJ = 255;
 if (x == 2 && y == 1) rsetCntJ = 15;
 if (x == 3 && y == 1) rsetCntJ = 7;
 if (x == 4 && y == 1) rsetCntJ = 4;
 if (x == 5 && y == 1) rsetCntJ = 3;
 if (x == 6 && y == 1) rsetCntJ = 2;
 if (x == 7 && y == 1) rsetCntJ = 1;
 
 j = 0;
 println("pressed! dealyTm = " + delayTm + "and reset count = " + rsetCntJ); 
}
