import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';
import 'package:task_one_think/bloc/auth_bloc/auth_bloc.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {
  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String? email,
    required String? password,
  }) =>
      super.noSuchMethod(
          Invocation.method(#signInWithEmailAndPassword, [email, password]),
          returnValue: Future.value(MockUserCredential()));

}

class MockUserCredential extends Mock implements UserCredential {}
class MockUser extends Mock implements User {}

void main() {
  group('AuthBloc', () {
    late AuthBloc authBloc;
    late MockFirebaseAuth mockFirebaseAuth;
    late MockUserCredential mockUserCredential;
    late MockUser mockUser;



    setUp(() {
      mockFirebaseAuth = MockFirebaseAuth();
      mockUserCredential = MockUserCredential();
      authBloc = AuthBloc();
      mockUser = MockUser();

    });

    blocTest<AuthBloc, AuthState>(
      'emits [LoginLoading, LoginSuccess] when LoginRequest is added and login is successful',
      build: () {
        when(mockFirebaseAuth.signInWithEmailAndPassword(email: any, password: any))
            .thenAnswer((_) async => mockUserCredential);
        return authBloc;
      },
      act: (bloc) => bloc.add(LoginRequest('test@test.com', 'password')),
      expect: () => LoginSuccess(),

    );

    // blocTest<AuthBloc, AuthState>(
    //   'emits [LoginLoading, LoginError] when LoginRequest is added and login fails',
    //   build: () {
    //     when(mockFirebaseAuth.signInWithEmailAndPassword(
    //       email: "email",
    //       password: "password",
    //     )).thenThrow(
    //         FirebaseAuthException(message: 'Login failed', code: 'auth-error'));
    //     return authBloc;
    //   },
    //   act: (bloc) => bloc.add(LoginRequest('test@test.com', 'wrongpassword')),
    //   expect: () => [
    //     LoginLoading(),
    //     LoginError('Login failed (auth-error)'),
    //   ],
    // );
  });
}