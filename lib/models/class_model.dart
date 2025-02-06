import 'package:cloud_firestore/cloud_firestore.dart';

class ClassModel {
  final String id;
  final String name;
  final String teacherId;
  final List<String> studentIds;
  final DateTime createdAt;

  ClassModel({
    required this.id,
    required this.name,
    required this.teacherId,
    this.studentIds = const [],
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory ClassModel.fromFirestore(Map<String, dynamic> data, String documentId) {
    return ClassModel(
      id: documentId,
      name: data['name'] ?? '',
      teacherId: data['teacherId'] ?? '',
      studentIds: List<String>.from(data['studentIds'] ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'teacherId': teacherId,
      'studentIds': studentIds,
      'createdAt': createdAt,
    };
  }
}