// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dream_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DreamEntry _$DreamEntryFromJson(Map<String, dynamic> json) => _DreamEntry(
  id: json['id'] as String,
  dreamText: json['dreamText'] as String,
  style: $enumDecode(_$DreamStyleEnumMap, json['style']),
  createdAt: DateTime.parse(json['createdAt'] as String),
  interpretationText: json['interpretationText'] as String?,
  isSynced: json['isSynced'] as bool? ?? false,
);

Map<String, dynamic> _$DreamEntryToJson(_DreamEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dreamText': instance.dreamText,
      'style': _$DreamStyleEnumMap[instance.style]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'interpretationText': instance.interpretationText,
      'isSynced': instance.isSynced,
    };

const _$DreamStyleEnumMap = {
  DreamStyle.standard: 'standard',
  DreamStyle.psychological: 'psychological',
  DreamStyle.mythic: 'mythic',
  DreamStyle.creative: 'creative',
};
