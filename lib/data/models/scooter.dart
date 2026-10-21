import 'package:equatable/equatable.dart';

/// Publication status for scooter catalogue
enum ScooterStatus { draft, published, archived }

/// Represents a scooter colour variant
class ScooterColour extends Equatable {
  final String id;
  final String name;
  final int colorHex; // stored as int e.g. 0xFFF5F5F5
  final String? imageUrl;

  const ScooterColour({
    required this.id,
    required this.name,
    required this.colorHex,
    this.imageUrl,
  });

  factory ScooterColour.fromJson(Map<String, dynamic> json) {
    return ScooterColour(
      id: json['id'] as String,
      name: json['name'] as String,
      colorHex: int.parse(
        (json['color_hex'] as String).replaceFirst('#', 'FF'),
        radix: 16,
      ),
      imageUrl: json['image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'color_hex': '#${colorHex.toRadixString(16).substring(2).toUpperCase()}',
        'image_url': imageUrl,
      };

  @override
  List<Object?> get props => [id, name, colorHex, imageUrl];
}

/// Technical specifications for a scooter
class ScooterSpecs extends Equatable {
  final String? rangeKm;
  final String? topSpeedKmh;
  final String? batteryType;
  final String? batteryVoltage;
  final String? batteryCapacityAh;
  final String? motorPowerW;
  final String? chargingTimeHours;
  final String? loadCapacityKg;
  final String? dimensions;
  final String? warranty;
  final String? features;

  const ScooterSpecs({
    this.rangeKm,
    this.topSpeedKmh,
    this.batteryType,
    this.batteryVoltage,
    this.batteryCapacityAh,
    this.motorPowerW,
    this.chargingTimeHours,
    this.loadCapacityKg,
    this.dimensions,
    this.warranty,
    this.features,
  });

  factory ScooterSpecs.fromJson(Map<String, dynamic> json) {
    return ScooterSpecs(
      rangeKm: json['range_km']?.toString(),
      topSpeedKmh: json['top_speed_kmh']?.toString(),
      batteryType: json['battery_type'] as String?,
      batteryVoltage: json['battery_voltage']?.toString(),
      batteryCapacityAh: json['battery_capacity_ah']?.toString(),
      motorPowerW: json['motor_power_w']?.toString(),
      chargingTimeHours: json['charging_time_hours']?.toString(),
      loadCapacityKg: json['load_capacity_kg']?.toString(),
      dimensions: json['dimensions'] as String?,
      warranty: json['warranty'] as String?,
      features: json['features'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'range_km': rangeKm,
        'top_speed_kmh': topSpeedKmh,
        'battery_type': batteryType,
        'battery_voltage': batteryVoltage,
        'battery_capacity_ah': batteryCapacityAh,
        'motor_power_w': motorPowerW,
        'charging_time_hours': chargingTimeHours,
        'load_capacity_kg': loadCapacityKg,
        'dimensions': dimensions,
        'warranty': warranty,
        'features': features,
      };

  @override
  List<Object?> get props => [
        rangeKm,
        topSpeedKmh,
        batteryType,
        batteryVoltage,
        batteryCapacityAh,
        motorPowerW,
        chargingTimeHours,
        loadCapacityKg,
        dimensions,
        warranty,
        features,
      ];
}

/// Core scooter model
class Scooter extends Equatable {
  final String id;
  final String slug;
  final String modelName;
  final String modelCode;
  final String? shortDescription;
  final String? description;
  final String? category;
  final bool priceOnRequest;
  final double? price;
  final ScooterStatus status;
  final String? thumbnailUrl;
  final List<String> galleryUrls;
  final String? modelUrl3d; // GLB/GLTF path
  final ScooterSpecs? specs;
  final List<ScooterColour> colours;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Scooter({
    required this.id,
    required this.slug,
    required this.modelName,
    required this.modelCode,
    this.shortDescription,
    this.description,
    this.category,
    this.priceOnRequest = true,
    this.price,
    this.status = ScooterStatus.draft,
    this.thumbnailUrl,
    this.galleryUrls = const [],
    this.modelUrl3d,
    this.specs,
    this.colours = const [],
    this.createdAt,
    this.updatedAt,
  });

  bool get isPublished => status == ScooterStatus.published;
  bool get has3dModel => modelUrl3d != null && modelUrl3d!.isNotEmpty;

  String get displayPrice {
    if (priceOnRequest || price == null) return 'Price on request';
    return '₹${price!.toStringAsFixed(0)}';
  }

  factory Scooter.fromJson(Map<String, dynamic> json) {
    return Scooter(
      id: json['id'] as String,
      slug: json['slug'] as String,
      modelName: json['model_name'] as String,
      modelCode: json['model_code'] as String? ?? '',
      shortDescription: json['short_description'] as String?,
      description: json['description'] as String?,
      category: json['category'] as String?,
      priceOnRequest: json['price_on_request'] as bool? ?? true,
      price: (json['price'] as num?)?.toDouble(),
      status: ScooterStatus.values.firstWhere(
        (s) => s.name == (json['status'] as String? ?? 'draft'),
        orElse: () => ScooterStatus.draft,
      ),
      thumbnailUrl: json['thumbnail_url'] as String?,
      galleryUrls: (json['gallery_urls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      modelUrl3d: json['model_url_3d'] as String?,
      specs: json['scooter_specs'] != null
          ? ScooterSpecs.fromJson(
              json['scooter_specs'] as Map<String, dynamic>)
          : null,
      colours: (json['scooter_colours'] as List<dynamic>?)
              ?.map((e) => ScooterColour.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'slug': slug,
        'model_name': modelName,
        'model_code': modelCode,
        'short_description': shortDescription,
        'description': description,
        'category': category,
        'price_on_request': priceOnRequest,
        'price': price,
        'status': status.name,
        'thumbnail_url': thumbnailUrl,
        'gallery_urls': galleryUrls,
        'model_url_3d': modelUrl3d,
      };

  Scooter copyWith({
    String? modelName,
    String? shortDescription,
    String? description,
    String? category,
    bool? priceOnRequest,
    double? price,
    ScooterStatus? status,
    String? thumbnailUrl,
    List<String>? galleryUrls,
    String? modelUrl3d,
    ScooterSpecs? specs,
    List<ScooterColour>? colours,
  }) {
    return Scooter(
      id: id,
      slug: slug,
      modelName: modelName ?? this.modelName,
      modelCode: modelCode,
      shortDescription: shortDescription ?? this.shortDescription,
      description: description ?? this.description,
      category: category ?? this.category,
      priceOnRequest: priceOnRequest ?? this.priceOnRequest,
      price: price ?? this.price,
      status: status ?? this.status,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      galleryUrls: galleryUrls ?? this.galleryUrls,
      modelUrl3d: modelUrl3d ?? this.modelUrl3d,
      specs: specs ?? this.specs,
      colours: colours ?? this.colours,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, slug, modelName, status];
}
