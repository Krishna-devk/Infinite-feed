import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_intern_work/core/errors/optimistic_rollback_exception.dart';

final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

final class RollbackObserver extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    if (newValue is AsyncError) {
      final error = newValue.error;
      if (error is OptimisticRollbackException) {
        _showErrorSnackBar(error.message);
      }
    }
  }

  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    if (error is OptimisticRollbackException) {
      _showErrorSnackBar(error.message);
    }
  }

  void _showErrorSnackBar(String message) {
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
