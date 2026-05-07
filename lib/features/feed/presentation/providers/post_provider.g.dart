// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Post)
final postProvider = PostFamily._();

final class PostProvider extends $NotifierProvider<Post, PostState> {
  PostProvider._({
    required PostFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'postProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$postHash();

  @override
  String toString() {
    return r'postProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  Post create() => Post();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PostState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PostState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PostProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$postHash() => r'fc0c0ef870727617e0b2b77277dbe92214bbe07d';

final class PostFamily extends $Family
    with $ClassFamilyOverride<Post, PostState, PostState, PostState, String> {
  PostFamily._()
    : super(
        retry: null,
        name: r'postProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  PostProvider call(String id) => PostProvider._(argument: id, from: this);

  @override
  String toString() => r'postProvider';
}

abstract class _$Post extends $Notifier<PostState> {
  late final _$args = ref.$arg as String;
  String get id => _$args;

  PostState build(String id);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<PostState, PostState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PostState, PostState>,
              PostState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
