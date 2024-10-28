import 'package:flutter/material.dart';
import 'package:car_info/domain/entities/car.dart';

class CarDetailScreen extends StatelessWidget {
  final Car car;

  const CarDetailScreen({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          '${car.make} ${car.model}',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // 차량 기본 정보
            buildInfoSection(
              title: '기본 정보',
              content: [
                '연식: ${car.year}',
                '엔진: ${car.engine}',
                '트림: ${car.trim}',
                '마력: ${car.horsepower} 마력',
              ],
            ),
            const SizedBox(height: 20),

            // 성능 정보 섹션
            buildInfoSection(
              title: '성능 정보',
              content: [
                if (car.zeroTo100Kph != null)
                  '0-100 km/h: ${car.zeroTo100Kph} 초',
                if (car.zeroTo200Kph != null)
                  '0-200 km/h: ${car.zeroTo200Kph} 초',
              ],
            ),
            const SizedBox(height: 20),

            // 추가 정보 섹션
            buildInfoSection(
              title: '추가 정보',
              content: [
                if (car.torque != null) '토크: ${car.torque}Nm',
                if (car.drivetrain != null) '구동 방식: ${car.drivetrain}',
                if (car.fuelType != null) '연료 종류: ${car.fuelType}',
                if (car.transmission != null) '변속기: ${car.transmission}',
                if (car.seatingCapacity != null)
                  '좌석 수: ${car.seatingCapacity}석',
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInfoSection({
    required String title,
    required List<String> content,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ...content.map((info) => Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: Text(
                  info,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
