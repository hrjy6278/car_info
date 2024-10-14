import 'package:freezed_annotation/freezed_annotation.dart';

part 'car.freezed.dart';

part 'car.g.dart';

@freezed
class Car with _$Car {
  factory Car({
    required String make,
    required String model,
    required int year,
    required String engine,
    int? horsepower,
    double? zeroTo100Kph,
    double? zeroTo200Kph,
  }) = _Car;

  factory Car.fromJson(Map<String, Object?> json) => _$CarFromJson(json);
}
