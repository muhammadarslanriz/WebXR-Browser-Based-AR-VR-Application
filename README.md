# WebXR — Browser-Based AR/VR Application

A browser-based Augmented Reality and Virtual Reality web app built with **Three.js** and the **WebXR API**. No native app installation required — runs entirely in the browser.

---

## 🛠️ Technologies Used

| Technology | Purpose |
|---|---|
| Three.js | 3D object rendering and animation |
| WebXR API | AR/VR hardware bridge (camera & headset) |
| WebGL | GPU-accelerated frame rendering |
| Node.js http-server | Local file hosting |
| ngrok | Secure HTTPS tunnel for WebXR support |

---

## 📱 Tested On

- **AR** — iPhone 17 Pro Max via [WebXR Viewer](https://apps.apple.com/app/webxr-viewer/id1295998056) (Mozilla)
- **VR** — Oculus / Meta Quest via built-in Meta Browser

---

## 🚀 How to Run

### Prerequisites
- [Node.js](https://nodejs.org) installed
- [ngrok](https://ngrok.com) installed and authenticated

### Step 1 — Install http-server
```bash
npm install -g http-server
```

### Step 2 — Start the local server
```bash
cd path/to/project
http-server -p 8080 --cors
```

### Step 3 — Start ngrok tunnel
> WebXR requires HTTPS. ngrok creates a secure tunnel to your local server.

```bash
ngrok http 8080
```

Copy the generated HTTPS link, e.g.:
```
https://xxxx.ngrok-free.app
```

### Step 4 — Open on your device

**AR on iPhone:**
1. Install **WebXR Viewer** from the App Store (by Mozilla)
2. Open the ngrok HTTPS link inside WebXR Viewer
3. Tap **Enter AR** → allow camera → point at a flat surface

**VR on Oculus:**
1. Put on your Oculus / Meta Quest headset
2. Open **Meta Browser** (built-in)
3. Navigate to the ngrok HTTPS link
4. Tap **Enter VR**

> ⚠️ All devices must be on the **same WiFi network** as your PC.

---

## 📂 Project Structure

```
├── index.html      # Main app — all HTML, CSS, and JS in one file
└── README.md
```

---

## ✨ Features

- Interactive 3D scene with rotating cube, sphere, and torus
- Switch between shapes on the fly
- Wireframe toggle
- AR mode — overlays 3D object on real-world surfaces via phone camera
- VR mode — full immersive 3D environment in a headset

---

## 👤 Author

**Muhammad Arslan** — BSE-4A, FAST-NUCES Peshawar  
HCI Course Project
