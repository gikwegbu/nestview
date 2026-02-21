// lib/features/search/models/search_filter_model.g.dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_filter_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TransportModeAdapter extends TypeAdapter<TransportMode> {
  @override
  final int typeId = 4;

  @override
  TransportMode read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TransportMode.walking;
      case 1:
        return TransportMode.cycling;
      case 2:
        return TransportMode.driving;
      case 3:
        return TransportMode.transit;
      default:
        return TransportMode.driving;
    }
  }

  @override
  void write(BinaryWriter writer, TransportMode obj) {
    writer.writeByte(obj.index);
  }
}

class SearchFilterModelAdapter extends TypeAdapter<SearchFilterModel> {
  @override
  final int typeId = 5;

  @override
  SearchFilterModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SearchFilterModel(
      id: fields[0] as String,
      query: fields[1] as String?,
      listingType: fields[2] as String,
      minPrice: fields[3] as double,
      maxPrice: fields[4] as double,
      minBedrooms: fields[5] as int?,
      maxBedrooms: fields[6] as int?,
      propertyTypes: (fields[7] as List).cast<String>(),
      mustHaveGarden: fields[8] as bool,
      mustHaveParking: fields[9] as bool,
      newBuildOnly: fields[10] as bool,
      retirementOnly: fields[11] as bool,
      maxCommuteMins: fields[12] as int?,
      transportMode: fields[13] as TransportMode?,
      keywords: fields[14] as String?,
      sortBy: fields[15] as String,
      addedSince: fields[16] as DateTime?,
      savedAt: fields[17] as DateTime?,
      savedName: fields[18] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SearchFilterModel obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.query)
      ..writeByte(2)
      ..write(obj.listingType)
      ..writeByte(3)
      ..write(obj.minPrice)
      ..writeByte(4)
      ..write(obj.maxPrice)
      ..writeByte(5)
      ..write(obj.minBedrooms)
      ..writeByte(6)
      ..write(obj.maxBedrooms)
      ..writeByte(7)
      ..write(obj.propertyTypes)
      ..writeByte(8)
      ..write(obj.mustHaveGarden)
      ..writeByte(9)
      ..write(obj.mustHaveParking)
      ..writeByte(10)
      ..write(obj.newBuildOnly)
      ..writeByte(11)
      ..write(obj.retirementOnly)
      ..writeByte(12)
      ..write(obj.maxCommuteMins)
      ..writeByte(13)
      ..write(obj.transportMode)
      ..writeByte(14)
      ..write(obj.keywords)
      ..writeByte(15)
      ..write(obj.sortBy)
      ..writeByte(16)
      ..write(obj.addedSince)
      ..writeByte(17)
      ..write(obj.savedAt)
      ..writeByte(18)
      ..write(obj.savedName);
  }
}
