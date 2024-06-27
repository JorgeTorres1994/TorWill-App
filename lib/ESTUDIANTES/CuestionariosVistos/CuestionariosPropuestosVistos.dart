import 'package:cloud_firestore/cloud_firestore.dart';

class CuestionariosPropuestosVistos {
  final String idCuestionario;
  final String temaId;
  final String userId;
  final bool esVisto;

  CuestionariosPropuestosVistos({
    required this.idCuestionario,
    required this.temaId,
    required this.userId,
    required this.esVisto,
  });

  factory CuestionariosPropuestosVistos.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return CuestionariosPropuestosVistos(
      idCuestionario: doc.id,
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
