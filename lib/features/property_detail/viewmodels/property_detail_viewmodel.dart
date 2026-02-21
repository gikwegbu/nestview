// lib/features/property_detail/viewmodels/property_detail_viewmodel.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../search/models/property_model.dart';
import '../../../core/utils/mock_data.dart';

// ─── Property Detail Provider ─────────────────────────────────────────────────
final propertyDetailProvider =
    AsyncNotifierProviderFamily<PropertyDetailNotifier, PropertyModel, String>(
      PropertyDetailNotifier.new,
    );

class PropertyDetailNotifier
    extends FamilyAsyncNotifier<PropertyModel, String> {
  @override
  Future<PropertyModel> build(String arg) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final property = MockData.getById(arg);
    if (property == null) throw Exception('Property not found');
    return property;
  }
}

// ─── Gallery Image Index Provider ────────────────────────────────────────────
final galleryIndexProvider = StateProvider.family<int, String>((ref, id) => 0);

// ─── Property Tab Provider ────────────────────────────────────────────────────
final propertyTabProvider = StateProvider.family<int, String>((ref, id) => 0);

// ─── Description Expanded Provider ───────────────────────────────────────────
final descriptionExpandedProvider = StateProvider.family<bool, String>(
  (ref, id) => false,
);
