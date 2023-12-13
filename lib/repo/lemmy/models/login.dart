class LemmyLoginResponse {
  LemmyLoginResponse({
    required this.registrationCreated,
    required this.verifyEmailSent,
    this.jwt,
  });

  final String? jwt;
  final bool registrationCreated;
  final bool verifyEmailSent;
}
