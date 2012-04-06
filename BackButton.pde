/***************************************************************************
 
 A class to create a back button which appears while video is playing, 
 allowing the user to change the video
 
 ****************************************************************************/

class BackButton {
  float bx = 10;
  float by = 10;  
  float bw = 55;
  float bh = 55;

  boolean backButton = false;

  BackButton() {
  }

  void display() {
    imageMode(CORNER);
    //rect(bx, by, bw, bh);
    image(backbutt, bx, by, bw, bh);
    if (mouseX > bx - bw && mouseX < bx + bw
      && mouseY > by - bh && mouseY < by + bh) {
      backButton = true;
      fill(100);
      noStroke();
      rect(bx+7, by+55, bw-14, 4);
    } 
    else {
      fill(255);
      backButton = false;
    }
  }

  boolean overButton() {
    return ((mouseX > bx - bw) && (mouseX < bx + bw)
      && (mouseY > by - bh) && (mouseY < by + bh)) ;
  }

  void mouseClicked() {
    if (!finished) {
      on = !on; 
      currentMovie.pause();   
      //currentMovie = null;
    }
    else {

      reset();
      on = !on;
      finished = false;
      image(img, 0, 0, width, height); 
      image(intro, width/2-425, 30);
      image(credits, width/2-425, height - 125);
    }
  }
}

