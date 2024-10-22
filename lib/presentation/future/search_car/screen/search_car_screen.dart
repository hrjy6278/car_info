import 'package:car_info/domain/entities/car.dart';
import 'package:car_info/domain/ui_state/ui_state.dart';
import 'package:car_info/util/color/color.dart';
import 'package:flutter/material.dart';
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
          backgroundColor: AppColors.backgroundColor, // 라이트 샌드
          body: Stack(
            children: [
              Positioned(
                  child: Container(
                color: AppColors.primaryColor,
                height: MediaQuery.of(context).viewPadding.top,
              )),
              SafeArea(
                child: Scrollbar(
                  child: CustomScrollView(
                    slivers: [
                      const SliverAppBar(
                        title: Text(
                          '차량 검색',
                          style: TextStyle(
                            color: AppTextColors.primaryTextColor,
                          ),
                        ),
                        backgroundColor: AppColors.primaryColor,
                      ),
                      const SliverToBoxAdapter(
                        child: SizedBox(
                          height: 16,
                        ),
                      ),
                      SliverAppBar(
                        pinned: true,
                        excludeHeaderSemantics: false,
                        backgroundColor: AppColors.backgroundColor,
                        surfaceTintColor: Colors.white,
                        title: TextField(
                          controller: _textEditingController,
                          decoration: InputDecoration(
                            hintText: '차종 검색',
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _textEditingController.clear();
                                context
                                    .read<SearchCarProvider>()
                                    .cancelSearch();
                              },
                            ),
                          ),
                          onSubmitted: (value) => context
                              .read<SearchCarProvider>()
                              .searchCar(value),
                          onChanged: (value) {
                            if (value == '') {
                              context.read<SearchCarProvider>().cancelSearch();
                            }
                          },
                        ),
                      ),
                      Selector<SearchCarProvider, UiState<List<Car>>>(
                        selector: (context, provider) => provider.carState,
                        builder: (context, uiState, child) {
                          return uiState.reduce(
                            onInit: () => const SliverToBoxAdapter(
                              child: SizedBox.shrink(),
                            ),
                            onLoading: () => const SliverToBoxAdapter(
                              child: Center(child: CircularProgressIndicator()),
                            ),
                            onLoaded: (cars) => SliverList.builder(
                              itemCount: cars.length,
                              itemBuilder: (context, index) {
                                final car = cars[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                    vertical: 8.0,
                                  ),
                                  child: CarTile(car: car),
                                );
                              },
                            ),
                            onError: (error) => SliverToBoxAdapter(
                              child: Center(
                                child: Text(
                                  '에러 발생: ${error?.toString()}',
                                  style: const TextStyle(
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CarTile extends StatelessWidget {
  const CarTile({
    super.key,
    required this.car,
  });

  final Car car;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        leading: const Icon(
          Icons.directions_car,
          size: 32,
          color: AppColors.primaryColor,
        ),
        title: Text(
          '${car.year} ${car.make} ${car.model} ${car.trim}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTextColors.darkTextColor,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              '마력: ${car.horsepower} 마력',
              style: const TextStyle(
                fontSize: 14,
                color: AppTextColors.secondaryTextColor, // 중간 회색 텍스트
              ),
            ),
            Text(
              '0-100 km/h: ${car.zeroTo100Kph ?? "정보 없음"} 초',
              style: const TextStyle(
                fontSize: 14,
                color: AppTextColors.secondaryTextColor,
              ),
            ),
            Text(
              '0-200 km/h: ${car.zeroTo200Kph ?? "정보 없음"} 초',
              style: const TextStyle(
                fontSize: 14,
                color: AppTextColors.secondaryTextColor,
              ),
            ),
          ],
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: AppColors.primaryColor,
        ),
      ),
    );
  }
}
