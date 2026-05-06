// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PostModel {

 String get id;@JsonKey(name: 'author_name') String get authorName;@JsonKey(name: 'author_avatar_url') String get authorAvatarUrl; String get content;@JsonKey(name: 'media_thumb_url') String get mediaThumbUrl;@JsonKey(name: 'media_mobile_url') String get mediaMobileUrl;@JsonKey(name: 'media_raw_url') String? get mediaRawUrl;@JsonKey(name: 'like_count') int get likeCount;@JsonKey(name: 'is_liked') bool get isLiked;@JsonKey(name: 'created_at') DateTime? get createdAt;
/// Create a copy of PostModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PostModelCopyWith<PostModel> get copyWith => _$PostModelCopyWithImpl<PostModel>(this as PostModel, _$identity);

  /// Serializes this PostModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PostModel&&(identical(other.id, id) || other.id == id)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.authorAvatarUrl, authorAvatarUrl) || other.authorAvatarUrl == authorAvatarUrl)&&(identical(other.content, content) || other.content == content)&&(identical(other.mediaThumbUrl, mediaThumbUrl) || other.mediaThumbUrl == mediaThumbUrl)&&(identical(other.mediaMobileUrl, mediaMobileUrl) || other.mediaMobileUrl == mediaMobileUrl)&&(identical(other.mediaRawUrl, mediaRawUrl) || other.mediaRawUrl == mediaRawUrl)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount)&&(identical(other.isLiked, isLiked) || other.isLiked == isLiked)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,authorName,authorAvatarUrl,content,mediaThumbUrl,mediaMobileUrl,mediaRawUrl,likeCount,isLiked,createdAt);

