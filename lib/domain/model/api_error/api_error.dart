import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_error.freezed.dart';
@freezed
class ApiError with _$ApiError {
  const factory ApiError({
    required String message,
    required int statusCode,
  }) = _ApiError;
}
