/*
  WiFi Cart Web Server Design(w/o LED Module)
 
 Team: PV03
 Module : Avionics Project Design (AVPD)
 
 This is a basic design of how to move a wifi cart thru a web broswer.
 The web page is created solely by the Arduino itself (no graphics intended)
 This program uses the conventional 6 output need to drive the two motor.
 
 Modify the setting to suit thre wifi increaption. 
 
 Circuit:
 * WiFi shield attached
 * LED attached to pin A0,A1,A2 and A3
 * PWM drive output pin 3,5
 * Drive pin output pin 8,9
 * Inverse Drive pin output pin 6,9
 */
#include <SPI.h>
#include <WiFi.h>

#define DRIVE_1 2
#define DRIVE_2 8
#define ENABLE_PWM_1 5
#define ENABLE_PWM_2 9
#define pingPin 6


char ssid[] = "Safiuddin";      //  your network SSID (name) 
char pass[] = "ranger619";   // your network password
int keyIndex = 0;                 // your network key Index number (needed only for WEP)

int status = WL_IDLE_STATUS;
WiFiServer server(80);

void setup() {
  Serial.begin(9600);      // initialize serial communication
  pinMode(DRIVE_1, OUTPUT); //initialise the output pins  
  pinMode(DRIVE_2, OUTPUT);
  pinMode(ENABLE_PWM_1, OUTPUT);  
  pinMode(ENABLE_PWM_2, OUTPUT);

  // check for the presence of the shield:
  if (WiFi.status() == WL_NO_SHIELD) {
    Serial.println("WiFi shield not present"); 
    while(true);        // don't continue
  } 

  // attempt to connect to Wifi network:
  while ( status != WL_CONNECTED) { 
    Serial.print("Attempting to connect to Network named: ");
    Serial.println(ssid);                   // print the network name (SSID);

    // Connect to WPA/WPA2 network. Change this line if using open or WEP network:    
    status = WiFi.begin(ssid, pass);
    // wait 10 seconds for connection:
    delay(10000);
  } 
  server.begin();                           // start the web server on port 80
  printWifiStatus();                        // you're connected now, so print out the status

  digitalWrite(DRIVE_1, LOW);//setting the initial value
  digitalWrite(DRIVE_2, LOW);
  digitalWrite(ENABLE_PWM_1, LOW);    
  digitalWrite(ENABLE_PWM_2, LOW);
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

  delay(100);

  WiFiClient client = server.available();   // listen for incoming clients

  if (client) {                             // if you get a client,
    Serial.println("new client");           // print a message out the serial port
    String currentLine = "";                // make a String to hold incoming data from the client
    while (client.connected()) {            // loop while the client's connected
      if (client.available()) {             // if there's bytes to read from the client,
        char c = client.read();             // read a byte, then
        Serial.write(c);                    // print it out the serial monitor
        if (c == '\n') {                    // if the byte is a newline character

          // if the current line is blank, you got two newline characters in a row.
          // that's the end of the client HTTP request, so send a response:
          if (currentLine.length() == 0) {  
            // HTTP headers always start with a response code (e.g. HTTP/1.1 200 OK)
            // and a content-type so the client knows what's coming, then a blank line:    
            client.println("HTTP/1.1 200 OK");
            client.println("Content-type:text/html");
            client.println();

            // the content of the HTTP response follows the header:

            client.print("<h1>AVPD Project 2 : Arduino Wifi Cart (part 2.1) </h1>");
            client.print("<h2>PV03 Interface page </h2>");
            client.print("<h3>Orientation Axis</h3>");
            client.print("<a href=\"/S\">EMERGENCY STOP!!!!!! </a> <br><br><br><br>");
            client.print("&nbsp;&nbsp;&nbsp;&nbsp; <a href=\"/F\"> Front </a> <br><br>");
            client.print("<a href=\"/L\">Left</a> &nbsp;&nbsp;&nbsp;&nbsp;");
            client.print("<a href=\"/R\">Right</a> <br><br>");
            client.print("&nbsp;&nbsp;&nbsp;&nbsp;<a href=\"/B\"> Back </a>");

            // The HTTP response ends with another blank line:
            client.println();
            // break out of the while loop:
            break;         
          } 
          else {      // if you got a newline, then clear currentLine:
            currentLine = "";
          }
        }     
        else if (c != '\r') {    // if you got anything else but a carriage return character,
          currentLine += c;      // add it to the end of the currentLine
        }

        // Check to see if the client request was "GET /H" or "GET /L":
        if (currentLine.endsWith("GET /S")) {
          StopMotorCar();
        }
        if (currentLine.endsWith("GET /F")) {

          digitalWrite(DRIVE_1, HIGH);
          digitalWrite(DRIVE_2, LOW);
          digitalWrite(ENABLE_PWM_1, HIGH);    
          digitalWrite(ENABLE_PWM_2, HIGH);

        

        }
        if (currentLine.endsWith("GET /L")) {

          digitalWrite(DRIVE_1, LOW);
          digitalWrite(DRIVE_2, HIGH);
          analogWrite(ENABLE_PWM_1, 204);    
          analogWrite(ENABLE_PWM_2,51 );

          delay(2000);
          ForwardMovement();


        }
        if (currentLine.endsWith("GET /R")) {

          digitalWrite(DRIVE_1, LOW);
          digitalWrite(DRIVE_2, HIGH);
          analogWrite(ENABLE_PWM_1, 51);    
          analogWrite(ENABLE_PWM_2, 204);

          delay(2000);
          ForwardMovement();

        }
        if (currentLine.endsWith("GET /B")) {

          digitalWrite(DRIVE_1, LOW);//setting the initial value
          digitalWrite(DRIVE_2, HIGH);
          digitalWrite(ENABLE_PWM_1, HIGH);    
          digitalWrite(ENABLE_PWM_2, HIGH);
        }
        
         if(inches < 3){
            digitalWrite(DRIVE_1, LOW);//moving back
            digitalWrite(DRIVE_2, HIGH);
            digitalWrite(ENABLE_PWM_1, HIGH);    
            digitalWrite(ENABLE_PWM_2, HIGH);
            delay(2000);
            digitalWrite(DRIVE_1, HIGH);//moving front, turning right
            digitalWrite(DRIVE_2, LOW);
            analogWrite(ENABLE_PWM_1, 128);    
            digitalWrite(ENABLE_PWM_2, HIGH);
            delay(2000);
            digitalWrite(DRIVE_1, HIGH);
            digitalWrite(DRIVE_2, LOW);
            digitalWrite(ENABLE_PWM_1, HIGH);    
            digitalWrite(ENABLE_PWM_2, HIGH);
          }



      }
    }
    // close the connection:
    client.stop();
    Serial.println("client disonnected");
  }
}

