// lib/core/utils/mock_data.dart
import '../../features/search/models/property_model.dart';
import '../../features/search/models/property_preview_model.dart';

class MockData {
  MockData._();

  static final List<PropertyModel> properties = [
    PropertyModel(
      id: 'prop_001',
      title: '4 Bedroom Detached House',
      price: 485000,
      isRental: false,
      address: '12 Kensington Grove',
      city: 'London',
      postcode: 'W8 4PT',
      latitude: 51.5014,
      longitude: -0.1870,
      bedrooms: 4,
      bathrooms: 3,
      receptions: 2,
      squareFeet: 2100,
      epcRating: 'B',
      propertyType: PropertyType.detached,
      listingType: ListingType.buy,
      imageUrls: [
        'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=800',
        'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=800',
        'https://images.unsplash.com/photo-1600047509807-ba8f99d2cdde?w=800',
        'https://images.unsplash.com/photo-1583608205776-bfd35f0d9f83?w=800',
      ],
      description:
          'Beautifully presented four bedroom detached family home situated in the highly sought-after Kensington area of London. This exceptional property offers generous living space arranged over three floors, featuring a stunning open-plan kitchen and dining room, a separate reception room, and a delightful south-facing garden.\n\nThe accommodation includes a principal bedroom with en-suite, three further double bedrooms, and two additional bathrooms. The property has been lovingly maintained and benefits from a recent modern kitchen installation with integrated appliances.',
      keyFeatures: [
        'Four double bedrooms',
        'South-facing garden',
        'Open plan kitchen/dining room',
        'Principal bedroom with en-suite',
        'Recently modernised throughout',
        'Close to excellent schools',
        'Off-street parking for 2 cars',
        'EPC Rating B',
      ],
      hasGarden: true,
      hasParking: true,
      isNewBuild: false,
      isRetirement: false,
      addedDate: DateTime.now().subtract(const Duration(days: 3)),
      agentName: 'Knight Frank London',
      agentPhone: '+44 20 7629 8171',
      agentEmail: 'london@knightfrank.com',
      agentLogo:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e2/Knight_Frank_logo.svg/200px-Knight_Frank_logo.svg.png',
      isPremiumListing: true,
      previousPrice: 510000,
    ),
    PropertyModel(
      id: 'prop_002',
      title: 'Modern 2 Bed Apartment',
      price: 285000,
      isRental: false,
      address: '45 Northern Quarter',
      city: 'Manchester',
      postcode: 'M4 3LP',
      latitude: 53.4831,
      longitude: -2.2352,
      bedrooms: 2,
      bathrooms: 2,
      receptions: 1,
      squareFeet: 950,
      epcRating: 'B',
      propertyType: PropertyType.flat,
      listingType: ListingType.buy,
      imageUrls: [
        'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800',
        'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800',
        'https://images.unsplash.com/photo-1616137422495-1e9e46e2aa77?w=800',
      ],
      description:
          'Stunning modern two bedroom apartment in the heart of Manchester\'s vibrant Northern Quarter. This contemporary property offers stylish open-plan living with floor-to-ceiling windows, a sleek fitted kitchen with quartz worktops, and two well-proportioned bedrooms — the principal featuring a luxury en-suite shower room.\n\nLocated steps from the best restaurants, bars, and cultural venues Manchester has to offer, with excellent transport links to the city centre and beyond.',
      keyFeatures: [
        'Two double bedrooms',
        'Principal with en-suite',
        'Open plan kitchen/living',
        'Floor to ceiling windows',
        'Allocated underground parking',
        'Concierge service',
        'Residents\' gym and roof terrace',
        'Zone 1 city centre location',
      ],
      hasGarden: false,
      hasParking: true,
      isNewBuild: true,
      isRetirement: false,
      addedDate: DateTime.now().subtract(const Duration(days: 1)),
      agentName: 'Savills Manchester',
      agentPhone: '+44 161 244 7700',
      agentEmail: 'manchester@savills.com',
      agentLogo:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5f/Savills_logo.svg/200px-Savills_logo.svg.png',
      isPremiumListing: false,
    ),
    PropertyModel(
      id: 'prop_003',
      title: '3 Bed Semi-Detached House',
      price: 320000,
      isRental: false,
      address: '78 Edgbaston Road',
      city: 'Birmingham',
      postcode: 'B15 2PT',
      latitude: 52.4682,
      longitude: -1.9122,
      bedrooms: 3,
      bathrooms: 2,
      receptions: 2,
      squareFeet: 1450,
      epcRating: 'C',
      propertyType: PropertyType.semiDetached,
      listingType: ListingType.buy,
      imageUrls: [
        'https://images.unsplash.com/photo-1568605114967-8130f3a36994?w=800',
        'https://images.unsplash.com/photo-1580587771525-78b9dba3b914?w=800',
        'https://images.unsplash.com/photo-1572120360610-d971b9d7767c?w=800',
      ],
      description:
          'Charming three bedroom semi-detached family home set on a popular residential road in Edgbaston, one of Birmingham\'s most desirable suburbs. The property benefits from a good-sized rear garden, a driveway providing parking for multiple vehicles, and is within the catchment area for several outstanding schools.',
      keyFeatures: [
        'Three bedrooms',
        'Large private rear garden',
        'Driveway with space for 3 cars',
        'Good school catchment area',
        'Quiet residential road',
        'Light and airy family bathroom',
        'Separate living and dining rooms',
        'Close to Edgbaston Reservoir',
      ],
      hasGarden: true,
      hasParking: true,
      isNewBuild: false,
      isRetirement: false,
      addedDate: DateTime.now().subtract(const Duration(days: 7)),
      agentName: 'Connells Birmingham',
      agentPhone: '+44 121 455 0099',
      agentEmail: 'birmingham@connells.co.uk',
      agentLogo:
          'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=100',
      isPremiumListing: false,
    ),
    PropertyModel(
      id: 'prop_004',
      title: 'Luxury Penthouse Flat',
      price: 850000,
      isRental: false,
      address: '1 Royal Mile',
      city: 'Edinburgh',
      postcode: 'EH1 1SR',
      latitude: 55.9496,
      longitude: -3.1966,
      bedrooms: 3,
      bathrooms: 3,
      receptions: 1,
      squareFeet: 2800,
      epcRating: 'A',
      propertyType: PropertyType.flat,
      listingType: ListingType.buy,
      imageUrls: [
        'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=800',
        'https://images.unsplash.com/photo-1484154218962-a197022b5858?w=800',
        'https://images.unsplash.com/photo-1556912172-45b7abe8b7e1?w=800',
      ],
      description:
          'An extraordinary penthouse apartment occupying the entire top floor of this prestigious conversion, offering panoramic views across Edinburgh\'s iconic skyline including Edinburgh Castle. The property is finished to an exemplary standard throughout with bespoke joinery, underfloor heating, and a private roof terrace.\n\nThis is a rare opportunity to acquire one of Edinburgh\'s finest addresses, with the city\'s best restaurants, galleries, and cultural treasures on the doorstep.',
      keyFeatures: [
        'Panoramic castle views',
        'Private roof terrace',
        'Underfloor heating throughout',
        'Bespoke fitted kitchen',
        'Three luxury en-suite bedrooms',
        'Secure underground parking',
        'Concierge and porter service',
        'Listed building with historic character',
      ],
      hasGarden: false,
      hasParking: true,
      isNewBuild: false,
      isRetirement: false,
      addedDate: DateTime.now().subtract(const Duration(days: 14)),
      agentName: 'Strutt & Parker Edinburgh',
      agentPhone: '+44 131 226 2500',
      agentEmail: 'edinburgh@struttandparker.com',
      agentLogo:
          'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=100',
      isPremiumListing: true,
    ),
    PropertyModel(
      id: 'prop_005',
      title: 'Cosy 1 Bed in Clifton',
      price: 1800,
      isRental: true,
      address: '23 Clifton Down',
      city: 'Bristol',
      postcode: 'BS8 3JE',
      latitude: 51.4584,
      longitude: -2.6124,
      bedrooms: 1,
      bathrooms: 1,
      receptions: 1,
      squareFeet: 620,
      epcRating: 'C',
      propertyType: PropertyType.flat,
      listingType: ListingType.rent,
      imageUrls: [
        'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800',
        'https://images.unsplash.com/photo-1493809842364-78817add7ffb?w=800',
      ],
      description:
          'Delightful one bedroom apartment in the prestigious Clifton Down area of Bristol. The property is presented in excellent condition throughout, featuring a well-equipped kitchen, a bright and airy living room with high ceilings, and a generous double bedroom with built-in wardrobes.',
      keyFeatures: [
        'One double bedroom',
        'Victorian conversion with high ceilings',
        'Fully furnished option available',
        'Close to Clifton village shops',
        'Excellent transport links',
        'Permit parking zone',
        'Available immediately',
        'No smoking, pets considered',
      ],
      hasGarden: false,
      hasParking: false,
      isNewBuild: false,
      isRetirement: false,
      addedDate: DateTime.now().subtract(const Duration(days: 2)),
      agentName: 'Martin & Co Bristol',
      agentPhone: '+44 117 901 6188',
      agentEmail: 'bristol@martinco.com',
      agentLogo:
          'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=100',
      isPremiumListing: false,
    ),
    PropertyModel(
      id: 'prop_006',
      title: '5 Bedroom Detached with Pool',
      price: 1250000,
      isRental: false,
      address: '45 Harrogate Road',
      city: 'Leeds',
      postcode: 'LS17 6LB',
      latitude: 53.8225,
      longitude: -1.5407,
      bedrooms: 5,
      bathrooms: 4,
      receptions: 3,
      squareFeet: 4200,
      epcRating: 'B',
      propertyType: PropertyType.detached,
      listingType: ListingType.buy,
      imageUrls: [
        'https://images.unsplash.com/photo-1613977257363-707ba9348227?w=800',
        'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?w=800',
        'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800',
        'https://images.unsplash.com/photo-1570129477492-45c003edd2be?w=800',
      ],
      description:
          'An exceptional five bedroom detached family residence situated in a premier position in the highly desirable north Leeds suburb. Set in generous private grounds of approximately 0.75 acres, the property features an outdoor heated swimming pool, a triple garage, and an orangery.',
      keyFeatures: [
        'Five double bedrooms',
        'Heated outdoor swimming pool',
        'Triple garage plus workshop',
        'Orangery and games room',
        'South-facing garden (0.75 acres)',
        'Smart home automation',
        'Principal suite with dressing room',
        'Chef\'s kitchen with larder',
      ],
      hasGarden: true,
      hasParking: true,
      isNewBuild: false,
      isRetirement: false,
      addedDate: DateTime.now().subtract(const Duration(days: 5)),
      agentName: 'Dacre Son & Hartley Leeds',
      agentPhone: '+44 113 243 6171',
      agentEmail: 'leeds@dacres.co.uk',
      agentLogo:
          'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=100',
      isPremiumListing: true,
      previousPrice: 1350000,
    ),
    PropertyModel(
      id: 'prop_007',
      title: 'Terraced House in Anfield',
      price: 145000,
      isRental: false,
      address: '89 Breck Road',
      city: 'Liverpool',
      postcode: 'L4 4AP',
      latitude: 53.4341,
      longitude: -2.9601,
      bedrooms: 3,
      bathrooms: 1,
      receptions: 2,
      squareFeet: 1050,
      epcRating: 'D',
      propertyType: PropertyType.terraced,
      listingType: ListingType.buy,
      imageUrls: [
        'https://images.unsplash.com/photo-1577495508048-b635879837f1?w=800',
        'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=800',
      ],
      description:
          'Well-presented three bedroom mid-terrace house in the popular Anfield area of Liverpool. The property offers excellent value for first-time buyers or investors, featuring a through lounge, a fitted kitchen, and a rear yard. Planning permission has been granted for a single storey extension.',
      keyFeatures: [
        'Three bedrooms',
        'Through lounge',
        'Fitted kitchen with appliances',
        'Rear courtyard garden',
        'Approved planning for extension',
        'Close to Liverpool FC',
        'Good transport links',
        'Ideal for first-time buyers',
      ],
      hasGarden: false,
      hasParking: false,
      isNewBuild: false,
      isRetirement: false,
      addedDate: DateTime.now().subtract(const Duration(days: 10)),
      agentName: 'Entwistle Green Liverpool',
      agentPhone: '+44 151 260 5553',
      agentEmail: 'liverpool@entwistlegreen.co.uk',
      agentLogo:
          'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=100',
      isPremiumListing: false,
    ),
    PropertyModel(
      id: 'prop_008',
      title: 'New Build 3 Bed in Cardiff Bay',
      price: 360000,
      isRental: false,
      address: '8 Marina View',
      city: 'Cardiff',
      postcode: 'CF10 4PW',
      latitude: 51.4664,
      longitude: -3.1668,
      bedrooms: 3,
      bathrooms: 2,
      receptions: 1,
      squareFeet: 1380,
      epcRating: 'A',
      propertyType: PropertyType.terraced,
      listingType: ListingType.buy,
      imageUrls: [
        'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?w=800',
        'https://images.unsplash.com/photo-1600566753086-00f18fb6b3ea?w=800',
      ],
      description:
          'Stunning new build three bedroom home in the vibrant Cardiff Bay development, offering contemporary living with stunning water views. The property features an open plan kitchen/dining/living area with full-height glazed doors to a private terrace, and energy-efficient fixtures throughout.',
      keyFeatures: [
        'New build with 10-year warranty',
        'Water views from terrace',
        'Open plan living space',
        'Solar panels and EV charge point',
        'EPC Rating A',
        'Cardiff Bay waterfront location',
        'South-facing private terrace',
        'Allocated parking x2',
      ],
      hasGarden: false,
      hasParking: true,
      isNewBuild: true,
      isRetirement: false,
      addedDate: DateTime.now().subtract(const Duration(hours: 6)),
      agentName: 'Hern & Crabtree Cardiff',
      agentPhone: '+44 29 2064 4000',
      agentEmail: 'cardiff@hern-crabtree.co.uk',
      agentLogo:
          'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=100',
      isPremiumListing: false,
    ),
  ];

