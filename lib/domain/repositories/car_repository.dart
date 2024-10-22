import 'package:car_info/data/api_result/api_result.dart';
import 'package:car_info/domain/entities/car.dart';

abstract class CarRepository {
  Future<APIResult<List<Car>>> getCarInfo(String keywords);
  Future<APIResult<List<Car>>> getCarsDataFromAI(String keywords);
  Future<void> saveCarsDataToFirebase({
    required String keyword,
    required List<Car> cars,
  });
}
