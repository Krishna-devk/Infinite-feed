import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/datasource/supabase_feed_datasource.dart';
import '../../data/repository/feed_repository.dart';
import '../../data/repository/supabase_feed_repository.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final feedDatasourceProvider = Provider<FeedDatasource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseFeedDatasource(client);
});

final feedRepositoryProvider = Provider<FeedRepository>((ref) {
  final datasource = ref.watch(feedDatasourceProvider);
  return SupabaseFeedRepository(datasource);
});
