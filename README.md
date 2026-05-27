# Ranro Loan Mobile App

Flutter mobile application for microfinance loan management — loan lookup, QR scanning, receipts, and Bluetooth printing.

## Overview

Field agent app for viewing loan details, scanning customer QR codes, listing loans with due amounts, and printing receipts via Bluetooth thermal printers.

## Features

- Loan list with due amount filtering
- QR code scanner for customer/loan lookup
- Loan detail views
- Bluetooth receipt printing
- REST API integration via HTTP

## Tech Stack

- **Flutter** / Dart
- **qr_code_scanner** — QR scanning
- **bluetooth_print** — thermal printer support
- **http** — API calls

## Getting Started

```bash
flutter pub get
flutter run
```

Ensure Bluetooth permissions are granted on Android for receipt printing.

## Project Structure

```
lib/
├── screens/
│   ├── home.dart                  # Dashboard
│   ├── loans_list.dart            # Loan listing
│   ├── qr_scanner.dart            # QR scan flow
│   ├── loan_show.dart             # Loan details
│   └── printing.dart              # Bluetooth print
└── models/                        # Data models
```

## Author

Kezara Lakshan — [GitHub](https://github.com/Kezara666)
