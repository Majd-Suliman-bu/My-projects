class Reservation {
  final String id;
  final int specialistId;
  final String doctorName;
  final DateTime dateTime;
  final String
      status; // "confirmed", "waiting for doctor approval", "waiting for your approval"

  Reservation(
      {required this.id,
      required this.doctorName,
      required this.specialistId,
      required this.dateTime,
      required this.status});
}
