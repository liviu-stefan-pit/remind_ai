import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:remind_ai/features/dreams/domain/dream_style.dart';

part 'dream_entry.freezed.dart';
part 'dream_entry.g.dart';

@freezed
abstract class DreamEntry with _$DreamEntry {
  const factory DreamEntry({
    required String id,
    required String dreamText,
    required DreamStyle style,
    required DateTime createdAt,
    String? interpretationText,
    @Default(false) bool isSynced,
  }) = _DreamEntry;

  factory DreamEntry.fromJson(Map<String, dynamic> json) =>
      _$DreamEntryFromJson(json);
}
