/****************************************************************************
    This class creates a timer which resets every "x" amount of time.
    The timer allows us to choose how often to check the speed of the 
    rider and adjust the video playback speed accordingly.
    This allows for slighly smoother video playback.
****************************************************************************/

class Timer {
  int savedTime; //When Timer started
  int totalTime; //how long Timer should go
  
  Timer(int tempTotalTime) {
    totalTime = tempTotalTime;
  }
  
  //Start the timer
  void start() {
    savedTime = millis();
  }
  
  boolean isFinished() {
    //check how much time has passed
    int passedTime = millis() - savedTime;
    if (passedTime > totalTime) {
      return true;
    } else {
      return false;
    }
  }
}
