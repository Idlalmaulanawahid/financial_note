# Financial Privacy

Aplikasi pencatatan keuangan pribadi dengan storage lokal. Data tersimpan aman di perangkat Anda.

## Fitur Utama

- 📊 Dashboard dengan ringkasan saldo & pengeluaran
- 💰 Pencatatan transaksi (pemasukan & pengeluaran)
- 📈 Visualisasi pengeluaran dengan pie chart
- 🎯 Target tabungan dengan tracking progress
- 📄 Export laporan ke PDF
- 🌓 Mode gelap & terang
- 💾 Penyimpanan data lokal (tidak ada cloud)

## Prerequisites

Sebelum membangun aplikasi, pastikan Anda sudah install:

- **Flutter SDK**: [Unduh di sini](https://docs.flutter.dev/get-started/install)
- **Dart SDK**: Sudah termasuk dalam Flutter SDK
- **Android Studio** atau **Xcode** (untuk build native)
- **Git** (untuk version control)

Verifikasi instalasi:
```bash
flutter --version
dart --version
```

## Setup Awal

### 1. Clone Repository
```bash
git clone <repository-url>
cd financial_privacy
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Generate Localization (Opsional)
Jika menggunakan internationalization:
```bash
flutter gen-l10n
```

## Build & Run

### Run di Development Mode
```bash
flutter run
```

Untuk menjalankan di device/emulator tertentu:
```bash
flutter run -d <device-id>
```

Lihat daftar device yang tersedia:
```bash
flutter devices
```

### Build APK (Android Release)
```bash
flutter build apk --release
```

Hasil build ada di: `build/app/outputs/flutter-apk/app-release.apk`

**Dengan split ABIs (ukuran lebih kecil):**
```bash
flutter build apk --split-per-abi --release
```

### Build AAB (Android App Bundle - untuk Play Store)
```bash
flutter build appbundle --release
```

Hasil build ada di: `build/app/outputs/bundle/release/app-release.aab`

### Build iOS (macOS only)
```bash
flutter build ios --release
```

Untuk menjalankan iOS development:
```bash
flutter run -d ios
```

### Build Web
```bash
flutter build web --release
```

Hasil ada di: `build/web/`

## Struktur Project

```
lib/
├── core/
│   ├── constants/      # App constants
│   ├── theme/          # Theme & colors
│   └── utils/          # Utility functions
├── data/
│   ├── datasources/    # Database operations
│   ├── models/         # Data models
│   └── repositories/   # Data layer
├── domain/
│   ├── entities/       # Business entities
│   ├── repositories/   # Repository interfaces
│   └── usecases/       # Use cases
└── presentation/
    ├── blocs/          # State management (BLoC)
    ├── pages/          # Screens
    └── widgets/        # Reusable components
```

## Theme Mode

Aplikasi mendukung **mode gelap** dan **mode terang**. Untuk switch mode:
1. Buka aplikasi
2. Tap icon ☀️/🌙 di AppBar
3. Tema akan berubah otomatis

## Dependencies Utama

| Package | Versi | Fungsi |
|---------|-------|--------|
| flutter_bloc | 9.1.0 | State management |
| sqflite | 2.4.1 | Local database |
| fl_chart | 0.70.2 | Charts & visualizations |
| pdf | 3.11.3 | PDF generation |
| share_plus | 10.1.4 | Share functionality |
| google_fonts | Latest | Font management |
| intl | Latest | Localization |

## Troubleshooting

### Build Gagal
```bash
# Clean build
flutter clean
flutter pub get
flutter pub upgrade
flutter build apk --release
```

### APK/AAB Signing (untuk production)
```bash
# Generate keystore (sekali saja)
keytool -genkey -v -keystore ~/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key

# Build dengan signing
flutter build apk --release --signing-key=~/key.jks --signing-key-password=<password> \
  --signing-key-alias=key --signing-key-alias-password=<password>
```

### Database Issues
Jika ada masalah dengan database:
```bash
flutter clean
rm -rf build/
flutter pub get
flutter run
```

## Development Tips

- **Hot Reload**: Tekan `r` di terminal untuk reload tanpa restart
- **Hot Restart**: Tekan `R` untuk restart aplikasi lengkap
- **Debug Mode**: Jalankan dengan `flutter run` untuk debug
- **Profile Mode**: `flutter run --profile` untuk performance testing
- **Release Mode**: `flutter run --release` untuk production testing

## Testing

Jalankan unit & widget tests:
```bash
flutter test
```

Untuk test tertentu:
```bash
flutter test test/filename_test.dart
```

## Contributing

1. Create branch baru: `git checkout -b feature/nama-fitur`
2. Commit changes: `git commit -m "feat: deskripsi"`
3. Push ke branch: `git push origin feature/nama-fitur`
4. Buat Pull Request

## License

Project ini adalah milik pribadi. Penggunaan dan distribusi harus seizin pemilik.

## Support

Untuk bantuan atau pertanyaan, hubungi pengembang aplikasi.
