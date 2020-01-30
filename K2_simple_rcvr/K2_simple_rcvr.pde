//Necessary for OSC communication with Wekinator:
import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddress dest;

PFont myFont, myBigFont;

int thumb;
int roll;
int pitch;
char inKey;
float segment;
int rollOut;
int thumbOut;

void setup() {
  size(500, 600);
  smooth(4);

  //Initialize OSC communication
  oscP5 = new OscP5(this, 12000); //listen for OSC messages on port 12000 (Wekinator default)
  dest = new NetAddress("127.0.0.1", 6450); //send messages back to Wekinator on port 6450, localhost (this machine) (default)

  //Set up fonts
  //myFont = createFont("Arial", 14);
  myBigFont = createFont("Arial", 36);

  segment = PI/5;
  pitch = 10;
  rollOut = 3;
  thumbOut = 1;
}  //*****end setup

void draw() {
  background(225);
  noFill();
  
  //frameRate(30);
  //background(128, 128, 128);
  //drawText();

  //*******************************************************************
  //set roll
  strokeWeight(30);
  for (int i = 1; i<6; i++) {
    //test roll condition for colour
    if (rollOut==i) {
      stroke(255, 0, 0);
    } else {
      stroke(200);
    }//end roll condition
    arc(240, 240, 360, 360, PI+(i-1)*segment+0.1, PI+i*segment-0.1);
  }

  //*******************************************************************
  //set thumb
  strokeWeight(30);
  for (int i = 1; i<4; i++) {
    //test thumb condition for colour
    if (thumbOut==i) {
      stroke(255, 0, 0);
    } else {
      stroke(200);
    }//end thumb condition
    arc(240, 240, 240-(i-1)*80, 240-(i-1)*80, PI+0.15, 2*PI-0.15);
  }


  //*******************************************************************
  //stroke(255);
  //strokeWeight(2);
  //for (int i = 1; i<6; i++) {
  //  arc(240, 240, 360, 360, PI, PI+i*segment, PIE);
  //}

  textSize(144);
  fill(255, 0, 0);
  text(pitch, 150, 450);
}  //*****end draw



//This is called automatically when OSC message is received
void oscEvent(OscMessage theOscMessage) {
  //println("received message");
  if (theOscMessage.checkAddrPattern("/wek/outputs") == true) {
    //println("received1", theOscMessage);
    //println("### got a /test message with typetag "+theOscMessage.typetag());
    pitch =  int(theOscMessage.get(0).floatValue());
    rollOut =  int(theOscMessage.get(1).floatValue());
    thumbOut =  int(theOscMessage.get(2).floatValue());
    println(pitch, rollOut, thumbOut);
  }  //***end if
}  //*****end oscEvent



//*****Write instructions to screen.
//void drawText() {
//    stroke(0);
//    textFont(myFont);
//    textAlign(LEFT, TOP); 
//    fill(currentTextHue, 255, 255);

//    text("Receives 1 classifier output message from wekinator", 10, 10);
//    text("Listening for OSC message /wek/outputs, port 12000", 10, 30);

//    textFont(myBigFont);
//    text(currentMessage, 190, 180);
//}  //*****end drawText