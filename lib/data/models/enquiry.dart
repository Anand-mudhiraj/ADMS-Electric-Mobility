import 'package:equatable/equatable.dart';

enum EnquiryStatus { new_, contacted, scheduled, completed, cancelled }

class Enquiry extends Equatable {
  final String id;
  final String customerName;
  final String phoneNumber;
  final String city;
  final String? scooterId;
  final String? scooterName;
  final String? message;
  final EnquiryStatus status;
  final DateTime? createdAt;

  const Enquiry({
    required this.id,
    required this.customerName,
    required this.phoneNumber,
    required this.city,
    this.scooterId,
    this.scooterName,
    this.message,
    this.status = EnquiryStatus.new_,
    this.createdAt,
  });

  factory Enquiry.fromJson(Map<String, dynamic> json) {
    return Enquiry(
      id: json['id'] as String,
      customerName: json['customer_name'] as String,
      phoneNumber: json['phone_number'] as String,
      city: json['city'] as String,
      scooterId: json['scooter_id'] as String?,
      scooterName: json['scooter_name'] as String?,
      message: json['message'] as String?,
      status: EnquiryStatus.values.firstWhere(
        (s) => s.name == (json['status'] as String? ?? 'new_'),
        orElse: () => EnquiryStatus.new_,
      ),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'customer_name': customerName,
        'phone_number': phoneNumber,
        'city': city,
        'scooter_id': scooterId,
        'scooter_name': scooterName,
        'message': message,
        'status': status.name,
      };

  @override
  List<Object?> get props => [id, customerName, phoneNumber, status];
}

class TestRideRequest extends Equatable {
  final String id;
  final String customerName;
  final String phoneNumber;
  final String city;
  final String? scooterId;
  final String? scooterName;
  final DateTime? preferredDate;
  final String? preferredTime;
  final String? message;
  final EnquiryStatus status;
  final DateTime? createdAt;

  const TestRideRequest({
    required this.id,
    required this.customerName,
    required this.phoneNumber,
    required this.city,
    this.scooterId,
    this.scooterName,
    this.preferredDate,
    this.preferredTime,
    this.message,
    this.status = EnquiryStatus.new_,
    this.createdAt,
  });

  factory TestRideRequest.fromJson(Map<String, dynamic> json) {
    return TestRideRequest(
      id: json['id'] as String,
      customerName: json['customer_name'] as String,
      phoneNumber: json['phone_number'] as String,
      city: json['city'] as String,
      scooterId: json['scooter_id'] as String?,
      scooterName: json['scooter_name'] as String?,
      preferredDate: json['preferred_date'] != null
          ? DateTime.parse(json['preferred_date'] as String)
          : null,
      preferredTime: json['preferred_time'] as String?,
      message: json['message'] as String?,
      status: EnquiryStatus.values.firstWhere(
        (s) => s.name == (json['status'] as String? ?? 'new_'),
        orElse: () => EnquiryStatus.new_,
      ),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'customer_name': customerName,
        'phone_number': phoneNumber,
        'city': city,
        'scooter_id': scooterId,
        'scooter_name': scooterName,
        'preferred_date': preferredDate?.toIso8601String(),
        'preferred_time': preferredTime,
        'message': message,
        'status': status.name,
      };

  @override
  List<Object?> get props => [id, customerName, phoneNumber, status];
}
