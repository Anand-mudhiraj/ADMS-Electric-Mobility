import '../models/scooter.dart';

/// ⚠ DEMO DATA — clearly labelled, not real ADMS product specifications.
/// Replace with real client-provided specifications before production release.
class DemoData {
  static final List<Scooter> scooters = [
    Scooter(
      id: 'demo-001',
      slug: 'adms-gtr',
      modelName: 'ADMS GTR',
      modelCode: 'GTR-001',
      shortDescription: 'City Power. Everyday Ride.',
      description:
          '[DEMO] The ADMS GTR is designed for high-performance daily urban commuting with advanced regenerative braking and ultra-low maintenance.',
      category: 'City Ride',
      priceOnRequest: true,
      status: ScooterStatus.published,
      thumbnailUrl: 'assets/images/adms_gtr.jpg',
      galleryUrls: [
        'assets/images/adms_gtr.jpg',
        'assets/images/showroom_hero.jpg',
      ],
      modelUrl3d: 'assets/3d/sample_scooter.glb',
      specs: const ScooterSpecs(
        rangeKm: '80',
        topSpeedKmh: '45',
        batteryType: 'Lithium-Ion',
        batteryVoltage: '60',
        batteryCapacityAh: '26',
        motorPowerW: '2500',
        chargingTimeHours: '3',
        loadCapacityKg: '180',
      ),
      colours: const [
        ScooterColour(
            id: 'c-001', name: 'Pearl White', colorHex: 0xFFF5F5F5),
        ScooterColour(
            id: 'c-002', name: 'Matte Black', colorHex: 0xFF1A1A1A),
        ScooterColour(
            id: 'c-003', name: 'Metallic Red', colorHex: 0xFFB22222),
      ],
    ),
    Scooter(
      id: 'demo-002',
      slug: 'adms-dx4',
      modelName: 'ADMS DX4',
      modelCode: 'DX4-001',
      shortDescription: 'Urban Comfort & Efficiency.',
      description:
          '[DEMO] The ADMS DX4 targets comfortable urban travel with high-torque hub motor, ergonomic step-through design and dual suspension.',
      category: 'City Ride',
      priceOnRequest: true,
      status: ScooterStatus.published,
      thumbnailUrl: 'assets/images/adms_dx4.jpg',
      galleryUrls: [
        'assets/images/adms_dx4.jpg',
      ],
      modelUrl3d: 'assets/3d/sample_scooter.glb',
      specs: const ScooterSpecs(
        rangeKm: '95',
        topSpeedKmh: '55',
        batteryType: 'Lithium-Ion NMC',
        batteryVoltage: '72',
        batteryCapacityAh: '32',
        motorPowerW: '3000',
        chargingTimeHours: '3.5',
        loadCapacityKg: '190',
      ),
      colours: const [
        ScooterColour(id: 'c-004', name: 'Electric Blue', colorHex: 0xFF1565C0),
        ScooterColour(id: 'c-005', name: 'Gunmetal Grey', colorHex: 0xFF607D8B),
      ],
    ),
    Scooter(
      id: 'demo-003',
      slug: 'adms-rx1',
      modelName: 'ADMS RX1',
      modelCode: 'RX1-001',
      shortDescription: 'Performance & Sport Styling.',
      description:
          '[DEMO] The ADMS RX1 is the aggressive performance flagship, engineered for fast acceleration, sport tuned suspension and dynamic handling.',
      category: 'Performance',
      priceOnRequest: true,
      status: ScooterStatus.published,
      thumbnailUrl: 'assets/images/adms_rx1.jpg',
      galleryUrls: [
        'assets/images/adms_rx1.jpg',
      ],
      modelUrl3d: 'assets/3d/sample_scooter.glb',
      specs: const ScooterSpecs(
        rangeKm: '120',
        topSpeedKmh: '75',
        batteryType: 'Advanced Li-Ion',
        batteryVoltage: '72',
        batteryCapacityAh: '40',
        motorPowerW: '4000',
        chargingTimeHours: '4',
        loadCapacityKg: '200',
      ),
      colours: const [
        ScooterColour(id: 'c-006', name: 'Crimson Red', colorHex: 0xFFB22222),
        ScooterColour(id: 'c-007', name: 'Carbon Black', colorHex: 0xFF1A1A1A),
      ],
    ),
    Scooter(
      id: 'demo-004',
      slug: 'adms-lx',
      modelName: 'ADMS LX',
      modelCode: 'LX-001',
      shortDescription: 'Luxury Executive Touring.',
      description:
          '[DEMO] The ADMS LX is a luxury touring scooter with maximum range, contoured leather seating, and premium connectivity.',
      category: 'High Range',
      priceOnRequest: true,
      status: ScooterStatus.published,
      thumbnailUrl: 'assets/images/adms_lx.jpg',
      galleryUrls: [
        'assets/images/adms_lx.jpg',
      ],
      modelUrl3d: 'assets/3d/sample_scooter.glb',
      specs: const ScooterSpecs(
        rangeKm: '150',
        topSpeedKmh: '65',
        batteryType: 'High-Density Li-Ion',
        batteryVoltage: '72',
        batteryCapacityAh: '45',
        motorPowerW: '3500',
        chargingTimeHours: '4.5',
        loadCapacityKg: '210',
      ),
      colours: const [
        ScooterColour(id: 'c-008', name: 'Pearl White', colorHex: 0xFFF5F5F5),
        ScooterColour(id: 'c-009', name: 'Champagne Bronze', colorHex: 0xFFD4AF37),
      ],
    ),
  ];

  static Scooter? getBySlug(String slug) {
    try {
      return scooters.firstWhere((s) => s.slug == slug);
    } catch (_) {
      return null;
    }
  }
}
