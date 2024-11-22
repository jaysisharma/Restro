bool isValidEmail(String email) {
  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
  return emailRegex.hasMatch(email);
}

bool isValidPassword(String password) {
  // Add your password validation logic (e.g., length, special characters)
  return password.length >= 6;
}
