import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:collabin/core/common/api_exception.dart';
import 'package:collabin/core/common/shared_code.dart';
import 'package:collabin/core/service/notification_service.dart';
import 'package:collabin/feature/auth/bloc/login_bloc/login_event.dart';
import 'package:collabin/feature/auth/bloc/login_bloc/login_state.dart';
import 'package:collabin/feature/auth/repository/login_repository/login_repository.dart';

class LoginPageBloc extends Bloc<LoginPageEvent, LoginPageState> {
  final LoginRepository loginRepository;
  final SharedCode _sharedCode = SharedCode();

  LoginPageBloc({required this.loginRepository})
      : super(InitialLoginPageState()) {
    on<LoginButtonPressed>(_onLoginButtonPressed);
  }

  Future<void> _onLoginButtonPressed(
      LoginButtonPressed event,
      Emitter<LoginPageState> emit,
      ) async {
    emit(LoginPageLoading());

    try {
      final FirebaseLoginResult loginResult = await loginRepository.loginUser(
        email: event.email,
        password: event.password,
      );

      // ✅ Simpan Firebase ID Token + exp JWT agar tidak langsung dianggap expired.
      await _sharedCode.saveFirebaseAuthSession(token: loginResult.idToken);

      await NotificationService.instance.syncTokenAfterLogin(event.email);

      if (kDebugMode) {
        final token = await NotificationService.instance.getFcmToken();
        print('\n📱 [FCM TOKEN - LOGIN]');
        print(token);
        print('');
      }

      emit(LoginPageLoaded(loginResult));
    } catch (e) {
      if (e is ApiException) {
        emit(LoginPageError(e.message));
      } else {
        if (kDebugMode) {
          print('Login BLoC unexpected error: $e');
        }

        emit(LoginPageError('Terjadi kesalahan. Silakan coba lagi.'));
      }
    }
  }
}