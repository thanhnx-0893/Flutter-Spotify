class Error {
  final int statusCode;
  final String message;

  Error(this.statusCode, this.message);
  factory Error.fromJson(Map<String, dynamic> json) {
    return Error(
      json['error']['status'],
      json['error']['message'],
    );
  }
}