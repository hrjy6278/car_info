import 'package:car_info/data/api_result/api_result.dart';
import 'package:car_info/domain/entities/car.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

abstract class CarRemoteDataSource {
  Future<APIResult<List<Car>>> getCarData(String keyword);
  Future<void> saveCarsData({
    required String keyword,
    required List<Car> cars,
  });
}

@Injectable(as: CarRemoteDataSource)
class CarRemoteDataSourceImpl implements CarRemoteDataSource {
  final FirebaseFirestore firestore;
  final dbField = 'cars'; // 컬렉션 이름

  CarRemoteDataSourceImpl(this.firestore);

  @override
  Future<APIResult<List<Car>>> getCarData(String keyword) async {
    List<Car> cars = [];

    try {
      final snapshot = await firestore.collection(dbField).doc(keyword).get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;

        for (final carData in data['cars'] ?? []) {
          cars.add(Car.fromJson(carData as Map<String, dynamic>));
        }

        if (cars.isEmpty) {
          return APIResult(
            code: 404,
            message: 'No cars found for keyword: $keyword',
          );
        } else {
          return APIResult(
            code: 200,
            message: '성공',
            data: cars,
          );
        }
      } else {
        return APIResult(
          code: 404,
          message: 'No document found for keyword: $keyword',
        );
      }
    } catch (e) {
      return APIResult(
        code: 500,
        message: 'Failed to fetch data from Firestore: $e',
      );
    }
  }

  @override
  Future<void> saveCarsData({
    required String keyword,
    required List<Car> cars,
  }) async {
    // 각 모델 데이터를 배열로 저장
    List<Map<String, dynamic>> carList =
        cars.map((car) => car.toJson()).toList();

    // keyword에 해당하는 문서에 자동차 데이터 저장
    await firestore.collection(dbField).doc(keyword).set({
      dbField: carList,
    });
  }
}
