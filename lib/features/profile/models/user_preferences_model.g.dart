// lib/features/profile/models/user_preferences_model.g.dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_preferences_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserPreferencesModelAdapter extends TypeAdapter<UserPreferencesModel> {
  @override
  final int typeId = 7;

  @override
  UserPreferencesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserPreferencesModel(
      maxBudget: fields[0] as double,
      minBudget: fields[1] as double,
      preferredAreas: (fields[2] as List).cast<String>(),
      preferredPropertyTypes: (fields[3] as List).cast<String>(),
      minBedrooms: fields[4] as int,
      preferredListingType: fields[5] as String,
      priceDropAlerts: fields[6] as bool,
      newListingAlerts: fields[7] as bool,
      savedSearchAlerts: fields[8] as bool,
      name: fields[9] as String?,
      email: fields[10] as String?,
      isFirstTimeBuyer: fields[11] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, UserPreferencesModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.maxBudget)
      ..writeByte(1)
      ..write(obj.minBudget)
      ..writeByte(2)
      ..write(obj.preferredAreas)
      ..writeByte(3)
      ..write(obj.preferredPropertyTypes)
      ..writeByte(4)
      ..write(obj.minBedrooms)
      ..writeByte(5)
      ..write(obj.preferredListingType)
      ..writeByte(6)
      ..write(obj.priceDropAlerts)
      ..writeByte(7)
      ..write(obj.newListingAlerts)
      ..writeByte(8)
      ..write(obj.savedSearchAlerts)
      ..writeByte(9)
      ..write(obj.name)
      ..writeByte(10)
      ..write(obj.email)
      ..writeByte(11)
      ..write(obj.isFirstTimeBuyer);
  }
}
