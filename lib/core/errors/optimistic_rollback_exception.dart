class OptimisticRollbackException implements Exception {
  final String message;
  final String postId;

  OptimisticRollbackException({
    required this.message,
    required this.postId,
  });

  @override
  String toString() => 'OptimisticRollbackException: $message (Post ID: $postId)';
}
