/***************************************************************************

    A class to calculate and display distance cycled based on speed & time

****************************************************************************/

class Distance {
  float bx, by;
  float thisDist; //variable to store distance ridden
  String s;
  
  Distance(int tempX) {
    bx = tempX - 200;
    by = 300;    
  }
  
  void display() {
    image(dstImg, bx, by);
    font = createFont("Helvetica", 24);
    textAlign(CENTER, TOP);
    textFont(font);
    fill(0);
    if(s == null) {
      text("0.00 Mi", bx + 95, by + 42);
    }
    else {
      text(s + " Mi", bx + 95, by + 42);
    }   
  }
 
 //calculate distance
 void getDist() {
    float z = (90*spd.loc) + 0.00; //distance = circumference of wheel * number of rotations
   //float z = (90*rpm.loc) + 0.00; //dist = circumference of wheel * number of rotations
    thisDist = z/63360; //divide by inches per mile
    s = nf(thisDist, 1, 2); //reformat miles into string w/ 1 digit to the left and 2 to the right of decimal
   } 
}
