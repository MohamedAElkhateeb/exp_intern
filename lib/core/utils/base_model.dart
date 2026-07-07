class BaseResponse<T> {
  final int? status;
  final String? code;
  final String? message;
  final String? location;
  final T? data;

  BaseResponse({
    this.status,
    this.code,
    this.message,
    this.location,
    this.data,
  });

  factory BaseResponse.fromJson(
      Map<String, dynamic> json,
      T Function(dynamic json) fromJsonT,
      ) {
    return BaseResponse<T>(
      status: json['status'] as int?,
      code: json['code'] as String?,
      message: json['message'] as String?,
      location: json['location'] as String?,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }
}