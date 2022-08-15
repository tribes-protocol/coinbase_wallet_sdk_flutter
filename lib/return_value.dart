class ReturnValue {
  final String? value;
  final ReturnValueError? error;

  const ReturnValue({
    this.value,
    this.error,
  });

  factory ReturnValue.fromJson(Map<String, dynamic> json) {
    return ReturnValue(
      value: json['value'] == null ? null : json['value'] as String,
      error: json['error'] == null
          ? null
          : ReturnValueError.fromJson(json['error'] as Map<String, dynamic>),
    );
  }
}

class ReturnValueError {
  final int code;
  final String message;

  const ReturnValueError(this.code, this.message);

  factory ReturnValueError.fromJson(Map<String, dynamic> json) {
    return ReturnValueError(
      json['code'] as int,
      json['message'] as String,
    );
  }
}
