# NeuroTrace AI

**AI Early Detection of Microplastic-Induced Neurological Effects Using Digital Neurobehavioral Biomarkers**

## Overview

NeuroTrace AI is a cross-platform mobile application that uses smartphone-based cognitive, motor, reaction time, and speech tests to detect early neurobehavioral changes associated with microplastic exposure. The system provides a low-cost, scalable, and non-invasive tool for early neurological risk assessment.

## Features

- **Reaction Time Test**: High-precision timers for measuring response times
- **Cognitive Memory Tasks**: N-back and other memory assessment tests
- **Motor Control Tasks**: Path tracing and tapping exercises
- **Speech Recording Module**: Audio analysis for voice biomarkers
- **Microplastic Exposure Survey**: Comprehensive exposure assessment
- **Real-time Risk Assessment**: ML-powered neurological risk scoring
- **Secure Data Management**: Encrypted storage and transmission

## Architecture

### Mobile App (Flutter)
- Cross-platform support (iOS, Android, Web)
- High-precision input tracking
- Real-time feedback UI
- Secure data transmission

### Backend (FastAPI)
- RESTful API for data management
- Feature extraction services
- ML inference engine
- PostgreSQL database

### Machine Learning Pipeline
- Multi-modal feature extraction
- Risk prediction models (Logistic Regression, Random Forest, XGBoost)
- Real-time scoring and visualization

## Tech Stack

- **Mobile**: Flutter
- **Backend**: FastAPI (Python)
- **Database**: PostgreSQL
- **ML/AI**: scikit-learn, XGBoost, librosa, parselmouth
- **Security**: AES-256 encryption, HTTPS/TLS

## Getting Started

### Prerequisites
- Flutter SDK (>=3.9.2)
- Dart SDK
- Android Studio / Xcode (for mobile development)
- Python 3.9+ (for backend)

### Installation

1. Clone the repository
```bash
git clone https://github.com/yourusername/neurotrace_ai.git
cd neurotrace_ai
```

2. Install Flutter dependencies
```bash
flutter pub get
```

3. Run the app
```bash
flutter run
```

## Project Structure

```
lib/
├── core/           # Core utilities, constants, themes
├── data/           # Data models, repositories, data sources
├── domain/         # Business logic, entities, use cases
├── presentation/   # UI screens, widgets, state management
└── main.dart       # App entry point
```

## Development Status

🚧 **In Active Development** - This project is part of ongoing research.

## License

This project is proprietary and part of academic research.

## Contact

For research inquiries or collaboration opportunities, please contact the development team.

## Acknowledgments

This project is developed as part of passion research on microplastic-induced neurological effects.

