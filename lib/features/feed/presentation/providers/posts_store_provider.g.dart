// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'posts_store_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PostsStore)
final postsStoreProvider = PostsStoreProvider._();

final class PostsStoreProvider
    extends $NotifierProvider<PostsStore, Map<String, PostEntity>> {
  PostsStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'postsStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$postsStoreHash();

  @$internal
  @override
  PostsStore create() => PostsStore();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, PostEntity> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, PostEntity>>(value),
    );
  }
}

String _$postsStoreHash() => r'ff93abd60ceefb8e35469bdfde735aea91461384';

abstract class _$PostsStore extends $Notifier<Map<String, PostEntity>> {
  Map<String, PostEntity> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<Map<String, PostEntity>, Map<String, PostEntity>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<String, PostEntity>, Map<String, PostEntity>>,
              Map<String, PostEntity>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
