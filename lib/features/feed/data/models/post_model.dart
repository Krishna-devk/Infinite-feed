import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/post_entity.dart';

part 'post_model.freezed.dart';
part 'post_model.g.dart';

@freezed
abstract class PostModel with _$PostModel {
  const factory PostModel({
    @Default('') String id,
    @JsonKey(name: 'author_name') @Default('Anonymous') String authorName,
    @JsonKey(name: 'author_avatar_url') @Default('') String authorAvatarUrl,
    @Default('') String content,
    @JsonKey(name: 'media_thumb_url') @Default('') String mediaThumbUrl,
    @JsonKey(name: 'media_mobile_url') @Default('') String mediaMobileUrl,
    @JsonKey(name: 'media_raw_url') String? mediaRawUrl,
    @JsonKey(name: 'like_count') @Default(0) int likeCount,
    @JsonKey(name: 'is_liked') @Default(false) bool isLiked,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  }) = _PostModel;

  factory PostModel.fromJson(Map<String, dynamic> json) => _$PostModelFromJson(json);

  factory PostModel.fromEntity(PostEntity entity) => PostModel(
        id: entity.id,
        authorName: entity.authorName,
        authorAvatarUrl: entity.authorAvatarUrl,
        content: entity.content,
        mediaThumbUrl: entity.mediaThumbUrl,
        mediaMobileUrl: entity.mediaMobileUrl,
        mediaRawUrl: entity.mediaRawUrl,
        likeCount: entity.likeCount,
        isLiked: entity.isLiked,
        createdAt: entity.createdAt,
      );

  const PostModel._();

  PostEntity toEntity() => PostEntity(
        id: id,
        authorName: authorName,
        authorAvatarUrl: authorAvatarUrl,
        content: content,
        mediaThumbUrl: mediaThumbUrl,
        mediaMobileUrl: mediaMobileUrl,
        mediaRawUrl: mediaRawUrl,
        likeCount: likeCount,
        isLiked: isLiked,
        createdAt: createdAt ?? DateTime.now(),
      );
}
