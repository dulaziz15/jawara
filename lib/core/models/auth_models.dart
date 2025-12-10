class AuthModel {
  final String uid;
  final String? email;

  AuthModel({
    required this.uid,
    this.email,
  });

  // Factory untuk mengubah User dari Firebase menjadi AuthModel kita
  factory AuthModel.fromFirebaseUser(dynamic user) {
    return AuthModel(
      uid: user.uid,
      email: user.email,
    );
  }
}