/*
 * LazEye Track - ESP32 Smart Glasses Firmware
 * 
 * Hardware Setup:
 * 1. Capacitive Touch Sensor (e.g. TTP223) -> Pin GPIO 4 (Frame Contact Detection)
 * 2. IR Sensor Module -> Pin GPIO 5 (Eye Open / Presence Detection)
 * 3. ESP32 Board -> Connected via Wi-Fi & MQTT
 * 
 * MQTT Details:
 * - Broker: broker.hivemq.com (Port 1883)
 * - Topic: amblyopia/glasses/status
 * - Payload Format (JSON): 
 *   {
 *     "frame_contact": "worn", // or "true", "contact"
 *     "eye_status": "open",    // or "true", "detected"
 *     "system_state": "ACTIVE"
 *   }
 */

#include <WiFi.h>
#include <PubSubClient.h>
#include <ArduinoJson.h>

// Wi-Fi Credentials
const char* ssid = "YOUR_WIFI_SSID";
const char* password = "YOUR_WIFI_PASSWORD";

// MQTT Broker Details
const char* mqtt_server = "broker.hivemq.com";
const int mqtt_port = 1883;
const char* mqtt_topic = "amblyopia/glasses/status";

// Hardware Pins
const int TOUCH_SENSOR_PIN = 4; // Capacitive Touch Sensor
const int IR_SENSOR_PIN = 5;    // IR Sensor

WiFiClient espClient;
PubSubClient client(espClient);

void setup_wifi() {
  delay(10);
  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(ssid);

  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("\nWiFi connected");
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());
}

void reconnect() {
  while (!client.connected()) {
    Serial.print("Attempting MQTT connection...");
    String clientId = "ESP32Glasses-";
    clientId += String(random(0xffff), HEX);

    if (client.connect(clientId.c_str())) {
      Serial.println("connected");
    } else {
      Serial.print("failed, rc=");
      Serial.print(client.state());
      Serial.println(" try again in 5 seconds");
      delay(5000);
    }
  }
}

void setup() {
  Serial.begin(115200);
  pinMode(TOUCH_SENSOR_PIN, INPUT);
  pinMode(IR_SENSOR_PIN, INPUT);

  setup_wifi();
  client.setServer(mqtt_server, mqtt_port);
}

void loop() {
  if (!client.connected()) {
    reconnect();
  }
  client.loop();

  // Read sensors
  int touchVal = digitalRead(TOUCH_SENSOR_PIN);
  int irVal = digitalRead(IR_SENSOR_PIN);

  // Interpret sensor states
  bool isWorn = (touchVal == HIGH);
  bool isEyeDetected = (irVal == LOW); // LOW typically indicates object/reflection detected on standard IR sensors

  String frameContact = isWorn ? "worn" : "not_worn";
  String eyeStatus = isEyeDetected ? "open" : "closed";
  String systemState = (isWorn && isEyeDetected) ? "THERAPY_ACTIVE" : "STANDBY";

  // Build JSON Payload
  StaticJsonDocument<200> doc;
  doc["frame_contact"] = frameContact;
  doc["eye_status"] = eyeStatus;
  doc["system_state"] = systemState;

  char buffer[256];
  serializeJson(doc, buffer);

  Serial.print("Publishing message: ");
  Serial.println(buffer);

  client.publish(mqtt_topic, buffer);

  // Publish telemetry every 1 second
  delay(1000);
}
