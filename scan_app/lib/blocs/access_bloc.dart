import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/student.dart';
import '../services/api_service.dart';

// Events
abstract class AccessEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class VerifyAccessEvent extends AccessEvent {
  final String qrCode;

  VerifyAccessEvent(this.qrCode);

  @override
  List<Object?> get props => [qrCode];
}

// States
abstract class AccessState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AccessInitial extends AccessState {}

class AccessLoading extends AccessState {}

class AccessGranted extends AccessState {
  final Student student;

  AccessGranted(this.student);

  @override
  List<Object?> get props => [student];
}

class AccessDenied extends AccessState {
  final String message;

  AccessDenied(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class AccessBloc extends Bloc<AccessEvent, AccessState> {
  final ApiService _apiService;

  AccessBloc(this._apiService) : super(AccessInitial()) {
    on<VerifyAccessEvent>(_onVerifyAccess);
  }

  Future<void> _onVerifyAccess(
    VerifyAccessEvent event,
    Emitter<AccessState> emit,
  ) async {
    try {
      emit(AccessLoading());
      final student = await _apiService.verifyStudentAccess(event.qrCode);
      
      if (student != null && student.hasAccess) {
        emit(AccessGranted(student));
      } else {
        emit(AccessDenied('Accès refusé: QR code invalide ou étudiant non autorisé'));
      }
    } catch (e) {
      emit(AccessDenied(e.toString()));
    }
  }
} 