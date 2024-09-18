#include <ESP8266WiFi.h>
#include <FirebaseESP8266.h>


const char* ssid = "Insecure Connection";
const char* password = "01601736881";

#define FIREBASE_HOST "iot-garden-b741c-default-rtdb.asia-southeast1.firebasedatabase.app"
#define FIREBASE_AUTH "Q06ASfeBNl8gZ5mFqHPcWv8WngT4f5ABOvPUj9fZ"

FirebaseData firebaseData;
FirebaseAuth firebaseAuth;
FirebaseConfig firebaseConfig;
int soil;
int moisture;
bool waterMotor;

void setup() {
  pinMode(A0,INPUT);
  pinMode(D4,OUTPUT);
  Serial.begin(115200);
  delay(1000);

  WiFi.begin(ssid, password);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(500);
  }
  Serial.println();
  Serial.println("Connected to Wi-Fi");

  firebaseConfig.host = FIREBASE_HOST;
  firebaseConfig.signer.tokens.legacy_token = FIREBASE_AUTH;

  Firebase.begin(&firebaseConfig, &firebaseAuth);
  Firebase.reconnectWiFi(true);

   Serial.println(); 
  delay(1000);

 
  
}

void loop() {

    // soil = digitalRead(D0);
    soil = analogRead(A0);
  moisture= map(soil,0,1023,100,0);
  
 if(Firebase.get(firebaseData,"/gardenData/waterMotor")){
    waterMotor = firebaseData.boolData();
    Serial.println("water Motor");
    Serial.println(waterMotor);
    if(waterMotor == 1){
      digitalWrite(D4,HIGH);
    }else{
     digitalWrite(D4,LOW); 
    }
  }
  
 Serial.println(moisture);


  delay(100);
   FirebaseJson json;
  json.add("temprature", 42);
 // json.add("waterMotor", false);
  json.add("humidity", 20);
  json.add("soilHumidity", moisture);

  // Send a test data to Firebase
  if (Firebase.set(firebaseData, "/gardenData", json)) { 
    Serial.println("Data sent to Firebase");
  } else {
    Serial.println("Failed to send data to Firebase");
    Serial.println(firebaseData.errorReason());
  }

}
