/*
 * Socket App
 *
 * A simple socket application example using the WiShield 1.0
 */

#include <WiShield.h>

#define WIRELESS_MODE_INFRA	1
#define WIRELESS_MODE_ADHOC	2

// Wireless configuration parameters ----------------------------------------
unsigned char local_ip[] = {192,168,1,2};	// IP address of WiShield
unsigned char gateway_ip[] = {192,168,1,1};	// router or gateway IP address
unsigned char subnet_mask[] = {255,255,255,0};	// subnet mask for the local network
const prog_char ssid[] PROGMEM = {"*****"};		// max 32 bytes

unsigned char security_type = 2;	// 0 - open; 1 - WEP; 2 - WPA; 3 - WPA2

// WPA/WPA2 passphrase
const prog_char security_passphrase[] PROGMEM = {"*********"};	// max 64 characters

// WEP 128-bit keys
// sample HEX keys
prog_uchar wep_keys[] PROGMEM = {	0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d,	// Key 0
									0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,	0x00,	// Key 1
									0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,	0x00,	// Key 2
									0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,	0x00	// Key 3
								};

// setup the wireless mode
// infrastructure - connect to AP
// adhoc - connect to another WiFi device
unsigned char wireless_mode = WIRELESS_MODE_INFRA;

unsigned char ssid_len;
unsigned char security_passphrase_len;
char buffer[20];

int lights =14;
/////Motor Pins/////////
int enableM = 5;
int aM = 3;
int bM = 2;
//////Steering Pins/////
int enableS = 6;
int aS = 7;
int bS = 4;
//////Temperature Sensor Setup//////
#include <LM335A.h>
LM335A Temp(2); //pass the analog input pin number

//---------------------------------------------------------------------------

void setup()
{
  Serial.begin(9600);
  
  pinMode(lights, OUTPUT);
  pinMode(enableM, OUTPUT);
  pinMode(aM, OUTPUT);
  pinMode(bM, OUTPUT);	
  
  pinMode(enableS, OUTPUT);
  pinMode(aS,OUTPUT);
  pinMode(bS,OUTPUT);
  
  WiFi.init();

}

void loop()
{
       Temp.ReadTemp();
       //Serial.println(Temp.Fahrenheit());
    WiFi.run();
    
    digitalWrite(enableM,HIGH);   
    digitalWrite(enableS,HIGH); 
  //////////////////////Lights/////////////    
    if(buffer[4] == 'O'){   
       digitalWrite(lights, HIGH);    
      }
    if(buffer[4] == 'X'){     
       digitalWrite(lights, LOW); 
    }
  /////////////////////////////////////////
  //////////////Motor Control//////////////
    if(buffer[0] == 'F')
    {
       digitalWrite(aM,HIGH);
       digitalWrite(bM,LOW);
    }
    if(buffer[1] == 'B')
    {
      digitalWrite(aM,LOW);
      digitalWrite(bM,HIGH);
    }
     if((buffer[1] == 'X') && (buffer[0] == 'X'))
    {
       digitalWrite(aM,LOW);
       digitalWrite(bM,LOW);
    }
  ////////////////////////////////////////
  ////////////Steering///////////////////
  
   if(buffer[2] == 'L')
    {
       digitalWrite(aS,LOW);
      digitalWrite(bS,HIGH);
    } 
    if(buffer[3] == 'R')
    {
      digitalWrite(aS,HIGH);
       digitalWrite(bS,LOW);
    }
     if((buffer[3] == 'X') && (buffer[2] == 'X'))
    {
       digitalWrite(aS,LOW);
       digitalWrite(bS,LOW);
    }
 Serial.print(" buffer 0:");
 Serial.print(buffer[0]);
 Serial.print(" buffer 1:");
 Serial.print(buffer[1]);
 Serial.print(" buffer 2:");
 Serial.print(buffer[2]);
 Serial.print(" buffer 3:");
 Serial.print(buffer[3]);
 Serial.print(" buffer 4:");
 Serial.print(buffer[4]);
 Serial.println(":");
 //delay(1);
}
