# flutter_quote_app

[**Live Demo**](https://pub-d4692e98317e41669dce14b2b23ddc7d.r2.dev/index.html)

Flutter web app that delivers a new inspirational quote every day, lets you favorite quotes, and browse your personal collection—all with a clean, elegant UI.

## Features

- **Quote of the Day:** Fetches a new quote from a public API and displays it in a stylish card.
- **Favorites:** Save your favorite quotes and view them in a colorful, swipe-to-remove list.
- **Social Sharing:** Share quotes with friends via your device's share dialog.
- **Modern Flat Design:** Clean, flat UI with a noble Royal Blue accent and colorful favorites cards.
- **Bottom Navigation:** Easily switch between Home and Favorites tabs.
- **Undo Remove:** Accidentally removed a favorite? Instantly undo with a snackbar action.

## Architecture

- **Clean Architecture:** Features are modularized (quote, favorites) with clear separation of data, domain, and presentation layers.
- **State Management:** Uses BLoC (flutter_bloc) and Provider for robust, scalable state management.
- **Persistence:** Uses shared_preferences for local storage of favorites and daily quote caching.

## Getting Started

1. **Clone the repo:**
   ```sh
   git clone <your-repo-url>
   cd flutter_quote_app
   ```
2. **Install dependencies:**
   ```sh
   flutter pub get
   ```
3. **Run the app:**
   ```sh
   flutter run
   ```
   - For web: `flutter run -d chrome`

## Customization
- Change the primary color in `main.dart` for a different accent.
- Update the quote API endpoint in the data layer if you want a different source.

---

Made with ❤️ using Flutter.
