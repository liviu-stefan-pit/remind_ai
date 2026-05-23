// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dream_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DreamEntry {

 String get id; String get dreamText; DreamStyle get style; DateTime get createdAt; String? get interpretationText; bool get isSynced;
/// Create a copy of DreamEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DreamEntryCopyWith<DreamEntry> get copyWith => _$DreamEntryCopyWithImpl<DreamEntry>(this as DreamEntry, _$identity);

  /// Serializes this DreamEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DreamEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.dreamText, dreamText) || other.dreamText == dreamText)&&(identical(other.style, style) || other.style == style)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.interpretationText, interpretationText) || other.interpretationText == interpretationText)&&(identical(other.isSynced, isSynced) || other.isSynced == isSynced));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,dreamText,style,createdAt,interpretationText,isSynced);

@override
String toString() {
  return 'DreamEntry(id: $id, dreamText: $dreamText, style: $style, createdAt: $createdAt, interpretationText: $interpretationText, isSynced: $isSynced)';
}


}

/// @nodoc
abstract mixin class $DreamEntryCopyWith<$Res>  {
  factory $DreamEntryCopyWith(DreamEntry value, $Res Function(DreamEntry) _then) = _$DreamEntryCopyWithImpl;
@useResult
$Res call({
 String id, String dreamText, DreamStyle style, DateTime createdAt, String? interpretationText, bool isSynced
});




}
/// @nodoc
class _$DreamEntryCopyWithImpl<$Res>
    implements $DreamEntryCopyWith<$Res> {
  _$DreamEntryCopyWithImpl(this._self, this._then);

  final DreamEntry _self;
  final $Res Function(DreamEntry) _then;

/// Create a copy of DreamEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? dreamText = null,Object? style = null,Object? createdAt = null,Object? interpretationText = freezed,Object? isSynced = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,dreamText: null == dreamText ? _self.dreamText : dreamText // ignore: cast_nullable_to_non_nullable
as String,style: null == style ? _self.style : style // ignore: cast_nullable_to_non_nullable
as DreamStyle,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,interpretationText: freezed == interpretationText ? _self.interpretationText : interpretationText // ignore: cast_nullable_to_non_nullable
as String?,isSynced: null == isSynced ? _self.isSynced : isSynced // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DreamEntry].
extension DreamEntryPatterns on DreamEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DreamEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DreamEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DreamEntry value)  $default,){
final _that = this;
switch (_that) {
case _DreamEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DreamEntry value)?  $default,){
final _that = this;
switch (_that) {
case _DreamEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String dreamText,  DreamStyle style,  DateTime createdAt,  String? interpretationText,  bool isSynced)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DreamEntry() when $default != null:
return $default(_that.id,_that.dreamText,_that.style,_that.createdAt,_that.interpretationText,_that.isSynced);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String dreamText,  DreamStyle style,  DateTime createdAt,  String? interpretationText,  bool isSynced)  $default,) {final _that = this;
switch (_that) {
case _DreamEntry():
return $default(_that.id,_that.dreamText,_that.style,_that.createdAt,_that.interpretationText,_that.isSynced);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String dreamText,  DreamStyle style,  DateTime createdAt,  String? interpretationText,  bool isSynced)?  $default,) {final _that = this;
switch (_that) {
case _DreamEntry() when $default != null:
return $default(_that.id,_that.dreamText,_that.style,_that.createdAt,_that.interpretationText,_that.isSynced);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DreamEntry implements DreamEntry {
  const _DreamEntry({required this.id, required this.dreamText, required this.style, required this.createdAt, this.interpretationText, this.isSynced = false});
  factory _DreamEntry.fromJson(Map<String, dynamic> json) => _$DreamEntryFromJson(json);

@override final  String id;
@override final  String dreamText;
@override final  DreamStyle style;
@override final  DateTime createdAt;
@override final  String? interpretationText;
@override@JsonKey() final  bool isSynced;

/// Create a copy of DreamEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DreamEntryCopyWith<_DreamEntry> get copyWith => __$DreamEntryCopyWithImpl<_DreamEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DreamEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DreamEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.dreamText, dreamText) || other.dreamText == dreamText)&&(identical(other.style, style) || other.style == style)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.interpretationText, interpretationText) || other.interpretationText == interpretationText)&&(identical(other.isSynced, isSynced) || other.isSynced == isSynced));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,dreamText,style,createdAt,interpretationText,isSynced);

@override
String toString() {
  return 'DreamEntry(id: $id, dreamText: $dreamText, style: $style, createdAt: $createdAt, interpretationText: $interpretationText, isSynced: $isSynced)';
}


}

/// @nodoc
abstract mixin class _$DreamEntryCopyWith<$Res> implements $DreamEntryCopyWith<$Res> {
  factory _$DreamEntryCopyWith(_DreamEntry value, $Res Function(_DreamEntry) _then) = __$DreamEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, String dreamText, DreamStyle style, DateTime createdAt, String? interpretationText, bool isSynced
});




}
/// @nodoc
class __$DreamEntryCopyWithImpl<$Res>
    implements _$DreamEntryCopyWith<$Res> {
  __$DreamEntryCopyWithImpl(this._self, this._then);

  final _DreamEntry _self;
  final $Res Function(_DreamEntry) _then;

/// Create a copy of DreamEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? dreamText = null,Object? style = null,Object? createdAt = null,Object? interpretationText = freezed,Object? isSynced = null,}) {
  return _then(_DreamEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,dreamText: null == dreamText ? _self.dreamText : dreamText // ignore: cast_nullable_to_non_nullable
as String,style: null == style ? _self.style : style // ignore: cast_nullable_to_non_nullable
as DreamStyle,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,interpretationText: freezed == interpretationText ? _self.interpretationText : interpretationText // ignore: cast_nullable_to_non_nullable
as String?,isSynced: null == isSynced ? _self.isSynced : isSynced // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
