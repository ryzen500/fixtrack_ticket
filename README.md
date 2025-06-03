# FixTrack-Ticket - Flutter Mobile App
---

## Ringkasan Proyek

FixTrack-Ticket adalah aplikasi mobile untuk manajemen tiket dan pelacakan perbaikan yang terintegrasi dengan backend FixTrack. Aplikasi ini memungkinkan pengguna untuk membuat, melihat, dan memperbarui tiket secara real-time melalui perangkat mobile.

---

## Progress Saat Ini

### 1. Struktur Proyek
- Setup project Flutter dengan Flutter SDK versi terbaru
- Struktur folder dasar sudah dibuat (lib/, assets/, etc.)
- Setup environment config (development / production)

### 2. Authentication
- Implementasi halaman Login dan Register (UI + Validasi dasar)
- Integrasi JWT Authentication dengan backend FixTrack (sudah berhasil login dan logout)
- Penyimpanan token dengan `flutter_secure_storage`

### 3. UI/UX Components
- Implementasi Bottom Navigation Bar (Bottom Tabs) untuk navigasi utama aplikasi
- Halaman Home dengan daftar tiket terbaru
- Halaman Ticket Detail sudah menampilkan data tiket dengan desain responsif
- Komponen utama UI menggunakan `Material Design` dan sudah responsive di berbagai ukuran layar

### 4. API Integration
- Integrasi API GET tiket list sudah berjalan lancar dengan error handling
- API GET detail tiket sudah terhubung dan menampilkan data secara dinamis
- Implementasi API POST untuk membuat tiket baru (sementara mock, menunggu backend fix)

### 5. State Management
- Menggunakan `Provider` sebagai state management dasar (saat ini sedang dioptimasi)
- Implementasi basic loading & error state di beberapa halaman

### 6. Fitur Tambahan
- Implementasi pull-to-refresh di halaman tiket list
- Fitur pencarian tiket (sementara dengan filter lokal)

---

## Task Selanjutnya

- Penyempurnaan UI/UX, terutama animasi dan transisi halaman
- Integrasi fitur update dan delete tiket
- Implementasi push notification (menggunakan Firebase Cloud Messaging)
- Optimasi state management, kemungkinan migrasi ke `Riverpod` atau `Bloc`
- Penambahan fitur upload attachment di tiket
- Testing dan bug fixing

---

## Cara Menjalankan Aplikasi

1. Clone repo  
   ```bash
   git clone https://github.com/yourusername/fixtrack_ticket.git
   cd fixtrack_ticket
   ```
2.Install dependencies
```bash
flutter pub get
```
3.Jalankan Aplikasi 
```bash
flutter run --hot
```
