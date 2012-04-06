/***************************************************************************
 
 A class to create a stop button which appears while video is playing, 
 allowing the user to stop the ride at any time.
 
 ****************************************************************************/

class StopButton {
  float x;
  float y; 
  float bx;
  float by; 
  float bw;
  float bh;

  StopButton(float tempX, float tempY) {
    x = tempX;
    y = tempY;
  }

  void display() {
    imageMode(CORNER);
    if (rideClock.paused) {
      bx = x/2 - 100;
      by = y/4 + 80;
      bw = 186;
      image(stop2, bx, by);
    }
    else {
      bx = x - 175;
      by = y - 60;
      bw = 55;
      bh = 55;
      image(stopb, bx, by, bw, bh);
    }    
    //image(stopb, bx, by, bw, bh);
    if (overButton() && rideClock.paused) {
      fill(100);
      noStroke();
      rect(bx+14, by+75, bw-14, 4);
    } 
    else if (overButton() && !rideClock.paused) {
      fill(100);
      noStroke();
      rect(bx+7, by+55, bw-14, 4);
    }
    else {
      fill(255);
    }
  }

  boolean overButton() {
    return ((mouseX > bx) && (mouseX < bx + bw)
      && (mouseY > by) && (mouseY < by + bh)) ;
  }

  void mouseClicked() {
    finished = !finished;
    currentMovie.stop();
    rideClock.stop();
    //create date/time stamp
    //String d_t = year() + nf(month(), 2) + nf(day(), 2) + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2);
    //println(d_t);

    tt = nf(rh, 2)+":"+nf(rm,2)+":"+nf(rs,2);

    //cakemix data
    /*mix.addData("Distance", dst.s);
     mix.addData("Avg_rpm", rpm.totAvg);
     mix.addData("Avg_spd", spd.totAvg);
     mix.addData("Cal", cal.thisCal);
     mix.addData("Hours", rh);
     mix.addData("Min", rm);
     mix.addData("Sec", rs);
     mix.post();*/
  }
}

