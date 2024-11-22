import 'package:cloud_firestore/cloud_firestore.dart';

class Reservation {
  String id;
  String customerName;
  String contactNumber;
  DateTime reservationDate;
  int partySize;
  String tableNumber;
  String status;

  Reservation({
    required this.id,
    required this.customerName,
    required this.contactNumber,
    required this.reservationDate,
    required this.partySize,
    required this.tableNumber,
    required this.status,
  });

  // Convert Firestore data to Reservation object
  factory Reservation.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Reservation(
      id: doc.id,
      customerName: data['customerName'] ?? '',
      contactNumber: data['contactNumber'] ?? '',
      reservationDate: (data['reservationDate'] as Timestamp).toDate(),
      partySize: data['partySize'] ?? 1,
      tableNumber: data['tableNumber'] ?? '',
      status: data['status'] ?? 'pending',
    );
  }

  // Convert Reservation object to Firestore data
  Map<String, dynamic> toFirestore() {
    return {
      'customerName': customerName,
      'contactNumber': contactNumber,
      'reservationDate': reservationDate,
      'partySize': partySize,
      'tableNumber': tableNumber,
      'status': status,
    };
  }
}
