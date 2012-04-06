/***************************************************************************
 
 A class to calculate and display RPM's based on incoming data
 
 ****************************************************************************/

class RPM {
  float bx, by;
  int thisRev = 0; //declare variable thisRev, which is the speed of each 
  //single revolution of the flywheel (from Serial port)
  int thisRPM = 0; //variable to store RPM, calculated from thisRev
  int cumRPM[]; //declare new array to store cummulative rpm data
  int avg = 0; //variable that stores current avg RPM
  int lastAvg = 0;
  int loc = 0;
  int totAvg = 0;
  int n = 0;

  RPM(int tempX) {
    cumRPM = new int[30000];
    bx = tempX - 200;
    by = 100;
  }

  void display() {
    image(rpmImg, bx, by);
    font = createFont("Helvetica", 24);
    textAlign(CENTER, TOP);
    textFont(font);
    fill(0);
    if (rideClock.isTiming && !rideClock.paused) {
      if (avg > 0) {
        text(avg + " RPM", bx + 95, by + 42);
      }
      else {
        text(thisRPM + " RPM", bx + 95, by + 42);
      }
    }
    else if (rideClock.paused) {
      text("paused", bx + 95, by + 42);
    }
  } 

  //changed s from String to int....test this out.
  void getData(int s) {
    thisRev = s;
    if (finished) {
      n = loc;
    }
    else {
      if (thisRev != 0) {
        thisRPM = 60000/thisRev; //math to calculate rpm based on time per single revolution
      }
      else {
        thisRPM = 0;
      }
      cumRPM[loc] = thisRPM;
      loc++;

      //if have more than 20 readings, add last 20 readings
      if (loc > 20) {
        for (int i = loc - 20; i < loc; i++) {
          avg += cumRPM[i];
        }
        //subtract last average
        avg -= lastAvg;

        //divide average by 20 to get current average.
        avg /= 20;

        //reset last average
        lastAvg = avg;
      }
    }
  }
}

