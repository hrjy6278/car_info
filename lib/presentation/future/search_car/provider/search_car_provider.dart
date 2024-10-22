import 'package:car_info/domain/entities/car.dart';
import 'package:car_info/domain/ui_state/ui_state.dart';
import 'package:car_info/domain/use_case/get_car_info_use_case.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@injectable
class SearchCarProvider extends ChangeNotifier {
  final GetCarInfoUseCase getCarInfoUseCase;

  SearchCarProvider(this.getCarInfoUseCase);

  UiState<List<Car>> _carState = UiState.init();
  UiState<List<Car>> get carState => _carState;

  Future<void> searchCar(String query) async {
    _carState = UiState.loading();
    notifyListeners();

    _carState = await getCarInfoUseCase.call(query);

    notifyListeners();
  }

  void cancelSearch() {
    _carState = UiState.init();
    notifyListeners();
  }
}
