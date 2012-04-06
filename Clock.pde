/***************************************************************************

    A class to calculate amount of time spent riding. clock stops
    and starts with pedaling or pressing the pause button.
    Timer is displayed onscreen in h:mm:ss format

****************************************************************************/


class Clock {
  long rideStart;
  long rideStop;
  long rideTime;
  long[] ridePaused = new long[50];
  long[] rideResumed = new long[50];
  long[] timePaused = new long[50];
  long totalTimePaused = 0;
  int timesPaused = 0;
  boolean isTiming = false;
  boolean paused = false;
  boolean resumed = false;
  int t;
  
  float bx, by;
  
  
  Clock(int tempX) {
    bx = tempX - 200;
    by = 2;    
  }
  //-------------------------------------------DISPLAY------------------------------------------------------//
  void display() {
    //display box image
    image(time, bx, by);
    font = createFont("Helvetica", 24);
    textAlign(CENTER, TOP);
    textFont(font);
    fill(0);
    t = 0;
    
    //math to calculate hours, minutes, and seconds
    if(isTiming && !resumed) {
      t = int((millis() - rideStart)/1000);
    }
    
    else if (resumed) {      
      //calculate z = total amt of time paused
      int z = 0;
      for(int i = 0; i < timesPaused; i++) {
        z += timePaused[i];
      }      
      
     //calculate t = total amount of time spent riding, excludes time paused, etc. 
      t = int(millis() - rideStart - z)/1000;
    }
    
    int seconds = t;
    int minutes = seconds/60;
    int hours = minutes/60; 
    
    //math to keep within 60 sec and 60 min. 
    seconds -= minutes * 60;
    minutes -= hours * 60;
    
    //Convert ints to strings to format w/ 2 digits
    String s = nf(seconds, 2);
    String m = nf(minutes, 2);
    
    if(isTiming && !paused) {   
      //if timing, display current time (h:mm:ss)
      text(hours + ":" + m + ":" + s, bx + 95, by + 42);
      stop.display();
      pause.display();
    }
    else if(paused) {    
      text("paused", bx + 95, by + 42);
      //pop-up image here...
      image(kp,width/2 - 320, height/4);
      stop.display();
    }
   
  } 
 //-------------------------------------------START------------------------------------------------------//

    void start() {
      rideStart = millis();
      isTiming = true;     
    }
    
 //-------------------------------------------PAUSE------------------------------------------------------//
    void pause() {      
      ridePaused[timesPaused] = millis();
      isTiming = true;
      paused = true;
      timesPaused++;
    }
 
 //-------------------------------------------RESUME------------------------------------------------------//
     void resume() {
      resumed = true;
      rideResumed[timesPaused - 1] = millis();
      timePaused[timesPaused - 1] = rideResumed[timesPaused - 1] - ridePaused[timesPaused - 1];
      isTiming = true;
      paused = false;
    }      

//-------------------------------------------STOP------------------------------------------------------//  
    void stop() {
      isTiming = false;
      rideStop = millis();  
      for(int i = 0; i < timesPaused; i ++) {
        totalTimePaused += timePaused[i];
      }    
      rideTime = rideStop - rideStart - totalTimePaused;
      rh = int(rideTime / 360000000);
      rm = int(rideTime / 60000);
      rs = int((rideTime % 60000)/1000);
      //println(rh + ":" + rm + ":" + rs);
      
      for (int i = 0; i < spd.loc; i++) {
        spd.totAvg += spd.cumMPH[i];
        rpm.totAvg += rpm.cumRPM[i];
      }
      spd.totAvg /= spd.loc;
      rpm.totAvg /= spd.loc;
    }
    
}
    
