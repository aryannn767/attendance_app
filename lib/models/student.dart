class Student {
  final String id;
  final String name;
  final String rollNumber;
  final String rfidUid;
  final String bluetoothUuid;

  Student({
    required this.id,
    required this.name,
    required this.rollNumber,
    required this.rfidUid,
    required this.bluetoothUuid,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      name: json['name'],
      rollNumber: json['rollNumber'],
      rfidUid: json['rfidUid'],
      bluetoothUuid: json['bluetoothUuid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'rollNumber': rollNumber,
      'rfidUid': rfidUid,
      'bluetoothUuid': bluetoothUuid,
    };
  }
}