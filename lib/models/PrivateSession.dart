import 'package:cloud_firestore/cloud_firestore.dart';

class PrivateSession {
  List participantid;
  int date;

  DocumentReference reference;

  PrivateSession({this.participantid, this.date, this.reference});

  factory PrivateSession.fromSnapshot(DocumentSnapshot snapshot) {
    PrivateSession newPrivateSession = PrivateSession.fromJson(snapshot.data());
    newPrivateSession.reference = snapshot.reference;
    return newPrivateSession;
  }

  factory PrivateSession.fromJson(Map<String, dynamic> json) {
    return PrivateSession(
      participantid: json['participantid'] as List,
      date: json['date'] as int,
    );
  }

  Map<String, dynamic> toJson() => _PrivateSessionToJson(this);

  Map<String, dynamic> _PrivateSessionToJson(PrivateSession instance) {
    return <String, dynamic>{
      'participantid': instance.participantid,
      'date': instance.date
    };
  }

}