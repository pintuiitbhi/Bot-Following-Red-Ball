/*
Author: Pintu Kumar
This sketch displays text strings received using VirtualWire
Connect the Receiver data pin to Arduino pin 11
*/
#include <VirtualWire.h>
byte message[VW_MAX_MESSAGE_LEN]; // a buffer to store the incoming messages
byte messageLength = VW_MAX_MESSAGE_LEN; // the size of the message
void setup()
{
 pinMode(2,OUTPUT);
 pinMode(3,OUTPUT);
 pinMode(4,OUTPUT);
 pinMode(5,OUTPUT); 
 pinMode(13,OUTPUT);
 Serial.begin(2400);
Serial.println("Device is ready");
// Initialize the IO and ISR
vw_setup(2000); // Bits per sec
vw_rx_start(); // Start the receiver
}
void loop()
{
if (vw_get_message(message, &messageLength)) // Non-blocking
{
//Serial.print("Message Length: ");
//Serial.println(message[1],DEC);
  int ch=message[0];
 // Serial.println(ch,DEC);
Serial.print("Received: ");

for (int i = 0; i < messageLength; i++)
{
Serial.write(message[i]);
}
Serial.println();

switch(ch)// Contolling the motion of four motor used in the Bot
{
  case 50:
  digitalWrite(2,HIGH);
  digitalWrite(3,LOW);
  digitalWrite(4,HIGH);
  digitalWrite(5,LOW);
  break;

  case 52:
   digitalWrite(2,HIGH);
  digitalWrite(3,LOW);
  digitalWrite(4,LOW);
  digitalWrite(5,HIGH);
  break;
  case 53:
   digitalWrite(2,LOW);
  digitalWrite(3,LOW);
  digitalWrite(4,LOW);
  digitalWrite(5,LOW);
  break;
  case 54:
   digitalWrite(2,LOW);
  digitalWrite(3,HIGH);
  digitalWrite(4,HIGH);
  digitalWrite(5,LOW);
  break;
  case 56:
   digitalWrite(2,LOW);
  digitalWrite(3,HIGH);
  digitalWrite(4,LOW);
  digitalWrite(5,HIGH);
  break;
}
  
}
}


