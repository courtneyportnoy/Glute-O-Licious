
/***************************************************************************
 
 FINAL PROJECT 2011
 
 " Virtual Cycle "
 
 Courtney Mitchell
 
 ****************************************************************************/

//import video, sound, and serial libraries
import processing.video.*;
import processing.serial.*;
import ddf.minim.*;
import cakemix.*;

//declare new objects - serial port, movie array, individual movie, timer, and buttons
Movie currentMovie;
Minim minim;
AudioPlayer player;
CakeMix mix;
String[] song = new String[25];
String thisSong;
int currentSong;
Serial myPort;
String url = "http://itp.nyu.edu/~cm2877/sinatra/glute_o_licious/submitdata?name="; 
String[] response;
String name = "";
String typing = "";
String tt = "";

Timer timer;
BackButton bb = new BackButton();
StopButton stop;
PauseButton pause;

Clock rideClock;
RPM rpm;
Speed spd;
Distance dst;
Calories cal;
Music m;
PFont font;

//declare new images
PImage img;
PImage intro; //header image
PImage credits; //credits image
PImage kp; //keep pedaling pop-up
PImage backbutt; //back button image
PImage stopb; //stop button image
PImage stop2; //stop button image 2
PImage pauseb; //pause button image
PImage playb; //play button image
PImage time; //placeholder for time clock
PImage rpmImg; //placeholder for RPM data
PImage spdImg; //placeholder for speed data
PImage dstImg; //placeholder for dist data
PImage calImg; //placeholder for Calories data
PImage musicPlay; //music play image
PImage musicPause; //music paused image
PImage graph;  //background for graph
PImage leader;  //leaderboard image

PImage thumb; //thumbnail image
float vidSpeed; //declare variable vidSpeed, which is the speed of video playback
float bikeSpeed; //speed of the bike, calculated from incoming rpm data and used to map to video speed


//ints for time declaration
int rh;
int rm;
int rs;
int bx, by;

//floats to interpret incoming data
int wheelRate;
int pedalRate;

//boolean value used to determine if you have chosen a movie
//initialized to false. becomes true when you click on the button
//buttons represent icons that allow you to choose a video
boolean on = false;
boolean finished = false;
boolean backbutton = false;
boolean pedaling = false;

//-------------------------------------RESET STARTS HERE----------------------------------------//
void reset() {

  currentSong = int(random(25));
  thisSong = song[currentSong];
  player = minim.loadFile(thisSong);

  vidSpeed = 1.0;    //initialize video speed to 1

  //reset buttons
  stop = new StopButton(width, height);
  pause = new PauseButton(width, height);
  rpm = new RPM(width);
  spd = new Speed(width);
  dst = new Distance(width);
  cal = new Calories(width);
  m = new Music(width);
  rideClock = new Clock(width);

  // ????
  // myPort.clear();

  timer = new Timer(5000);
  timer.start();
}
//---------------------------------SETUP STARTS HERE---------------------------------------------//

void setup() {
  size(screenWidth, screenHeight);
  mix = new CakeMix(this, "cm2877", "glute-o-licious");
  frameRate(30);
  smooth();
  minim = new Minim(this);
  for (int i = 0; i < song.length; i++) {
    song[i] = "song" + i + ".mp3";
  }

  // initialize images and videos
  img = loadImage("background.jpg");
  intro = loadImage("logo1_nb.png");
  credits = loadImage("credits.png");

  //initialize images 
  thumb = loadImage("bt_italy.png"); 
  kp = loadImage("KP.png");
  backbutt = loadImage("home.png");
  stopb = loadImage("stop.png");
  stop2 = loadImage("stop2.png");
  pauseb = loadImage("pause.png");
  playb = loadImage("play.png");
  time = loadImage("time.png");
  rpmImg = loadImage("rpm.png");
  spdImg = loadImage("speed.png");
  dstImg = loadImage("dist.png");
  calImg = loadImage("cal.png"); 
  musicPlay = loadImage("musicp.png");
  musicPause = loadImage("musicpa.png");
  graph = loadImage("graph2.png");
  leader = loadImage("name2.png");
  bx = 1025;
  by = 455;

  //initialize movie
  currentMovie = new Movie(this, "italy_final.mpeg");

  String portName = Serial.list()[0]; //initialize serial port
  myPort = new Serial(this, portName, 9600);
  myPort.bufferUntil('\n');

  reset();
}

