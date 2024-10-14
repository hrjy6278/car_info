import 'package:injectable/injectable.dart';
import '../entities/car.dart';
import '../repositories/car_repository.dart';

@injectable
class GetCarInfoUseCase {
  final CarRepository repository;

  GetCarInfoUseCase(this.repository);

  Future<List<Car>> call(String query) async {
    final keywords = query.toLowerCase().split(' ');
    List<Car> cars = await repository.getCarInfo(keywords);

    if (cars.isEmpty) {
      List<Car> aiCars = await repository.getCarsDataFromAI(query);

      if (aiCars.isNotEmpty) {
        await repository.saveCarsDataToFirebase(aiCars);
      }

      // AI에서 받은 차량을 추가
      cars.addAll(aiCars);
    }

    return cars;
  }
}
