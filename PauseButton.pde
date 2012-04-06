/***************************************************************************
 
 A class to display pause button on bottom right of screen.
 When clicked, the video and timer will also pause.
 
 ****************************************************************************/

class PauseButton {
  float x;
  float y;
  float bx;
  float by;  
  float bw = 55;
  float bh = 55;

  PauseButton(float tempX, float tempY) {
    x = tempX;
    y = tempY;
  }

  void display() {
    imageMode(CORNER);
    bx = x - 65;
    by = y - 60;
    image(pauseb, bx, by, bw, bh);

    if (overButton()) {
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
    pedaling = !pedaling;
  }
}

