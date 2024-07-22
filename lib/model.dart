class Resource {
  final Status status;
  final String? message;

  Resource({required this.status, this.message});
}

enum Status { Success, Cancelled, Error }
