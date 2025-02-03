class Contact {
  int? id; // Agora não é mais final, permitindo edição
  String name;
  double latitude;
  double longitude;

  Contact({this.id, required this.name, required this.latitude, required this.longitude});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'],
      name: map['name'],
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }
}
