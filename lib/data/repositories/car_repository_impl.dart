import 'package:car_info/data/api_result/api_result.dart';
import 'package:car_info/data/api_service/gpt_service.dart';
import 'package:car_info/data/data_source/car_remote_data_source.dart';
import 'package:car_info/domain/entities/car.dart';
import 'package:car_info/domain/repositories/car_repository.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CarRepository)
class CarRepositoryImpl implements CarRepository {
  final CarRemoteDataSource remoteDataSource;
  final GptService gptService;

  CarRepositoryImpl(this.remoteDataSource, this.gptService);

  @override
  Future<APIResult<List<Car>>> getCarInfo(String keywords) async {
    return await remoteDataSource.getCarData(keywords);
  }

  @override
  Future<APIResult<List<Car>>> getCarsDataFromAI(String query) async {
    return await gptService.fetchCarsDataFromGpt(query);
  }

  @override
  Future<void> saveCarsDataToFirebase({
    required String keyword,
    required List<Car> cars,
  }) async {
    return await remoteDataSource.saveCarsData(
      keyword: keyword,
      cars: cars,
    );
  }
}
