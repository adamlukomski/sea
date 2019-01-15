/*
 * stm32f401re nucleo
 * 
 */
#include<Servo.h>

Servo ser1;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  Serial.println("Starting...");
  ser1.attach(9);
}

int pot1,pot2;

void loop() {
  // put your main code here, to run repeatedly:
  pot1 = analogRead(1);
  pot2 = analogRead(2);

  Serial.print("analogs: ");
  Serial.print(pot1);
  Serial.print(" ");
  Serial.println(pot2);

  //ser1.write(122);
  ser1.write(122+floor(0.5*(pot2-pot1-20)));
  
  delay(10);
}
