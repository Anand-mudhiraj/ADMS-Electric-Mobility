# ADMS Electric Mobility — 3D Showroom

> **Ride the Future.** A next-generation, client-facing 3D interactive showroom and digital dealership for ADMS Electric Mobility.

---

## ⚡ Overview

ADMS Electric Mobility 3D Showroom is a modern, responsive cross-platform application (Web, Android, iOS, Desktop) designed to deliver a premium automotive digital retail experience. Customers can explore high-performance electric scooters, interact with real-time 360° 3D models with AR capability, compare specifications side-by-side, and book test rides seamlessly.

---

## ✨ Key Features

- **Interactive 3D Showroom**: Full 360° rotation, zoom, lighting adjustments, and AR mode powered by Google's `<model-viewer>` component (`model_viewer_plus`).
- **Dynamic Vehicle Catalogue**: Real-time vehicle browsing with specs, color variants, pricing, and category filters.
- **Side-by-Side Model Comparison**: Direct head-to-head technical comparison of speed, battery range, motor power, and load capacity.
- **Test Ride & Enquiry System**: Multi-step booking form with validation, city/dealer selection, and privacy consent handling.
- **Responsive Dark Theme**: Tailored automotive design system with Rajdhani typography, neon lime accent lines, and glassmorphic elevation.
- **Admin Management Panel**: Dashboard metrics, vehicle inventory management, and enquiry pipeline tracking.

---

## 🛠 Tech Stack

- **Framework**: Flutter 3.x (Dart 3.x)
- **Routing**: `go_router` with declarative routing and SPA fallback support
- **State Management**: `flutter_bloc` & `provider`
- **3D Engine**: `model_viewer_plus` (WebGL & glTF/GLB)
- **Typography**: Google Fonts Rajdhani & Inter
- **Form Validation**: `flutter_form_builder` & `form_builder_validators`
- **Backend / Database**: Supabase Flutter SDK integration

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (>= 3.9.2)
- Git

### Installation

```bash
# Clone the repository
git clone https://github.com/Anand-mudhiraj/ADMS-Electric-Mobility.git

# Navigate to project directory
cd ADMS-Electric-Mobility

# Install dependencies
flutter pub get
```

### Running Locally

```bash
# Run web version
flutter run -d chrome

# Or build production web bundle
flutter build web --release
```

---

## 📁 Project Structure

```
lib/
├── core/
│   ├── routing/         # GoRouter route definitions & page transitions
│   ├── theme/           # AppColors, AppTheme, AppTextStyles, dimensions
│   └── widgets/         # Reusable buttons, cards, navbar, and logo
├── data/
│   ├── models/          # Scooter, Specs, Colour, Enquiry data models
│   └── services/        # Demo data & repository interfaces
└── features/
    ├── home/            # Hero section, features, highlights, and CTA
    ├── catalogue/       # Scooter listing and category filter
    ├── scooter_details/ # Specs table, color picker, and media viewer
    ├── showroom_3d/     # Interactive 3D ModelViewer screen
    ├── comparison/      # Side-by-side vehicle comparison table
    ├── enquiries/       # Test ride & purchase enquiry forms
    └── admin/           # Admin dashboard, inventory & leads management
```

---

## 📄 License

Proprietary © ADMS Electric Mobility. All rights reserved.
