# A‑Eye 👁️

A‑Eye is an intelligent application that integrates multiple AI models and services to deliver advanced recognition features. It combines custom‑trained models with Google ML Kit and Firebase ML to provide a versatile toolkit for vision and text recognition tasks.

---

## ✨ Features

1. **Object Detection (YOLOv4)**
   - Trained on the COCO dataset.
   - Converted to TensorFlow Lite for efficient mobile integration.
   - Detects and classifies real‑world objects in real time.

2. **Text Recognition (Firebase ML Kit)**
   - Uses Firebase ML Kit’s on‑device text recognition.
   - Supports scanning and extracting text from images and documents.

3. **Face Recognition (Google ML Kit)**
   - Leverages Google ML Kit’s face detection APIs.
   - Identifies and tracks facial features with high accuracy.

4. **Currency Recognition (VGG19)**
   - Custom model trained on Kaggle datasets.
   - Recognizes and classifies different currency notes.

---

## 🛠️ Technology Stack

- **Frontend:** Flutter (with Lottie animations for UI/UX enhancements)
- **AI/ML Models:** YOLOv4, VGG19, Firebase ML Kit, Google ML Kit
- **Datasets:** Kaggle datasets (trained and converted to TFLite)

---

## 📂 Project Structure

- `models/` → Trained models (YOLOv4, VGG19, TFLite conversions)
- `backend/` → Flask server for model integration
- `frontend/` → Flutter app with Lottie animations
- `data/` → Kaggle datasets used for training

---

## 🚀 Getting Started

1. Clone the repository:
   ```bash
   git clone https://github.com/sapnakhan7/MY_A_EYE.git
   cd MY_A_EYE

