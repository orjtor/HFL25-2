/// Represents the result of an API operation
class ApiResult<T> {
  final bool isSuccess;
  final T? data;
  final String? error;

  const ApiResult.success(this.data) : isSuccess = true, error = null;

  const ApiResult.error(this.error) : isSuccess = false, data = null;

  /// Execute a function if the result is successful
  ApiResult<R> map<R>(R Function(T data) transform) {
    if (isSuccess && data != null) {
      try {
        return ApiResult.success(transform(data!));
      } catch (e) {
        return ApiResult.error('Transform error: $e');
      }
    }
    return ApiResult.error(error);
  }

  /// Get data or throw if error
  T get dataOrThrow {
    if (isSuccess && data != null) {
      return data!;
    }
    throw Exception(error ?? 'Unknown error');
  }

  @override
  String toString() {
    return isSuccess ? 'Success: $data' : 'Error: $error';
  }
}
