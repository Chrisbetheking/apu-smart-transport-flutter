# GitHub Pages Web Demo

This project is prepared for a Flutter Web demo on GitHub Pages.

Expected URL after deployment:

```text
https://chrisbetheking.github.io/Flutter-Campus-Shuttle-App/
```

## One-time GitHub setup

1. Push the project to `https://github.com/Chrisbetheking/Flutter-Campus-Shuttle-App`.
2. Open the repository on GitHub.
3. Go to `Settings` → `Pages`.
4. Under `Build and deployment`, choose `GitHub Actions`.
5. Push to `main` again or manually run the workflow.

## Manual local build

```bash
flutter pub get
flutter build web --release --base-href /Flutter-Campus-Shuttle-App/
```

The generated site is placed in:

```text
build/web/
```

## Why the base href matters

Because the project is served from a repository path instead of the root domain, the build uses:

```bash
--base-href /Flutter-Campus-Shuttle-App/
```

This helps the browser load Flutter web assets correctly from the GitHub Pages URL.