//---------------------------------DRAW STARTS HERE---------------------------------------------//
void draw() {
  image(img, 0, 0, width, height); 
  imageMode(CENTER);
  image(intro, width/2, (height*.15));
  imageMode(CORNER);
  image(credits, width/2-313, (height*.85));

  //if haven't clicked a button (not on), display buttons
  if (!on) {
    imageMode(CENTER);
    image(thumb, width/2, height/2 + 20);
    imageMode(CORNER);
    if (pedaling == true) {
      on = !on;
    }
  }
  else if (finished) {
    graph();
  }

  //if on (have clicked a movie button), play movie
  else {
    image(currentMovie, 0, 0);
    //display home button and side panels
    bb.display();
    rideClock.display();
    rpm.display();
    spd.display();
    dst.display();
    cal.display();
    m.display();

    //if pedaling is true, start video and clock
    if (pedaling == true) {
      //if movie is not playing and clock is not going
      if (!currentMovie.isPlaying()) {
        if (!rideClock.isTiming) {    
          //start clock      
          rideClock.start();
        }

        //if movie is not playing and clock is paused
        else if (rideClock.paused) {
          //resume clock
          rideClock.resume();
        }
        //loop current movie
        currentMovie.loop();
      }
    }

    //if pedaling is false, pause video and clock
    else {
      currentMovie.pause();
      if (rideClock.isTiming && !rideClock.paused) {        
        rideClock.pause();
      }
    }
    //key press event to stop program and print out ride data. 
    if (keyPressed && key == 's' || key == 'S') {
      rideClock.stop();
    }
  }
}

//---------------------------Serial Event 2-------------------------------------//
void serialEvent(Serial myPort) {

  String myString = myPort.readString();
  if (myString !=null) {
    myString = trim(myString);
  }
  //if both sensor values are there
  int[] sensors = int(split(myString, ','));
  if (sensors.length > 1) {
    for (int j = 0; j < sensors.length-1; j++) {
      wheelRate = sensors[j];
      //print("sensor " + j + ":" + wheelRate + "\t");
      spd.getSpeed(wheelRate); //calculate speed in speed class
      //println("speed " + spd.thisMPH);
    }
    pedalRate = sensors[sensors.length-1];
    //println("pedal rate " + pedalRate);
  }
  rpm.getData(pedalRate); //get data in rpm class
  dst.getDist(); //calculate distance in distance class
  cal.getCal(dst.thisDist); //calculate calories based on distance ridden

  bikeSpeed = map(rpm.thisRPM, 0, 150, 0, 5); //currently mapping data to values of 0-2.

  if (bikeSpeed != 0) {
    if (!pedaling && currentMovie != null) {
      pedaling = true;
    }
  }
  else {
    pedaling = false;
  }
  //code to update video speed based on bike speed
  if (timer.isFinished()) {
    if (bikeSpeed > vidSpeed + .3 || bikeSpeed < vidSpeed - .3) {
      vidSpeed = bikeSpeed;
    }      
    else {
      vidSpeed = vidSpeed;
    }
    if (vidSpeed != 0) {
      currentMovie.speed(vidSpeed);
    }
    timer.start();
  }
}

//--------------------------Movie Event (reads movie)------------------------------------//
void movieEvent(Movie m) {
  m.read(); //read movie
}
//---------------------------Key Pressed (simulates Serial Event)------------------------//


//void keyPressed() {
//
//  if (key == ' ') {  
//    //start video playing by pressing spacebar
//    if (!pedaling && currentMovie != null) {
//      pedaling = true;
//    }
//    //pause video by pressing spacebar
//    else {
//      pedaling = false;
//    }
//  }
//  if (key == CODED && keyCode == UP) {
//    if (pedaling) {
//      vidSpeed += 0.30;
//      currentMovie.speed(vidSpeed);
//      rpm.getData(200);
//      spd.getSpeed(rpm.thisRPM); 
//      dst.getDist(); //calculate distance in distance class
//      cal.getCal(dst.thisDist); //calculate calories based on distance ridden
//    }
//    else {
//      //do nothing
//    }
//  }
//  if (key == CODED && keyCode == DOWN) {
//    if (pedaling) {
//      vidSpeed -= 0.30;
//      currentMovie.speed(vidSpeed);
//    }
//    else {
//      //do nothing
//    }
//  }
//}
//---------------------------Key Pressed (simulates Serial Event)------------------------//
void keyReleased() {
  if (finished) {
    if (keyCode == BACKSPACE) {
      typing = typing.substring(0, typing.length() - 1);
    } 
    else  if (key == '\n' ) {
      name = typing;
      response = loadStrings(url + name+"&time="+tt+"&Distance="+dst.s+"&Avg_rpm="+rpm.totAvg+"&Avg_spd="+spd.totAvg+"&Cal="+cal.thisCal);

      //added code here!------------------------------
      reset();
      on = !on;
      finished = false;
      image(img, 0, 0, width, height); 
      image(intro, width/2-425, 30);
      image(credits, width/2-425, height - 125);

      //to here!--------------------------------------

      // A String can be cleared by setting it equal to ""
      typing = "";
    } 
    else if (key != CODED && key != ' ') {
      // Otherwise, concatenate the String
      // Each character typed by the user is added to the end of the String variable.
      typing += key;
    }
    println("Name: " + name);
  }
}

