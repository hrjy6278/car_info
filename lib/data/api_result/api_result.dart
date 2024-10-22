class APIResult<T> {
  final int code;
  final String message;
  final T? data;

  APIResult({
    required this.code,
    required this.message,
    this.data,
  });
}
