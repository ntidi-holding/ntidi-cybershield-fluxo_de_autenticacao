class Result<T> {
  final T? result;
  final String? message;
  final Status status;

  const Result._({this.result, this.message, required this.status});

  factory Result.success(T data) =>
      Result._(result: data, status: Status.success);

  factory Result.failure(String msg) =>
      Result._(message: msg, status: Status.failure);

  factory Result.loading() => Result._(status: Status.loading);

  factory Result.idle() => Result._(status: Status.idle);

  bool get isSuccess => status == Status.success;

  bool get isLoading => status == Status.loading;

  bool get isFailure => status == Status.failure;

  bool get isIdle => status == Status.idle;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Result<T> &&
        other.status == status &&
        other.result == result &&
        other.message == message;
  }

  @override
  int get hashCode => status.hashCode ^ result.hashCode ^ message.hashCode;
}

enum Status { idle, loading, success, failure }
