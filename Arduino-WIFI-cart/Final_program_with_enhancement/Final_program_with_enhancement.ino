/*
  WiFi Cart Web Server Design(with LED Module)
 
 Team: PV03
 Module : Avionics Project Design (AVPD)
 
 The finalise Wifi page interface for arduino. 
 This program also incorparates the ultrasound using the timer 1 function
 Timer 1 is running at 10hz,0.1s
 
 Modify the setting to suit thre wifi increaption. 
 
 Circuit:
 * WiFi shield attached
 * PWM drive output pin 9,5
 * Drive pin output pin 2,8
 * pingPin output/input pin 6
 * Buzzer to pin 3
 */

#include <SPI.h>
#include <WiFi.h>

#define DRIVE_1 2
#define DRIVE_2 8
#define ENABLE_PWM_1 5
#define ENABLE_PWM_2 9

const int pingPin = 6;
#define buzzer 3
long inches = 0;

char ssid[] = "SINGTEL-5E54";      //  your network SSID (name) 
char pass[] = "0008674900";   // your network password
int keyIndex = 0;                 // your network key Index number (needed only for WEP)

int status = WL_IDLE_STATUS;
WiFiServer server(80);

void setup() {
  Serial.begin(9600);      // initialize serial communication
  pinMode(DRIVE_1, OUTPUT); //initialise the output pins  
  pinMode(DRIVE_2, OUTPUT);
  pinMode(ENABLE_PWM_1, OUTPUT);  
  pinMode(ENABLE_PWM_2, OUTPUT);
  pinMode(buzzer,OUTPUT);

  // initialize timer1 
  noInterrupts();           // disable all interrupts
  TCCR1A = 0;
  TCCR1B = 0;
  TCNT1  = 0;

  OCR1A = 1561;            // compare match register 16MHz/1024/10Hz
  TCCR1B |= (1 << WGM12);   // CTC mode
  TCCR1B |= (1 << CS12) | (1 << CS10);    // 1024 prescaler 
  TIMSK1 |= (1 << OCIE1A);  // enable timer compare interrupt
  interrupts();             // enable all interrupts

    digitalWrite(DRIVE_1, LOW);//setting the initial value
  digitalWrite(DRIVE_2, LOW);
  digitalWrite(ENABLE_PWM_1, LOW);    
  digitalWrite(ENABLE_PWM_2, LOW);

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

}

ISR(TIMER1_COMPA_vect)          // timer compare interrupt service routine
{
  Buzzerdetector();
}

void loop() {
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
          ForwardMovement();
          delay(100);
          if (inches<4){
            Backturn();
          }
        }
        if (currentLine.endsWith("GET /L")) {
          digitalWrite(DRIVE_1, LOW);
          digitalWrite(DRIVE_2, HIGH);
          analogWrite(ENABLE_PWM_1, 204);    
          analogWrite(ENABLE_PWM_2,51 );
          delay(100);
          if (inches<4){
            Backturn();
          }
          else{
            delay(1900);
            ForwardMovement();
          }
        }
        if (currentLine.endsWith("GET /R")) {
          digitalWrite(DRIVE_1, LOW);
          digitalWrite(DRIVE_2, HIGH);
          analogWrite(ENABLE_PWM_1, 51);    
          analogWrite(ENABLE_PWM_2, 204);
          delay(100);
          if (inches<4){
            Backturn();
          }
          else{
            delay(1900);
            ForwardMovement();
          }
        }
        if (currentLine.endsWith("GET /B")) {
          BackwardMovement();
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

void BackwardMovement(){
  digitalWrite(DRIVE_1, HIGH);
  digitalWrite(DRIVE_2, LOW);
  digitalWrite(ENABLE_PWM_1, HIGH);    
  digitalWrite(ENABLE_PWM_2, HIGH);
}

void Backturn(){
  BackwardMovement();
  delay(2000);
  digitalWrite(DRIVE_1, LOW);
  digitalWrite(DRIVE_2, HIGH);
  analogWrite(ENABLE_PWM_1, 51);    
  analogWrite(ENABLE_PWM_2, 204);
  delay(4000);
  ForwardMovement();

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

//A simplified function with explanations
long pingOutput(){
  long duration;

  // Send out PING))) signal pulse 
  pinMode(pingPin, OUTPUT); 
  digitalWrite(pingPin, LOW); 
  delayMicroseconds(2); 
  digitalWrite(pingPin, HIGH); 
  delayMicroseconds(5); 
  digitalWrite(pingPin, LOW); 

  //Get duration it takes to receive echo 
  pinMode(pingPin, INPUT); 
  duration = pulseIn(pingPin, HIGH); 

  //Convert duration into distance
  //Sends out inchese
  //To send cm is microseconds / 29 / 2
  return duration / 74 / 2; 
}

void Buzzerdetector(){
  
  inches = pingOutput();//calling function

  if(inches != 0 && inches < 9){   
    tone(buzzer,(18000/inches),100);
  }

}












