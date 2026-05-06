// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PostModel _$PostModelFromJson(Map<String, dynamic> json) => _PostModel(
  id: json['id'] as String? ?? '',
  authorName: json['author_name'] as String? ?? 'Anonymous',
  authorAvatarUrl: json['author_avatar_url'] as String? ?? '',
  content: json['content'] as String? ?? '',
  mediaThumbUrl: json['media_thumb_url'] as String? ?? '',
  mediaMobileUrl: json['media_mobile_url'] as String? ?? '',
  mediaRawUrl: json['media_raw_url'] as String?,
  likeCount: (json['like_count'] as num?)?.toInt() ?? 0,
  isLiked: json['is_liked'] as bool? ?? false,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$PostModelToJson(_PostModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'author_name': instance.authorName,
      'author_avatar_url': instance.authorAvatarUrl,
      'content': instance.content,
      'media_thumb_url': instance.mediaThumbUrl,
      'media_mobile_url': instance.mediaMobileUrl,
      'media_raw_url': instance.mediaRawUrl,
      'like_count': instance.likeCount,
      'is_liked': instance.isLiked,
      'created_at': instance.createdAt?.toIso8601String(),
    };