@override
String toString() {
  return 'PostModel(id: $id, authorName: $authorName, authorAvatarUrl: $authorAvatarUrl, content: $content, mediaThumbUrl: $mediaThumbUrl, mediaMobileUrl: $mediaMobileUrl, mediaRawUrl: $mediaRawUrl, likeCount: $likeCount, isLiked: $isLiked, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $PostModelCopyWith<$Res>  {
  factory $PostModelCopyWith(PostModel value, $Res Function(PostModel) _then) = _$PostModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'author_name') String authorName,@JsonKey(name: 'author_avatar_url') String authorAvatarUrl, String content,@JsonKey(name: 'media_thumb_url') String mediaThumbUrl,@JsonKey(name: 'media_mobile_url') String mediaMobileUrl,@JsonKey(name: 'media_raw_url') String? mediaRawUrl,@JsonKey(name: 'like_count') int likeCount,@JsonKey(name: 'is_liked') bool isLiked,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class _$PostModelCopyWithImpl<$Res>
    implements $PostModelCopyWith<$Res> {
  _$PostModelCopyWithImpl(this._self, this._then);

  final PostModel _self;
  final $Res Function(PostModel) _then;

/// Create a copy of PostModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? authorName = null,Object? authorAvatarUrl = null,Object? content = null,Object? mediaThumbUrl = null,Object? mediaMobileUrl = null,Object? mediaRawUrl = freezed,Object? likeCount = null,Object? isLiked = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,authorAvatarUrl: null == authorAvatarUrl ? _self.authorAvatarUrl : authorAvatarUrl // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,mediaThumbUrl: null == mediaThumbUrl ? _self.mediaThumbUrl : mediaThumbUrl // ignore: cast_nullable_to_non_nullable
as String,mediaMobileUrl: null == mediaMobileUrl ? _self.mediaMobileUrl : mediaMobileUrl // ignore: cast_nullable_to_non_nullable
as String,mediaRawUrl: freezed == mediaRawUrl ? _self.mediaRawUrl : mediaRawUrl // ignore: cast_nullable_to_non_nullable
as String?,likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int,isLiked: null == isLiked ? _self.isLiked : isLiked // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [PostModel].
extension PostModelPatterns on PostModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PostModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PostModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PostModel value)  $default,){
final _that = this;
switch (_that) {
case _PostModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PostModel value)?  $default,){
final _that = this;
switch (_that) {
case _PostModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'author_name')  String authorName, @JsonKey(name: 'author_avatar_url')  String authorAvatarUrl,  String content, @JsonKey(name: 'media_thumb_url')  String mediaThumbUrl, @JsonKey(name: 'media_mobile_url')  String mediaMobileUrl, @JsonKey(name: 'media_raw_url')  String? mediaRawUrl, @JsonKey(name: 'like_count')  int likeCount, @JsonKey(name: 'is_liked')  bool isLiked, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PostModel() when $default != null:
return $default(_that.id,_that.authorName,_that.authorAvatarUrl,_that.content,_that.mediaThumbUrl,_that.mediaMobileUrl,_that.mediaRawUrl,_that.likeCount,_that.isLiked,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'author_name')  String authorName, @JsonKey(name: 'author_avatar_url')  String authorAvatarUrl,  String content, @JsonKey(name: 'media_thumb_url')  String mediaThumbUrl, @JsonKey(name: 'media_mobile_url')  String mediaMobileUrl, @JsonKey(name: 'media_raw_url')  String? mediaRawUrl, @JsonKey(name: 'like_count')  int likeCount, @JsonKey(name: 'is_liked')  bool isLiked, @JsonKey(name: 'created_at')  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _PostModel():
return $default(_that.id,_that.authorName,_that.authorAvatarUrl,_that.content,_that.mediaThumbUrl,_that.mediaMobileUrl,_that.mediaRawUrl,_that.likeCount,_that.isLiked,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'author_name')  String authorName, @JsonKey(name: 'author_avatar_url')  String authorAvatarUrl,  String content, @JsonKey(name: 'media_thumb_url')  String mediaThumbUrl, @JsonKey(name: 'media_mobile_url')  String mediaMobileUrl, @JsonKey(name: 'media_raw_url')  String? mediaRawUrl, @JsonKey(name: 'like_count')  int likeCount, @JsonKey(name: 'is_liked')  bool isLiked, @JsonKey(name: 'created_at')  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _PostModel() when $default != null:
return $default(_that.id,_that.authorName,_that.authorAvatarUrl,_that.content,_that.mediaThumbUrl,_that.mediaMobileUrl,_that.mediaRawUrl,_that.likeCount,_that.isLiked,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PostModel extends PostModel {
  const _PostModel({this.id = '', @JsonKey(name: 'author_name') this.authorName = 'Anonymous', @JsonKey(name: 'author_avatar_url') this.authorAvatarUrl = '', this.content = '', @JsonKey(name: 'media_thumb_url') this.mediaThumbUrl = '', @JsonKey(name: 'media_mobile_url') this.mediaMobileUrl = '', @JsonKey(name: 'media_raw_url') this.mediaRawUrl, @JsonKey(name: 'like_count') this.likeCount = 0, @JsonKey(name: 'is_liked') this.isLiked = false, @JsonKey(name: 'created_at') this.createdAt}): super._();
  factory _PostModel.fromJson(Map<String, dynamic> json) => _$PostModelFromJson(json);

@override@JsonKey() final  String id;
@override@JsonKey(name: 'author_name') final  String authorName;
@override@JsonKey(name: 'author_avatar_url') final  String authorAvatarUrl;
@override@JsonKey() final  String content;
@override@JsonKey(name: 'media_thumb_url') final  String mediaThumbUrl;
@override@JsonKey(name: 'media_mobile_url') final  String mediaMobileUrl;
@override@JsonKey(name: 'media_raw_url') final  String? mediaRawUrl;
@override@JsonKey(name: 'like_count') final  int likeCount;
@override@JsonKey(name: 'is_liked') final  bool isLiked;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;

/// Create a copy of PostModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PostModelCopyWith<_PostModel> get copyWith => __$PostModelCopyWithImpl<_PostModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PostModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PostModel&&(identical(other.id, id) || other.id == id)&&(identical(other.authorName, authorName) || other.authorName == authorName)&&(identical(other.authorAvatarUrl, authorAvatarUrl) || other.authorAvatarUrl == authorAvatarUrl)&&(identical(other.content, content) || other.content == content)&&(identical(other.mediaThumbUrl, mediaThumbUrl) || other.mediaThumbUrl == mediaThumbUrl)&&(identical(other.mediaMobileUrl, mediaMobileUrl) || other.mediaMobileUrl == mediaMobileUrl)&&(identical(other.mediaRawUrl, mediaRawUrl) || other.mediaRawUrl == mediaRawUrl)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount)&&(identical(other.isLiked, isLiked) || other.isLiked == isLiked)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,authorName,authorAvatarUrl,content,mediaThumbUrl,mediaMobileUrl,mediaRawUrl,likeCount,isLiked,createdAt);

@override
String toString() {
  return 'PostModel(id: $id, authorName: $authorName, authorAvatarUrl: $authorAvatarUrl, content: $content, mediaThumbUrl: $mediaThumbUrl, mediaMobileUrl: $mediaMobileUrl, mediaRawUrl: $mediaRawUrl, likeCount: $likeCount, isLiked: $isLiked, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$PostModelCopyWith<$Res> implements $PostModelCopyWith<$Res> {
  factory _$PostModelCopyWith(_PostModel value, $Res Function(_PostModel) _then) = __$PostModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'author_name') String authorName,@JsonKey(name: 'author_avatar_url') String authorAvatarUrl, String content,@JsonKey(name: 'media_thumb_url') String mediaThumbUrl,@JsonKey(name: 'media_mobile_url') String mediaMobileUrl,@JsonKey(name: 'media_raw_url') String? mediaRawUrl,@JsonKey(name: 'like_count') int likeCount,@JsonKey(name: 'is_liked') bool isLiked,@JsonKey(name: 'created_at') DateTime? createdAt
});




}
/// @nodoc
class __$PostModelCopyWithImpl<$Res>
    implements _$PostModelCopyWith<$Res> {
  __$PostModelCopyWithImpl(this._self, this._then);

  final _PostModel _self;
  final $Res Function(_PostModel) _then;

/// Create a copy of PostModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? authorName = null,Object? authorAvatarUrl = null,Object? content = null,Object? mediaThumbUrl = null,Object? mediaMobileUrl = null,Object? mediaRawUrl = freezed,Object? likeCount = null,Object? isLiked = null,Object? createdAt = freezed,}) {
  return _then(_PostModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,authorName: null == authorName ? _self.authorName : authorName // ignore: cast_nullable_to_non_nullable
as String,authorAvatarUrl: null == authorAvatarUrl ? _self.authorAvatarUrl : authorAvatarUrl // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,mediaThumbUrl: null == mediaThumbUrl ? _self.mediaThumbUrl : mediaThumbUrl // ignore: cast_nullable_to_non_nullable
as String,mediaMobileUrl: null == mediaMobileUrl ? _self.mediaMobileUrl : mediaMobileUrl // ignore: cast_nullable_to_non_nullable
as String,mediaRawUrl: freezed == mediaRawUrl ? _self.mediaRawUrl : mediaRawUrl // ignore: cast_nullable_to_non_nullable
as String?,likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int,isLiked: null == isLiked ? _self.isLiked : isLiked // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
