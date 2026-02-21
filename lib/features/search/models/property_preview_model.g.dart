// lib/features/search/models/property_preview_model.g.dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property_preview_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PropertyPreviewModelAdapter extends TypeAdapter<PropertyPreviewModel> {
  @override
  final int typeId = 3;

  @override
  PropertyPreviewModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PropertyPreviewModel(
      id: fields[0] as String,
      title: fields[1] as String,
      price: fields[2] as double,
      isRental: fields[3] as bool,
      address: fields[4] as String,
      city: fields[5] as String,
      imageUrl: fields[6] as String,
      bedrooms: fields[7] as int,
      bathrooms: fields[8] as int,
      propertyType: fields[9] as String,
      viewedAt: fields[10] as DateTime,
      previousPrice: fields[11] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, PropertyPreviewModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.isRental)
      ..writeByte(4)
      ..write(obj.address)
      ..writeByte(5)
      ..write(obj.city)
      ..writeByte(6)
      ..write(obj.imageUrl)
      ..writeByte(7)
      ..write(obj.bedrooms)
      ..writeByte(8)
      ..write(obj.bathrooms)
      ..writeByte(9)
      ..write(obj.propertyType)
      ..writeByte(10)
      ..write(obj.viewedAt)
      ..writeByte(11)
      ..write(obj.previousPrice);
  }
}
