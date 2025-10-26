// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MenuModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MenuModelAdapter extends TypeAdapter<MenuModel> {
  @override
  final int typeId = 1;

  @override
  MenuModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MenuModel()
      ..id = fields[0] as int
      ..itemName = fields[1] as String
      ..itemPrice = fields[2] as int
      ..imagePath = fields[3] as String
      ..mealType = fields[4] as String;
  }

  @override
  void write(BinaryWriter writer, MenuModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.itemName)
      ..writeByte(2)
      ..write(obj.itemPrice)
      ..writeByte(3)
      ..write(obj.imagePath)
      ..writeByte(4)
      ..write(obj.mealType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MenuModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
