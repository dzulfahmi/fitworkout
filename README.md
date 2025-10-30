Home Workout Tracker (Flutter + sqflite)

Sebuah aplikasi pelacak latihan (workout tracker) berbasis Flutter yang sederhana namun kuat, dirancang untuk membantu Anda membuat, mengelola, dan mencatat sesi latihan harian Anda. Semua data disimpan secara lokal menggunakan database sqflite.

Catatan: Sangat disarankan untuk merekam layar aplikasi Anda dan mengubahnya menjadi GIF, lalu letakkan di sini. Ini meningkatkan kualitas README Anda secara drastis.

🚀 Fitur Utama

Aplikasi ini dibangun untuk memenuhi semua kebutuhan dasar pelacakan latihan:

🏋️ Kelola Latihan (Workouts):

Buat, Baca, Edit, dan Hapus (CRUD) daftar latihan kustom Anda.

Simpan informasi penting seperti nama latihan, deskripsi, catatan, dan bahkan link YouTube untuk referensi visual.

📅 Kelola Rencana Latihan (Plans):

Buat rencana latihan tematik (misal: "Hari Kaki", "Latihan Punggung & Bisep", "Push Day").

Atur dan edit nama serta deskripsi untuk setiap rencana.

🔗 Penugasan Latihan yang Fleksibel:

Masukkan latihan apa pun dari daftar Anda ke dalam rencana latihan yang relevan.

Tentukan target spesifik untuk setiap latihan dalam rencana: jumlah Set, Repetisi Minimum, dan Repetisi Maksimum.

Dialog pintar mencegah penambahan latihan duplikat ke dalam satu rencana.

✍️ Pencatatan Sesi (Core Feature):

Mulai sesi latihan berdasarkan rencana yang telah Anda buat.

Catat setiap set yang Anda lakukan, termasuk jumlah repetisi dan berat yang digunakan (Fitur 4). (Catatan: UI untuk ini adalah langkah selanjutnya setelah plan_detail_screen).

📊 Riwayat Sesi:

Lihat riwayat lengkap dari semua sesi latihan yang telah Anda selesaikan.

Riwayat digabungkan dengan nama rencana dan diurutkan berdasarkan tanggal (dari yang terbaru) untuk kemudahan peninjauan.

🛠️ Tumpukan Teknologi (Tech Stack)

Framework: Flutter

Bahasa: Dart

Database: sqflite (Database SQL lokal di perangkat)

Navigasi: go_router (Manajemen rute yang bersih dan berbasis URL)

Utilitas:

path: Untuk manajemen path database lintas platform.

intl: Untuk memformat tanggal dan waktu agar mudah dibaca.

Struktur Database

Inti dari aplikasi ini adalah database relasional lokal yang terdiri dari 5 tabel untuk memastikan integritas data dan efisiensi.

Workouts: Tabel utama untuk semua latihan individu (e.g., "Push Up", "Squat").

WorkoutPlans: Tabel utama untuk rencana latihan (e.g., "Hari Kaki").

PlanWorkouts: Tabel penghubung (junction table) yang menghubungkan Workouts dan WorkoutPlans. Tabel ini juga menyimpan target set/reps.

WorkoutSessions: Tabel "header" yang mencatat setiap sesi latihan yang dimulai (kapan sesi itu terjadi dan rencana apa yang digunakan).

SessionLogs: Tabel "detail" yang mencatat setiap set yang dilakukan pengguna dalam WorkoutSession.

🏁 Memulai (Getting Started)

Untuk menjalankan proyek ini secara lokal, ikuti langkah-langkah berikut:

Clone repositori ini:

git clone [https://github.com/](https://github.com/)[USERNAME-ANDA]/[NAMA-REPO-ANDA].git


Masuk ke direktori proyek:

cd [NAMA-REPO-ANDA]


Dapatkan semua dependensi (packages):

flutter pub get


Jalankan aplikasi:

flutter run


📜 Lisensi

Proyek ini didistribusikan di bawah Lisensi MIT. Lihat file LICENSE untuk informasi lebih lanjut.