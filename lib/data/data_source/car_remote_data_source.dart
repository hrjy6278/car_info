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
  final dbField = 'cars';

  CarRemoteDataSourceImpl(this.firestore);

  @override
  Future<APIResult<List<Car>>> getCarData(String keyword) async {
    List<Car> cars = [];

    try {
      QuerySnapshot snapshot = await firestore
          .collection(dbField)
          .where('model', isEqualTo: keyword)
          .get();

      for (final doc in snapshot.docs) {
        cars.add(Car.fromJson(doc.data() as Map<String, dynamic>));
      }

      if (cars.isEmpty) {
        return APIResult(
          code: 404,
          message: 'No cars found for keyword: $keyword',
        );
      }

      return APIResult(
        code: 200,
        message: '성공',
        data: cars,
      );
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
    for (final car in cars) {
      try {
        await firestore.collection(dbField).add(car.toJson());
      } catch (e) {
        print("Error saving car data: $e");
      }
    }
  }
}
