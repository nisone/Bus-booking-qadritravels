class Bus {
  final String id;
  final String from;
  final String destination;
  final String busType;
  List<dynamic> seats;
  final int ticketPrice;
  final String departureTime;
  final String arrivalTime;
  String heading;
  bool status;

  Bus(
      this.id,
      this.from,
      this.destination,
      this.seats,
      this.busType,
      this.ticketPrice,
      this.departureTime,
      this.arrivalTime,
      this.heading,
      this.status);
}
