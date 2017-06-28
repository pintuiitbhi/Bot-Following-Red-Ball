/*
Author: Pintu Kumar
Transmitter Side Code
This sketch transmits a short text message using the VirtualWire library
connect the Transmitter data pin of RFID to Arduino pin 12
*/
#include <SoftwareSerial.h>
#include <VirtualWire.h>

SoftwareSerial mySerial(11, 12); // RX, TX
void setup()
{
// Initialize the IO and ISR
 Serial.begin(2400);
 while (!Serial) {;}
 mySerial.begin(2000);
vw_setup(2000); // Bits per sec
}
void loop()
{
  if(Serial.available()>0)
  {
   // int x=8;
   char a[1]={'0'};
    int y=Serial.parseInt();
   a[0]=y+'0';
 send(a);
//delay(10);
}
}
void send (char *message)
{
vw_send((uint8_t *)message, strlen(message));
vw_wait_tx(); // Wait until the whole message is gone
}


