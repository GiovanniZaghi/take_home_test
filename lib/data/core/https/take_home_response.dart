class TakeHomeResponse<T> {
  const TakeHomeResponse({
    required this.data,
    required this.statusCode,
  });

  final T data;
  final int statusCode;
}
