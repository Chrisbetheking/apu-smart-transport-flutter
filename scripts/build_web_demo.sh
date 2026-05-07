#!/usr/bin/env bash
set -euo pipefail
flutter pub get
flutter build web --release --base-href /Flutter-Campus-Shuttle-App/
echo "Web demo build created in build/web"
