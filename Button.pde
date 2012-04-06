/****************************************************************************
    This class creates a button icon which allows the user to choose from
    multiple videos.
****************************************************************************/

class Button {
  float x; //x location
  float y; //y location
  float w; //width
  float h; //height
  
  //boolean to determine if the mouse is over the button
  boolean overButton = false;
  
  PImage img;
  PImage imgr;

  Button(PImage img1, PImage img2, float tempX, float tempY, float tempW, float tempH) {
    img = img1;
    imgr = img2;
    x = tempX;
    y = tempY;
    w = tempW;
    h = tempH;
  }
  
  //---------DRAW BACKGROUND & BUTTON----------------
  void display() {
   // background(0);
    imageMode(CORNER);
    image(img, x, y, w, h);
  }
  
  //check to see if mouse is over button
  void hover() {
    if(mouseX > x && mouseX < x + w
    && mouseY > y && mouseY < y + h) {
      overButton = true;
      image(imgr, x, y, w, h); // this is button's 'over' state
    } else {
      overButton = false;
    }
  }
  
  boolean mouseClicked() {
    if(mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h) {
       on = !on;
       return true;
    } else {
      return false;
    }
  }  
} 

    
