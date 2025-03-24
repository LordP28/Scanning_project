import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'services/scan_service.dart';
import 'services/api_service.dart';
import 'blocs/scan_bloc.dart';
import 'blocs/access_bloc.dart';
import 'views/qr_scanner_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ScanBloc(ScanService())),
        BlocProvider(create: (context) => AccessBloc(ApiService())),
      ],
      child: MaterialApp(
        title: 'Scanner de Documents',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        home: const QRScannerScreen(),
      ),
    );
  }
}