//-------------------------------Mouse Clicked-------------------------------------------//
void mouseClicked() {
  if (bb.overButton()) {
    bb.mouseClicked();
  }
  else if (stop.overButton()) {
    stop.mouseClicked();
  }
  else if (pause.overButton()) {
    pause.mouseClicked();
  }
  else if (m.overButton()) {
    m.mouseClicked();
  }
}

//-------------------------------Graph Data-------------------------------------------//

void graph() {
  //display finished screen
  pedaling = false;
  //pause music if finished
  player.pause();
  //display background
  image(img, 0, 0, width, height);
  //display home button to start over
  bb.display(); 
  fill(0);
  font = createFont("Helvetica", 48);
  textFont(font);
  textAlign(CENTER, TOP);
  text("Congrats on a Great Workout!", width/2, 80);
  font = createFont("Helvetica", 36);
  textFont(font);
  text("Way to sweat it out!", width/2, 150);
  font = createFont("Helvetica", 24);
  textFont(font);
  textAlign(LEFT, TOP);
  String s = nf(rs, 2);
  String m = nf(rm, 2);

  //load graph and name field images
  image(graph, 30, 200);
  image(leader, 975, 200);
  fill(0);
  stroke(0);
  strokeWeight(2);
  //draw graph outlines
  line(100, 300, 100, 500);
  line(100, 500, 400, 500);
  line(500, 300, 500, 500);
  line(500, 500, 800, 500);

  //add text
  noStroke();
  fill(0);
  font = createFont("Helvetica", 24);
  textFont(font);
  textAlign(LEFT, TOP);
  text("Average RPM: " + rpm.totAvg, 100, 600);
  text("Average Speed: " + spd.totAvg + " MPH", 100, 650);
  font = createFont("Helvetica", 18);
  textFont(font);
  text("Time: " + rh + ":" + m + ":" + s, width/2-200, 600);
  text("Distance: " + dst.s + " miles", width/2-200, 650);
  text("Total Calories: " + cal.thisCal, width/2-200, 700);
  text("Time", width - 580, 500);

  //draw text fields
  stroke(0);
  fill(255);
  rect(1015, 440, 300, 45);
  fill(0);
  text(typing, bx, by);

  //rpm color key    
  fill(6, 150, 156);
  noStroke();
  rect(110, 520, 20, 20);
  //speed color key
  fill(244, 78, 6);
  rect(width/2 - 200, 520, 20, 20); 

  //graph rpm and speed data
  for (int i = 0; i < rpm.n; i++) {

    fill(6, 150, 156);
    //graph rpm data
    ellipse(110 + i, 500 - rpm.cumRPM[i], 10, 10);

    //speed graph
    fill(244, 78, 6);
    ellipse(510 + i, 500 - 4*spd.cumMPH[i], 10, 10);
  }

  //key text
  fill(0);
  text("RPM", 60, 520);
  text("MPH", width/2 - 260, 520); 
  text("0", 60, 495);
  text("100", 60, 395);
  text("200", 60, 295);
  text("0", width/2 - 260, 495);
  text("25", width/2-260, 395);
  text("50", width/2-260, 295);

  //  text("Average RPM: " + rpm.totAvg, (width*.17), 650);
  //  text("Average Speed: " + spd.totAvg + " MPH", (width*.17), 700);
  //  text("Total Calories: " + cal.thisCal, width/2, 650);
  //  text("Distance: " + dst.s + " miles", width/2, 700);
  //  text("Time: " + rh + ":" + m + ":" + s, width/2, 750);
  //  image(graph, (width*.17), 200);
  //image(leader, 1000, 200);

  //  stroke(0);
  //  strokeWeight(2);
  //
  //  //graph outlines
  //  line((width*.2), 250, (width*.2), 500);
  //  line((width*.2), 500, width - 400, 500);
}
//-------------------------------Music Stop-------------------------------------------//

void stop()
{
  player.close();
  minim.stop();

  super.stop();
}

