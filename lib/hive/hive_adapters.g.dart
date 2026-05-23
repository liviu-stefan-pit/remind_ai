// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_adapters.dart';

// **************************************************************************
// AdaptersGenerator
// **************************************************************************

class ThemeUiModelAdapter extends TypeAdapter<ThemeUiModel> {
  @override
  final typeId = 0;

  @override
  ThemeUiModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ThemeUiModel(
      themeMode: fields[0] == null ? ThemeMode.system : fields[0] as ThemeMode,
    );
  }

  @override
  void write(BinaryWriter writer, ThemeUiModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.themeMode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemeUiModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DreamEntryAdapter extends TypeAdapter<DreamEntry> {
  @override
  final typeId = 1;

  @override
  DreamEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DreamEntry(
      id: fields[0] as String,
      dreamText: fields[1] as String,
      style: fields[2] as DreamStyle,
      createdAt: fields[3] as DateTime,
      interpretationText: fields[4] as String?,
      isSynced: fields[5] == null ? false : fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, DreamEntry obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.dreamText)
      ..writeByte(2)
      ..write(obj.style)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.interpretationText)
      ..writeByte(5)
      ..write(obj.isSynced);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DreamEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DreamStyleAdapter extends TypeAdapter<DreamStyle> {
  @override
  final typeId = 2;

  @override
  DreamStyle read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DreamStyle.standard;
      case 1:
        return DreamStyle.psychological;
      case 2:
        return DreamStyle.mythic;
      case 3:
        return DreamStyle.creative;
      default:
        return DreamStyle.standard;
    }
  }

  @override
  void write(BinaryWriter writer, DreamStyle obj) {
    switch (obj) {
      case DreamStyle.standard:
        writer.writeByte(0);
      case DreamStyle.psychological:
        writer.writeByte(1);
      case DreamStyle.mythic:
        writer.writeByte(2);
      case DreamStyle.creative:
        writer.writeByte(3);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DreamStyleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
