class Ticket {
  const Ticket({
    required this.uid,
    required this.busId,
    required this.totalPrice,
    required this.origin,
    required this.destination,
    required this.seatsCount,
    required this.seatsNumber,
    required this.departureTime,
    required this.arrivalTime,
    required this.status,
    required this.isPaid,
  });

  final String uid;
  final String busId;
  final double totalPrice;
  final String origin;
  final String destination;
  final int seatsCount;
  final List seatsNumber;
  final String departureTime;
  final String arrivalTime;
  final bool status, isPaid;

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'busId': busId,
        'totalPrice': totalPrice,
        'origin': origin,
        'destination': destination,
        'seatsCount': seatsCount,
        'seatsNumber': seatsNumber,
        'departureTime': departureTime,
        'arrivalTime': arrivalTime,
        'status': status,
        'isPaid': isPaid,
      };
}
