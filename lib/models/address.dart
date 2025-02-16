class Address {
  final String name;
  final double latitude;
  final double longitude;
  final String fullName;
  final String? stateCode;
  final String? state;
  final String? city;

  Address({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.fullName,
    this.stateCode,
    this.state,
    this.city,
  });

  // deserialize City JSON into an Address object
  factory Address.fromMapCity(Map<String, dynamic> map) {
    // Extract city and state from "fn" (e.g., "Airdrie, Alberta")
    //List<String> parts = (map["fn"] ?? "").split(", ");
    //String? city = parts.isNotEmpty ? parts[0] : null;
    //String? state = parts.length > 1 ? parts[1] : null;

    return Address(
      name: map["n"] ?? "",
      latitude: map["la"] ?? 0.0,
      longitude: map["lo"] ?? 0.0,
      fullName: map["fn"] ?? "",
      //city: city,
      city: map["n"] ?? "",
      state: map["s"] ?? "",
      stateCode: "",
    );
  }

  // deserialize State JSON into an Address object
  factory Address.fromMapState(Map<String, dynamic> map) {
    return Address(
      name: map["n"] ?? "",
      latitude: map["la"] ?? 0.0,
      longitude: map["lo"] ?? 0.0,
      //latitude: double.tryParse(map["latitude"] ?? "0.0") ?? 0.0,
      //longitude: double.tryParse(map["longitude"] ?? "0.0") ?? 0.0,
      fullName: map["n"] ?? "",
      //city: city,
      city: "",
      state: map["n"] ?? "",
      stateCode: map["sc"] ?? "",
    );
  }
}
