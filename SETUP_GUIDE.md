# Weather App - Setup Guide

## File yang Dibuat
```
WeatherApp/
├── WeatherApp.swift       ← App entry point
├── ContentView.swift      ← Root view (state management)
├── Models.swift           ← Data structures
├── LocationManager.swift  ← GPS + reverse geocoding
├── WeatherService.swift   ← Open-Meteo API calls
├── WeatherHelper.swift    ← Icon/text helpers, date utils
├── MainWeatherView.swift  ← Main screen
├── ForecastView.swift     ← 7-day forecast screen
└── Components.swift       ← Reusable UI components
```

---

## Langkah Setup di Xcode (Mac)

### 1. Buat Project Baru
- Buka **Xcode**
- **File > New > Project**
- Pilih **iOS > App**
- Product Name: `WeatherApp`
- Interface: **SwiftUI**
- Language: **Swift**
- Klik **Next**, pilih lokasi simpan

### 2. Set iOS Deployment Target
- Klik project di sidebar (ikon biru)
- Tab **General**
- **Minimum Deployments**: ubah ke **iOS 16.0**

### 3. Copy Swift Files
- Hapus file default: `ContentView.swift` (yang dibuat Xcode)
- Drag & drop SEMUA file `.swift` dari folder `WeatherApp/` ke Xcode project
- Pastikan ✅ "Copy items if needed" dicentang
- Klik **Finish**

### 4. Tambah Location Permission di Info.plist
- Klik **Info.plist** di sidebar Xcode
- Klik tombol **+** untuk tambah row baru
- Tambahkan 2 keys berikut:

| Key | Value |
|-----|-------|
| `NSLocationWhenInUseUsageDescription` | `WeatherApp needs your location to show accurate local weather.` |
| `NSLocationAlwaysAndWhenInUseUsageDescription` | `WeatherApp needs your location to show accurate local weather.` |

### 5. Build & Run
- Pilih target: **iPhone simulator** atau **device fisik**
- Tekan **Cmd + R** atau klik tombol ▶
- Saat prompt muncul: klik **"Allow While Using App"**

---

## API Info

**Open-Meteo** (https://open-meteo.com)
- ✅ 100% FREE - tidak perlu API key
- ✅ No registration required
- ✅ 7 hari forecast
- ✅ Data real-time
- ✅ Open source

---

## Fitur App

- 📍 **GPS otomatis** - deteksi lokasi + nama kota
- 🌡️ **Cuaca real-time** - suhu, kondisi, angin, humidity
- ⏱️ **Hourly forecast** - prediksi per jam hari ini
- 📅 **7-day forecast** - prediksi 7 hari ke depan
- 🌙 **Dark theme** - desain seperti referensi gambar
- 🔄 **Auto refresh** - update saat lokasi terdeteksi

---

## Troubleshooting

**"Location not working"**
→ Pastikan permission sudah di-allow di Settings > Privacy > Location

**"Build error: NavigationStack"**
→ Pastikan deployment target sudah diset ke iOS 16.0

**"Build error: missing files"**
→ Pastikan semua 9 file .swift sudah di-add ke Xcode project

**"Weather not loading"**
→ Pastikan simulator/device terhubung internet
