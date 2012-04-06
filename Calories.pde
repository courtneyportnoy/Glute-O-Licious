/***************************************************************************

    A class to calculate and display number of calories burned

****************************************************************************/

class Calories {
  float bx, by;
  int thisCal; //variable to store current calories burned
  
  Calories(int tempX) {
    bx = tempX - 200;
    by = 400;    
  }
  
  void display() {
    image(calImg, bx, by);
    font = createFont("Helvetica", 24);
    textAlign(CENTER, TOP);
    textFont(font);
    fill(0);  
    text(thisCal + " Cal", bx + 95, by + 42);   
  } 
  
  //calculate calories burned based on distance traveled (x)
  void getCal(float x) {
    thisCal = int(x * 40); //avg. 150lb person burns btwn 41-47cal/mile with moderate cycling. using 40 here
    
  }
}
