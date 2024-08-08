import 'package:cloud_firestore/cloud_firestore.dart';

class CuestionariosVistos {
  final String idCuestionario;
  final String temaId;
  final String userId;
  final bool esVisto;

  CuestionariosVistos({
    required this.idCuestionario,
    required this.temaId,
    required this.userId,
    required this.esVisto,
  });

  factory CuestionariosVistos.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return CuestionariosVistos(
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
