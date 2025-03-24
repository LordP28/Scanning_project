import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/scan_bloc.dart';
import '../models/document.dart';
import '../widgets/document_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner de Documents'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: BlocBuilder<ScanBloc, ScanState>(
        builder: (context, state) {
          if (state is ScanLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ScanError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ScanBloc>().add(ScanDocumentEvent());
                    },
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          }

          if (state is ScanSuccess) {
            return DocumentCard(document: state.document);
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.document_scanner,
                  size: 64,
                  color: Colors.blue,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Commencez à scanner vos documents',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<ScanBloc>().add(ScanDocumentEvent());
                  },
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Scanner un document'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
} 