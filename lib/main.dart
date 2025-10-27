import 'package:fit_workout/app_router.dart';
import 'package:flutter/material.dart';

void main() async {
  // Pastikan Flutter binding diinisialisasi sebelum menjalankan kode async
  WidgetsFlutterBinding.ensureInitialized();

  // Anda bisa inisialisasi database di sini jika perlu,
  // tapi lebih baik dilakukan 'lazy' (saat pertama kali dibutuhkan)
  // di dalam DatabaseHelper.

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Ubah dari MaterialApp ke MaterialApp.router
    return MaterialApp.router(
      title: 'Home Workout Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF0F2F5),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 1,
          foregroundColor: Colors.black87,
          titleTextStyle: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        // --- PERBAIKAN DI SINI ---
        // Mengganti CardTheme (sebuah widget) dengan CardThemeData (sebuah objek data tema)
        cardTheme: CardThemeData(
          elevation: 0.5,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blue.shade700,
          foregroundColor: Colors.white,
        ),
      ),
      // Hapus 'home' karena sudah di-handle routerConfig
      // home: const HomeScreen(),

      // Tambahkan routerConfig dari file app_router.dart
      routerConfig: appRouter,

      debugShowCheckedModeBanner: false,
    );
  }
}