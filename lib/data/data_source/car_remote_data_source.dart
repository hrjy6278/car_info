import 'package:car_info/domain/entities/car.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

abstract class CarRemoteDataSource {
  Future<List<Car>> getCarData(List<String> keywords);
  Future<void> saveCarsData(List<Car> cars);
}

@Injectable(as: CarRemoteDataSource)
class CarRemoteDataSourceImpl implements CarRemoteDataSource {
  final FirebaseFirestore firestore;

  CarRemoteDataSourceImpl(this.firestore);

  @override
  Future<List<Car>> getCarData(List<String> keywords) async {
    List<Car> cars = [];
    QuerySnapshot snapshot = await firestore.collection('cars').get();

    for (var doc in snapshot.docs) {
      List<String> docKeywords = List<String>.from(doc['keywords']);
      if (docKeywords.any((k) => keywords.contains(k))) {
        cars.add(Car.fromJson(doc.data() as Map<String, dynamic>));
      }
    }

    return cars;
  }

  @override
  Future<void> saveCarsData(List<Car> cars) async {
    for (var car in cars) {
      await firestore.collection('cars').add(car.toJson());
    }
  }
}
