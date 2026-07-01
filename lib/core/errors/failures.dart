sealed class Failure {
  final String message;
  const Failure(this.message);
}

final class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
}

final class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}
