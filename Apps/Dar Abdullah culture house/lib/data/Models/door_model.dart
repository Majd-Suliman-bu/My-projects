class ReservationResponse {
  late int? reservationId;
  late bool? attendance;
  late int numberOfPlaces;
  late int? attendanceNumber;
  late int? sectionNumber;
  late String customerName;
  late int? customerId;
  late int? workerId;

  ReservationResponse({
      required this.reservationId,
    this.attendance,
    required this.numberOfPlaces,
    this.attendanceNumber,
    this.sectionNumber,
    required this.customerName,
    this.customerId,
    this.workerId,
  });

  factory ReservationResponse.fromJson(Map<String, dynamic> json) {
    // print(object)
    return ReservationResponse(
      
       reservationId: json['reservation_id']??0,
      attendance: json['attendance']??false,
      numberOfPlaces: json['number_of_places']??0,
      attendanceNumber: json['attendance_number']??0,
      sectionNumber: json['section_number']??0,
      customerName: json['customer_name']??'',
      customerId: json['customer_id']??0,
      workerId: json['worker_id']??0,
    );
  }
}
