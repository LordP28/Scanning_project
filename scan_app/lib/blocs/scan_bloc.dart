import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/document.dart';
import '../services/scan_service.dart';

// Events
abstract class ScanEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ScanDocumentEvent extends ScanEvent {}

class LoadDocumentsEvent extends ScanEvent {}

// States
abstract class ScanState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ScanInitial extends ScanState {}

class ScanLoading extends ScanState {}

class ScanSuccess extends ScanState {
  final Document document;

  ScanSuccess(this.document);

  @override
  List<Object?> get props => [document];
}

class ScanError extends ScanState {
  final String message;

  ScanError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class ScanBloc extends Bloc<ScanEvent, ScanState> {
  final ScanService _scanService;

  ScanBloc(this._scanService) : super(ScanInitial()) {
    on<ScanDocumentEvent>(_onScanDocument);
    on<LoadDocumentsEvent>(_onLoadDocuments);
  }

  Future<void> _onScanDocument(
    ScanDocumentEvent event,
    Emitter<ScanState> emit,
  ) async {
    try {
      emit(ScanLoading());
      final document = await _scanService.scanDocument();
      emit(ScanSuccess(document));
    } catch (e) {
      emit(ScanError(e.toString()));
    }
  }

  Future<void> _onLoadDocuments(
    LoadDocumentsEvent event,
    Emitter<ScanState> emit,
  ) async {
    // TODO: Implement document loading from storage
    emit(ScanInitial());
  }
} 