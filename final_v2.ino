/*------------------------------------------------------------------------------------------

                          FINAL PROJECT - VIRTUAL BIKE RIDE
                          
                          
------------------------------------------------------------------------------------------*/


const int sensor1 = 2; //reed switch is attached to pin 2 is wheel sensor
const int sensor2 = 3; //reed switch attached to pin 3 is pedal sensor

int switchState; //current state of switch
int lastSwitchState = LOW; //last state of wheel switch
int pedalState;
int lastPedalState = LOW; //last state of pedal switch

int currentTime;
int pedalTime;
int threshold = 2000;

long lastTime = 0;
long lastPedalTime = 0;

//-------------------------------SETUP IS HERE-------------------------------------------------//
void setup() {
  pinMode(sensor1, INPUT); //initialize sensor1 as an input  
  pinMode(sensor2, INPUT); //initialize sensor2 as input
  Serial.begin(9600); //initialize serial communication
}

//-------------------------------LOOP IS HERE-------------------------------------------------//
void loop() {
  //read switch
  switchState = digitalRead(sensor1);
  pedalState = digitalRead(sensor2);
  
  //check to see if rider stopped pedaling
  if((millis() - lastTime) > threshold) {
      //if current time - most recent reading is greater than threshold
      //rider has stopped pedaling. set currentTime == 0
      //currentTime = 0;
      Serial.print("0");
      Serial.print(",");
      //delay(50);
      lastTime = millis(); //update lastTime
  }
  
  //testing only when switch changes states (high to low or low to high)
  else {
    if(switchState != lastSwitchState) {
      //delay(50);
      
      //if the state is HIGH, then the switch is on. 
      if(switchState == HIGH) {
        //calculate time since last time switch was HIGH
        
        currentTime = millis() - lastTime;
        Serial.print(currentTime); 
        Serial.print(",");
        //Serial.println(pedalState);
      
    } else {
        //if the current state is LOW, do nothing
      }      
      //update lastTime  
      lastTime = millis();   
    }    
  }
  //save switch state
  lastSwitchState = switchState;
  
  if(millis() - lastPedalTime > threshold) {
    Serial.println("0");
    lastPedalTime = millis();
  }
  
  else {
    if(pedalState != lastPedalState) {
      if(pedalState == HIGH) {
        pedalTime = millis() - lastPedalTime;
        Serial.println(pedalTime);
      }
      else {
        //if current state is LOW, do nothing
      }
      //update last pedal time
      lastPedalTime = millis();
    }
  }
  lastPedalState = pedalState;
}
    
      
      
