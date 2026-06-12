// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'access_tier_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AccessTierState {

 AccessTier get tier;// For subscriptions: when the current Pro entitlement lapses. Null for
// free users (and treated as no known expiry).
 DateTime? get expiry;
/// Create a copy of AccessTierState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccessTierStateCopyWith<AccessTierState> get copyWith => _$AccessTierStateCopyWithImpl<AccessTierState>(this as AccessTierState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccessTierState&&(identical(other.tier, tier) || other.tier == tier)&&(identical(other.expiry, expiry) || other.expiry == expiry));
}


@override
int get hashCode => Object.hash(runtimeType,tier,expiry);

@override
String toString() {
  return 'AccessTierState(tier: $tier, expiry: $expiry)';
}


}

/// @nodoc
abstract mixin class $AccessTierStateCopyWith<$Res>  {
  factory $AccessTierStateCopyWith(AccessTierState value, $Res Function(AccessTierState) _then) = _$AccessTierStateCopyWithImpl;
@useResult
$Res call({
 AccessTier tier, DateTime? expiry
});




}
/// @nodoc
class _$AccessTierStateCopyWithImpl<$Res>
    implements $AccessTierStateCopyWith<$Res> {
  _$AccessTierStateCopyWithImpl(this._self, this._then);

  final AccessTierState _self;
  final $Res Function(AccessTierState) _then;

/// Create a copy of AccessTierState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tier = null,Object? expiry = freezed,}) {
  return _then(_self.copyWith(
tier: null == tier ? _self.tier : tier // ignore: cast_nullable_to_non_nullable
as AccessTier,expiry: freezed == expiry ? _self.expiry : expiry // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [AccessTierState].
extension AccessTierStatePatterns on AccessTierState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AccessTierState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AccessTierState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AccessTierState value)  $default,){
final _that = this;
switch (_that) {
case _AccessTierState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AccessTierState value)?  $default,){
final _that = this;
switch (_that) {
case _AccessTierState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AccessTier tier,  DateTime? expiry)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AccessTierState() when $default != null:
return $default(_that.tier,_that.expiry);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AccessTier tier,  DateTime? expiry)  $default,) {final _that = this;
switch (_that) {
case _AccessTierState():
return $default(_that.tier,_that.expiry);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AccessTier tier,  DateTime? expiry)?  $default,) {final _that = this;
switch (_that) {
case _AccessTierState() when $default != null:
return $default(_that.tier,_that.expiry);case _:
  return null;

}
}

}

/// @nodoc


class _AccessTierState implements AccessTierState {
  const _AccessTierState({this.tier = AccessTier.free, this.expiry});
  

@override@JsonKey() final  AccessTier tier;
// For subscriptions: when the current Pro entitlement lapses. Null for
// free users (and treated as no known expiry).
@override final  DateTime? expiry;

/// Create a copy of AccessTierState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccessTierStateCopyWith<_AccessTierState> get copyWith => __$AccessTierStateCopyWithImpl<_AccessTierState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccessTierState&&(identical(other.tier, tier) || other.tier == tier)&&(identical(other.expiry, expiry) || other.expiry == expiry));
}


@override
int get hashCode => Object.hash(runtimeType,tier,expiry);

@override
String toString() {
  return 'AccessTierState(tier: $tier, expiry: $expiry)';
}


}

/// @nodoc
abstract mixin class _$AccessTierStateCopyWith<$Res> implements $AccessTierStateCopyWith<$Res> {
  factory _$AccessTierStateCopyWith(_AccessTierState value, $Res Function(_AccessTierState) _then) = __$AccessTierStateCopyWithImpl;
@override @useResult
$Res call({
 AccessTier tier, DateTime? expiry
});




}
/// @nodoc
class __$AccessTierStateCopyWithImpl<$Res>
    implements _$AccessTierStateCopyWith<$Res> {
  __$AccessTierStateCopyWithImpl(this._self, this._then);

  final _AccessTierState _self;
  final $Res Function(_AccessTierState) _then;

/// Create a copy of AccessTierState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tier = null,Object? expiry = freezed,}) {
  return _then(_AccessTierState(
tier: null == tier ? _self.tier : tier // ignore: cast_nullable_to_non_nullable
as AccessTier,expiry: freezed == expiry ? _self.expiry : expiry // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
