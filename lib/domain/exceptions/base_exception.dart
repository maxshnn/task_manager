enum ExceptionType {
  local,
  network,
  unknown,
}

class BaseException implements Exception {
  final String message;
  final ExceptionType type;
  
  BaseException({required this.message, required this.type});
}
