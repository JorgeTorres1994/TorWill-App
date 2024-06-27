import 'package:cloud_firestore/cloud_firestore.dart';

class MaterialVisto {
  final String id;
  final String temaId;
  final String userId;
  final bool esVisto;

  MaterialVisto({
    required this.id,
    required this.temaId,
    required this.userId,
    required this.esVisto,
  });

  factory MaterialVisto.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return MaterialVisto(
      id: doc.id,
      temaId: data['temaId'],
      userId: data['userId'],
      esVisto: data['esVisto'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'temaId': temaId,
      'userId': userId,
      'esVisto': esVisto,
    };
  }
}
