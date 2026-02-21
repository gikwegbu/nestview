// lib/features/mortgage_calculator/models/mortgage_calculation_model.g.dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mortgage_calculation_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MortgageCalculationModelAdapter
    extends TypeAdapter<MortgageCalculationModel> {
  @override
  final int typeId = 6;

  @override
  MortgageCalculationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MortgageCalculationModel(
      id: fields[0] as String,
      propertyPrice: fields[1] as double,
      deposit: fields[2] as double,
      interestRate: fields[3] as double,
      termYears: fields[4] as int,
      isInterestOnly: fields[5] as bool,
      monthlyPayment: fields[6] as double,
      totalRepayable: fields[7] as double,
      totalInterest: fields[8] as double,
      ltv: fields[9] as double,
      stampDuty: fields[10] as double,
      stampDutyType: fields[11] as String,
      savedAt: fields[12] as DateTime,
      propertyId: fields[13] as String?,
      propertyAddress: fields[14] as String?,
      name: fields[15] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, MortgageCalculationModel obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.propertyPrice)
      ..writeByte(2)
      ..write(obj.deposit)
      ..writeByte(3)
      ..write(obj.interestRate)
      ..writeByte(4)
      ..write(obj.termYears)
      ..writeByte(5)
      ..write(obj.isInterestOnly)
      ..writeByte(6)
      ..write(obj.monthlyPayment)
      ..writeByte(7)
      ..write(obj.totalRepayable)
      ..writeByte(8)
      ..write(obj.totalInterest)
      ..writeByte(9)
      ..write(obj.ltv)
      ..writeByte(10)
      ..write(obj.stampDuty)
      ..writeByte(11)
      ..write(obj.stampDutyType)
      ..writeByte(12)
      ..write(obj.savedAt)
      ..writeByte(13)
      ..write(obj.propertyId)
      ..writeByte(14)
      ..write(obj.propertyAddress)
      ..writeByte(15)
      ..write(obj.name);
  }
}
