/***************************************************************************
 
 A class to calculate and display speed in MPH based on RPM.
 
 ****************************************************************************/

class Speed {
  float bx, by;
  float thisMPH = 0; //variable to store current speed
  float cumMPH[] = new float[30000]; //declare new array to store cummulative speed data
  int loc = 0;
  int avg = 0; //initialize average at 0
  int lastAvg = 0;
  int totAvg = 0;

  Speed(int tempX) {
    bx = tempX - 200;
    by = 200;
  }

  void display() {
    image(spdImg, bx, by);
    font = createFont("Helvetica", 24);
    textAlign(CENTER, TOP);
    textFont(font);
    fill(0);
    if (rideClock.isTiming && !rideClock.paused) {
      //if have an average > 0, display average
      if (avg > 0) {
        text(avg + " MPH", bx + 95, by + 42);
      }
      //else, display current speed
      else {
        text(int(thisMPH) + " MPH", bx + 95, by + 42);
      }
    }
    else if (rideClock.paused) {
      text("paused", bx + 95, by + 42);
    }
  }
  //int y = incoming data from wheel sensor
  void getSpeed(int y) {
    float x = float(y);
    if (x > 0) {
      thisMPH = (1/x)*(90*3600000/63360); //calculates mph based on current rpm of wheel
      //moved this code from below else statement....
      cumMPH[loc] = thisMPH;
      loc++;
    }
    else {
      thisMPH = 0;
    }

    //if have more than 20 readings, add last 20 readings
    if (loc > 20) {
      for (int i = loc - 20; i < loc; i++) {
        avg += cumMPH[i];
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

