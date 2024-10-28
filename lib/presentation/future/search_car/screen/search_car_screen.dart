import 'package:flutter/material.dart';
import 'package:car_info/domain/entities/car.dart';
import 'package:car_info/domain/ui_state/ui_state.dart';
import 'package:car_info/presentation/future/search_car/screen/car_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';
import 'package:car_info/presentation/future/search_car/provider/search_car_provider.dart';

class SearchCarScreen extends StatefulWidget {
  const SearchCarScreen({super.key});

  @override
  State<SearchCarScreen> createState() => _SearchCarScreenState();
}

class _SearchCarScreenState extends State<SearchCarScreen> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SearchCarProvider>(
      create: (context) => GetIt.I(),
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              '차량 검색',
              style: TextStyle(),
            ),
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _textEditingController,
                  decoration: InputDecoration(
                    hintText: '차종 검색',
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.clear,
                      ),
                      onPressed: () {
                        _textEditingController.clear();
                        context.read<SearchCarProvider>().cancelSearch();
                      },
                    ),
                  ),
                  onSubmitted: (value) =>
                      context.read<SearchCarProvider>().searchCar(value),
                  onChanged: (value) {
                    if (value.isEmpty) {
                      context.read<SearchCarProvider>().cancelSearch();
                    }
                  },
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Selector<SearchCarProvider, UiState<List<Car>>>(
                    selector: (context, provider) => provider.carState,
                    builder: (context, uiState, child) {
                      return uiState.reduce(
                        onInit: () =>
                            const Center(child: CircularProgressIndicator()),
                        onLoading: () =>
                            const Center(child: CircularProgressIndicator()),
                        onLoaded: (cars) => ListView.builder(
                          itemCount: cars.length,
                          itemBuilder: (context, index) {
                            final car = cars[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CarDetailScreen(car: car),
                                  ),
                                );
                              },
                              child: CarTile(car: car),
                            );
                          },
                        ),
                        onError: (error) => Center(
                          child: Text(
                            '에러 발생: ${error?.toString()}',
                            style: const TextStyle(color: Colors.redAccent),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CarTile extends StatelessWidget {
  final Car car;

  const CarTile({
    super.key,
    required this.car,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${car.year} ${car.make} ${car.model} ${car.trim}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.directions_car, size: 20),
              const SizedBox(width: 6),
              Text('마력: ${car.horsepower} 마력',
                  style: const TextStyle(
                    fontSize: 14,
                  )),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '0-100 km/h: ${car.zeroTo100Kph ?? "정보 없음"} 초',
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
          Text(
            '0-200 km/h: ${car.zeroTo200Kph ?? "정보 없음"} 초',
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