void StopMotorCar(){

  digitalWrite(ENABLE_PWM_1, LOW);    
  digitalWrite(ENABLE_PWM_2, LOW);
  digitalWrite(DRIVE_1, LOW);
  digitalWrite(DRIVE_2, LOW);
}

void ForwardMovement(){
  digitalWrite(DRIVE_1, HIGH);
  digitalWrite(DRIVE_2, LOW);
  digitalWrite(ENABLE_PWM_1, HIGH);    
  digitalWrite(ENABLE_PWM_2, HIGH);
}

long microsecondsToInches(long microseconds)
{
  // According to Parallax's datasheet for the PING))), there are
  // 73.746 microseconds per inch (i.e. sound travels at 1130 feet per
  // second).  This gives the distance travelled by the ping, outbound
  // and return, so we divide by 2 to get the distance of the obstacle.
  // See: http://www.parallax.com/dl/docs/prod/acc/28015-PING-v1.3.pdf
  return microseconds / 74 / 2;
}

long microsecondsToCentimeters(long microseconds)
{
  // The speed of sound is 340 m/s or 29 microseconds per centimeter.
  // The ping travels out and back, so to find the distance of the
  // object we take half of the distance travelled.
  return microseconds / 29 / 2;
}

void printWifiStatus() {
  // print the SSID of the network you're attached to:
  Serial.print("SSID: ");
  Serial.println(WiFi.SSID());

  // print your WiFi shield's IP address:
  IPAddress ip = WiFi.localIP();
  Serial.print("IP Address: ");
  Serial.println(ip);

  // print the received signal strength:
  long rssi = WiFi.RSSI();
  Serial.print("signal strength (RSSI):");
  Serial.print(rssi);
  Serial.println(" dBm");
  // print where to go in a browser:
  Serial.print("To see this page in action, open a browser to http://");
  Serial.println(ip);
}




