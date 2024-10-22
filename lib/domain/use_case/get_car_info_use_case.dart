import 'package:car_info/data/api_result/api_result.dart';
import 'package:injectable/injectable.dart';
import '../entities/car.dart';
import '../repositories/car_repository.dart';
import '../ui_state/ui_state.dart';

@injectable
class GetCarInfoUseCase {
  final CarRepository repository;

  GetCarInfoUseCase(this.repository);

  Future<UiState<List<Car>>> call(String query) async {
    try {
      APIResult<List<Car>> apiResult = await repository.getCarInfo(query);

      // Firebase에서 데이터를 찾지 못했을 경우 AI로부터 데이터 요청
      if (apiResult.data == null || apiResult.data!.isEmpty) {
        // AI로부터 데이터 요청
        APIResult<List<Car>> aiResult =
            await repository.getCarsDataFromAI(query);

        // AI에서 데이터를 성공적으로 가져오면 Firebase에 저장
        if (aiResult.data != null && aiResult.data!.isNotEmpty) {
          await repository.saveCarsDataToFirebase(
              keyword: query, cars: aiResult.data!);
        }

        // AI에서 받은 데이터를 UiState로 변환
        return toState(aiResult);
      }

      // Firebase에서 받은 데이터를 UiState로 변환하여 반환
      return toState(apiResult);
    } catch (e) {
      // 예외 발생 시 실패 상태 반환
      return UiState.failed(e as Exception);
    }
  }
}