  static List<PropertyPreviewModel> get recentlyViewedSamples => properties
      .take(4)
      .map(
        (p) => PropertyPreviewModel(
          id: p.id,
          title: p.title,
          price: p.price,
          isRental: p.isRental,
          address: p.address,
          city: p.city,
          imageUrl: p.imageUrls.first,
          bedrooms: p.bedrooms,
          bathrooms: p.bathrooms,
          propertyType: p.propertyTypeLabel,
          viewedAt: DateTime.now().subtract(
            Duration(hours: properties.indexOf(p) * 3 + 1),
          ),
          previousPrice: p.previousPrice,
        ),
      )
      .toList();

  static PropertyModel? getById(String id) {
    try {
      return properties.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  static List<PropertyModel> search({
    String? query,
    String listingType = 'buy',
    double minPrice = 0,
    double maxPrice = 10000000,
    int? minBedrooms,
    List<String>? propertyTypes,
  }) {
    return properties.where((p) {
      final matchesQuery =
          query == null ||
          query.isEmpty ||
          p.city.toLowerCase().contains(query.toLowerCase()) ||
          p.postcode.toLowerCase().contains(query.toLowerCase()) ||
          p.address.toLowerCase().contains(query.toLowerCase()) ||
          p.title.toLowerCase().contains(query.toLowerCase());

      final matchesType =
          listingType == 'all' || p.listingType.name == listingType;

      final matchesPrice = p.price >= minPrice && p.price <= maxPrice;

      final matchesBeds = minBedrooms == null || p.bedrooms >= minBedrooms;

      return matchesQuery && matchesType && matchesPrice && matchesBeds;
    }).toList();
  }
}
