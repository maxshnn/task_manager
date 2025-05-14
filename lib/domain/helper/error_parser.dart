import 'package:isar/isar.dart';
import 'package:task_manager/domain/exceptions/base_exception.dart';

class ErrorParser {
  static BaseException parse(Object error) {
    if (error is IsarError) {
      return BaseException(message: error.message, type: ExceptionType.local);
    }
    return BaseException(
        message: 'Неизвесткая ошибка', type: ExceptionType.unknown);
  }
}
