import 'package:equatable/equatable.dart';

class PostEntity extends Equatable {
  final String id;
  final String authorName;
  final String authorAvatarUrl;
  final String content;
  final String mediaThumbUrl;
  final String mediaMobileUrl;
  final String? mediaRawUrl;
  final int likeCount;
  final bool isLiked;
  final DateTime createdAt;

  const PostEntity({
    required this.id,
    required this.authorName,
    required this.authorAvatarUrl,
    required this.content,
    required this.mediaThumbUrl,
    required this.mediaMobileUrl,
    this.mediaRawUrl,
    required this.likeCount,
    required this.isLiked,
    required this.createdAt,
  });

  PostEntity copyWith({
    String? id,
    String? authorName,
    String? authorAvatarUrl,
    String? content,
    String? mediaThumbUrl,
    String? mediaMobileUrl,
    String? mediaRawUrl,
    int? likeCount,
    bool? isLiked,
    DateTime? createdAt,
  }) {
    return PostEntity(
      id: id ?? this.id,
      authorName: authorName ?? this.authorName,
      authorAvatarUrl: authorAvatarUrl ?? this.authorAvatarUrl,
      content: content ?? this.content,
      mediaThumbUrl: mediaThumbUrl ?? this.mediaThumbUrl,
      mediaMobileUrl: mediaMobileUrl ?? this.mediaMobileUrl,
      mediaRawUrl: mediaRawUrl ?? this.mediaRawUrl,
      likeCount: likeCount ?? this.likeCount,
      isLiked: isLiked ?? this.isLiked,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        authorName,
        authorAvatarUrl,
        content,
        mediaThumbUrl,
        mediaMobileUrl,
        mediaRawUrl,
        likeCount,
        isLiked,
        createdAt,
      ];
}
