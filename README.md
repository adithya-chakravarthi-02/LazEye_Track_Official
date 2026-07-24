# 👓 LazEye Track — Rethinking Amblyopia Treatment: A Compliance Innovation

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
[![MQTT](https://img.shields.io/badge/MQTT-660066?style=for-the-badge&logo=mqtt&logoColor=white)](https://mqtt.org/)
[![ESP32](https://img.shields.io/badge/ESP32-E7352C?style=for-the-badge&logo=espressif&logoColor=white)](https://www.espressif.com/)

**LazEye Track** is an innovative, ultra-affordable IoT-enabled Smart Glasses system paired with a Flutter mobile application designed to solve the critical compliance crisis in **Amblyopia (Lazy Eye)** pediatric therapy.

---

## 🎯 The Compliance Crisis in Amblyopia

Amblyopia affects over **5 Million children in India** and **28 Million worldwide**. Traditional occlusion (patching) therapy and spectacle treatment suffer from severe non-compliance:

* 📉 **Patching Therapy Non-Compliance:** `11.7%` to `54%`
* 📉 **Spectacle Adherence Non-Compliance:** `44%` to `56%` *(Infant Aphakia Treatment Study)*
* 🚨 **Core Challenges:** Lack of patient acceptance (discomfort/stigma), zero objective parental monitoring, and no reliable compliance data for clinicians.

---

## 💡 The Solution

**LazEye Track** bridges the gap between *Treatment Promise* and *Treatment Proof*.

1. **Smart Occlusion & Frame Tracking:** Equipped with a Capacitive Touch Sensor (to detect frame contact) and an IR Sensor (to detect eye status/openness).
2. **Positive Reinforcement Video Player:** The Flutter companion app automatically plays therapy videos **only** when the glasses are actively worn AND the eye is detected/open. If the child removes the glasses or closes/covers their eye, video playback pauses automatically.
3. **Objective Session & Cumulative Timer:** Tracks exact active therapy seconds in real-time and logs total treatment duration.
4. **Ultra-Low Cost (~ ₹600 / ~$7.50 USD):** Replaces expensive alternatives costing ₹1.2 to 1.5 Lakhs with an accessible, scalable IoT architecture.

---

## 🛠️ Hardware Architecture & Cost Breakdown

| Component | Function | Approx. Cost (INR) |
| :--- | :--- | :--- |
| **Capacitive Touch Sensor** | Detects frame-to-skin contact (Frame Worn) | ₹12 |
| **IR Sensor Module** | Detects eye presence / eye open status | ₹45 |
| **ESP32 Microcontroller** | Processes sensor data & broadcasts MQTT telemetry via Wi-Fi | ₹500 |
| **Total Hardware Cost** | **Ultra-accessible pediatric therapy system** | **~ ₹600** |

---

## 📡 MQTT Communication Schema

* **Broker:** `broker.hivemq.com`
* **Port:** `1883`
* **Topic:** `amblyopia/glasses/status`

### Payload JSON Example
```json
{
  "frame_contact": "worn",
  "eye_status": "open",
  "system_state": "THERAPY_ACTIVE"
}
```

---

## 📱 Mobile App Architecture (Flutter)

### Directory Structure
```
LazEye-Track/
├── lib/
│   ├── main.dart                 # App entry point, Dashboard UI, Session & Total timers
│   ├── mqtt_service.dart          # HiveMQ MQTT Client connection & JSON parser
│   └── video_player_widget.dart   # Auto-play/pause video widget tied to therapy status
├── assets/
│   └── videos/
│       └── therapy.mp4           # Place your therapy video asset here
├── firmware/
│   └── esp32_smart_glasses.ino   # ESP32 C++ Arduino sketch for hardware telemetry
├── pubspec.yaml
└── README.md
```

---

## 🚀 Getting Started

### Prerequisites
* [Flutter SDK](https://docs.flutter.dev/get-started/install) (`>= 3.0.0`)
* [Arduino IDE](https://www.arduino.cc/en/software) (for ESP32 flashing)

### Flutter Setup
1. Clone the repository:
   ```bash
   git clone https://github.com/adithya-chakravarthi-02/LazEye-Track.git
   cd LazEye-Track
   ```
2. Place your therapy video file at `assets/videos/therapy.mp4`.
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```

---

## 🔮 Future Prospects & Roadmap

* 🛡️ **Smart Occlusion Control:** Dynamic LCD shuttering for controlled binocular therapy.
* 👓 **Spectacle Wear Adherence:** Longitudinal compliance tracking for clinicians with cloud sync.
* 👁️ **Dry Eye Prevention:** Blink-frequency tracking and automated rest reminders.

---

## 📜 License

Distributed under the MIT License. See `LICENSE` for more information.
