#define DRIVE_1 2
#define DRIVE_2 8
#define ENABLE_PWM_1 5
#define ENABLE_PWM_2 9
const int pingPin = 6;

void setup() {
  pinMode(DRIVE_1, OUTPUT); //initialise the output pins  
  pinMode(DRIVE_2, OUTPUT);
  pinMode(ENABLE_PWM_1, OUTPUT);  
  pinMode(ENABLE_PWM_2, OUTPUT);
  pinMode(pingPin, OUTPUT);

  digitalWrite(DRIVE_1, HIGH);//moving front
  digitalWrite(DRIVE_2, LOW);
  digitalWrite(ENABLE_PWM_1, HIGH);    
  digitalWrite(ENABLE_PWM_2, HIGH);

  Serial.begin(9600);

}

void loop() {

  // establish variables for duration of the ping, 
  // and the distance result in inches and centimeters:
  long duration, inches, cm;

  // The PING))) is triggered by a HIGH pulse of 2 or more microseconds.
  // Give a short LOW pulse beforehand to ensure a clean HIGH pulse:
  pinMode(pingPin, OUTPUT);
  digitalWrite(pingPin, LOW);
  delayMicroseconds(2);
  digitalWrite(pingPin, HIGH);
  delayMicroseconds(5);
  digitalWrite(pingPin, LOW);

  // The same pin is used to read the signal from the PING))): a HIGH
  // pulse whose duration is the time (in microseconds) from the sending
  // of the ping to the reception of its echo off of an object.
  pinMode(pingPin, INPUT);
  duration = pulseIn(pingPin, HIGH);

  // convert the time into a distance
  inches = microsecondsToInches(duration);
  cm = microsecondsToCentimeters(duration);

  Serial.print(inches);
  Serial.print("in, ");
  Serial.print(cm);
  Serial.print("cm");
  Serial.println();
  
  delay(100);


  if(inches < 4){
    digitalWrite(DRIVE_1, LOW);//moving back
    digitalWrite(DRIVE_2, HIGH);
    digitalWrite(ENABLE_PWM_1, HIGH);    
    digitalWrite(ENABLE_PWM_2, HIGH);
    delay(1000);
    digitalWrite(DRIVE_1, LOW);//Reverse 360
    digitalWrite(DRIVE_2, HIGH);
    analogWrite(ENABLE_PWM_1, 240);    
    analogWrite(ENABLE_PWM_2, 51);
    delay(4000);
    digitalWrite(DRIVE_1, HIGH);//moving high
    digitalWrite(DRIVE_2, LOW);
    digitalWrite(ENABLE_PWM_1, HIGH);    
    digitalWrite(ENABLE_PWM_2, HIGH);
    
  }


}

long microsecondsToInches(long microseconds)
{ // According to Parallax's datasheet for the PING))), there are
  // 73.746 microseconds per inch (i.e. sound travels at 1130 feet per
  // second).  This gives the distance travelled by the ping, outbound
  // and return, so we divide by 2 to get the distance of the obstacle.
  // See: http://www.parallax.com/dl/docs/prod/acc/28015-PING-v1.3.pdf
  return microseconds / 74 / 2;
}

long microsecondsToCentimeters(long microseconds)
{ // The speed of sound is 340 m/s or 29 microseconds per centimeter.
  // The ping travels out and back, so to find the distance of the
  // object we take half of the distance travelled.
  return microseconds / 29 / 2;
}


