import 'package:car_info/domain/entities/car.dart';

abstract class CarRepository {
  Future<List<Car>> getCarInfo(String keywords);
  Future<List<Car>> getCarsDataFromAI(String keywords);
  Future<void> saveCarsDataToFirebase({
    required String keyword,
    required List<Car> cars,
  });
}
