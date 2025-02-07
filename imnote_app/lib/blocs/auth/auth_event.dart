abstract class AuthEvent {}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  SignInRequested({required this.email, required this.password});
}

class RegisterRequested extends AuthEvent {
  final String username;
  final String email;
  final String password;

  RegisterRequested(
      {required this.username, required this.email, required this.password});
}

class SignOutRequested extends AuthEvent {}
