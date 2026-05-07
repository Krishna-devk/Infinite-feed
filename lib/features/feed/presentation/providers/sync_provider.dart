import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_intern_work/features/feed/presentation/providers/repository_provider.dart';

part 'sync_provider.g.dart';

@Riverpod(keepAlive: true)
class SyncService extends _$SyncService {
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  @override
  bool build() {
    _subscription = Connectivity().onConnectivityChanged.listen((results) {
      final isOnline = results.any((r) => r != ConnectivityResult.none);
      if (isOnline) {
        _processQueue();
      }
    });

    ref.onDispose(() => _subscription?.cancel());
    return true;
  }

  Future<void> _processQueue() async {
    final box = Hive.box('sync_queue');
    if (box.isEmpty) return;

    final repository = ref.read(feedRepositoryProvider);
    final pendingIds = box.keys.cast<String>().toList();

    for (final id in pendingIds) {
      try {
        await repository.toggleLike(id);
        await box.delete(id);
      } catch (e) {
        // Silently fail, will retry on next connectivity change
      }
    }
  }

  void queueAction(String postId) {
    final box = Hive.box('sync_queue');
    box.put(postId, true);
  }
}
