import 'package:car_info/data/api_result/api_result.dart';

typedef OnEmptyCallback<R> = R Function();
typedef OnLoadingCallback<R> = R Function();
typedef OnLoadedCallback<R, T> = R Function(T value);
typedef OnErrorCallback<R> = R Function(Exception? exception);

enum StateType {
  init,
  loading,
  loaded,
  failed,
}

class UiState<T> {
  const UiState._({
    this.data,
    this.exception,
    required this.type,
  });

  // 다양한 상태 생성자
  factory UiState.init() => UiState<T>._(
        type: StateType.init,
      );
  factory UiState.loading() => UiState<T>._(
        type: StateType.loading,
      );
  factory UiState.loaded(T value) => UiState._(
        type: StateType.loaded,
        data: value,
      );
  factory UiState.failed(Exception? error) => UiState._(
        type: StateType.failed,
        exception: error,
      );

  final T? data;
  final Exception? exception;
  final StateType type;

  void onInit(OnEmptyCallback<void> handle) {
    if (type == StateType.init) {
      handle();
    }
  }

  void onLoading(OnLoadingCallback<void> handle) {
    if (type == StateType.loading) {
      handle();
    }
  }

  void onLoaded(OnLoadedCallback<void, T> handle) {
    if (type == StateType.loaded) {
      var value = data;
      if (value != null) {
        handle(value);
      }
    }
  }

  // 상태가 failed일 때 실행
  void onFailed(OnErrorCallback<void> handle) {
    if (type == StateType.failed) {
      handle(exception);
    }
  }

  // 상태에 따른 콜백을 실행해 결과를 반환
  R reduce<R>({
    required OnEmptyCallback<R> onInit,
    required OnLoadingCallback<R> onLoading,
    required OnLoadedCallback<R, T> onLoaded,
    required OnErrorCallback<R> onError,
  }) {
    switch (type) {
      case StateType.init:
        return onInit();
      case StateType.loading:
        return onLoading();
      case StateType.loaded:
        return onLoaded(data as T);
      case StateType.failed:
        return onError(exception);
    }
  }
}

UiState<T> toState<T>(APIResult<T> apiResult) {
  if (apiResult.code == 200 && apiResult.data != null) {
    return UiState.loaded(apiResult.data as T); // 성공 상태
  } else {
    return UiState.failed(Exception(apiResult.message)); // 실패 상태
  }
}
