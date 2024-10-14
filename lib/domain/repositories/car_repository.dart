import 'package:car_info/domain/entities/car.dart';

abstract class CarRepository {
  Future<List<Car>> getCarInfo(List<String> keywords);
  Future<List<Car>> getCarsDataFromAI(String keywords);
  Future<void> saveCarsDataToFirebase(List<Car> cars);
}
