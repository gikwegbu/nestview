// lib/features/search/models/property_model.g.dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PropertyTypeAdapter extends TypeAdapter<PropertyType> {
  @override
  final int typeId = 0;

  @override
  PropertyType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PropertyType.detached;
      case 1:
        return PropertyType.semiDetached;
      case 2:
        return PropertyType.terraced;
      case 3:
        return PropertyType.flat;
      case 4:
        return PropertyType.bungalow;
      case 5:
        return PropertyType.commercial;
      case 6:
        return PropertyType.land;
      default:
        return PropertyType.flat;
    }
  }

  @override
  void write(BinaryWriter writer, PropertyType obj) {
    writer.writeByte(obj.index);
  }
}

class ListingTypeAdapter extends TypeAdapter<ListingType> {
  @override
  final int typeId = 1;

  @override
  ListingType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ListingType.buy;
      case 1:
        return ListingType.rent;
      case 2:
        return ListingType.commercial;
      default:
        return ListingType.buy;
    }
  }

  @override
  void write(BinaryWriter writer, ListingType obj) {
    writer.writeByte(obj.index);
  }
}

class PropertyModelAdapter extends TypeAdapter<PropertyModel> {
  @override
  final int typeId = 2;

  @override
  PropertyModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PropertyModel(
      id: fields[0] as String,
      title: fields[1] as String,
      price: fields[2] as double,
      isRental: fields[3] as bool,
      address: fields[4] as String,
      city: fields[5] as String,
      postcode: fields[6] as String,
      latitude: fields[7] as double,
      longitude: fields[8] as double,
      bedrooms: fields[9] as int,
      bathrooms: fields[10] as int,
      receptions: fields[11] as int,
      squareFeet: fields[12] as double,
      epcRating: fields[13] as String,
      propertyType: fields[14] as PropertyType,
      listingType: fields[15] as ListingType,
      imageUrls: (fields[16] as List).cast<String>(),
      description: fields[17] as String,
      keyFeatures: (fields[18] as List).cast<String>(),
      hasGarden: fields[19] as bool,
      hasParking: fields[20] as bool,
      isNewBuild: fields[21] as bool,
      isRetirement: fields[22] as bool,
      addedDate: fields[23] as DateTime,
      agentName: fields[24] as String,
      agentPhone: fields[25] as String,
      agentEmail: fields[26] as String,
      agentLogo: fields[27] as String,
      isPremiumListing: fields[28] as bool,
      previousPrice: fields[29] as double?,
      floorplanUrl: fields[30] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PropertyModel obj) {
    writer
      ..writeByte(31)
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
      ..write(obj.postcode)
      ..writeByte(7)
      ..write(obj.latitude)
      ..writeByte(8)
      ..write(obj.longitude)
      ..writeByte(9)
      ..write(obj.bedrooms)
      ..writeByte(10)
      ..write(obj.bathrooms)
      ..writeByte(11)
      ..write(obj.receptions)
      ..writeByte(12)
      ..write(obj.squareFeet)
      ..writeByte(13)
      ..write(obj.epcRating)
      ..writeByte(14)
      ..write(obj.propertyType)
      ..writeByte(15)
      ..write(obj.listingType)
      ..writeByte(16)
      ..write(obj.imageUrls)
      ..writeByte(17)
      ..write(obj.description)
      ..writeByte(18)
      ..write(obj.keyFeatures)
      ..writeByte(19)
      ..write(obj.hasGarden)
      ..writeByte(20)
      ..write(obj.hasParking)
      ..writeByte(21)
      ..write(obj.isNewBuild)
      ..writeByte(22)
      ..write(obj.isRetirement)
      ..writeByte(23)
      ..write(obj.addedDate)
      ..writeByte(24)
      ..write(obj.agentName)
      ..writeByte(25)
      ..write(obj.agentPhone)
      ..writeByte(26)
      ..write(obj.agentEmail)
      ..writeByte(27)
      ..write(obj.agentLogo)
      ..writeByte(28)
      ..write(obj.isPremiumListing)
      ..writeByte(29)
      ..write(obj.previousPrice)
      ..writeByte(30)
      ..write(obj.floorplanUrl);
  }
}
