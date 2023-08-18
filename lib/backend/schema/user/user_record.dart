import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:blueraymarket/backend/schema/serializers.dart';

part 'user_record.g.dart';

abstract class UserRecord implements Built<UserRecord, UserRecordBuilder> {
  static Serializer<UserRecord> get serializer => _$userRecordSerializer;

  @BuiltValueField(wireName: 'name')
  String? get name;

  @BuiltValueField(wireName: 'email')
  String? get email;

  @BuiltValueField(wireName: 'phone_number')
  String? get phoneNumber;

  @BuiltValueField(wireName: 'photo_url')
  String? get photoUrl;

  @BuiltValueField(wireName: 'created_time')
  DateTime? get createdTime;

  String? get uid;

  @BuiltValueField(wireName: 'role')
  String? get role;

  @BuiltValueField(wireName: 'address')
  String? get address;

  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference? get ffRef;
  DocumentReference get reference => ffRef!;

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('users');

  static Stream<UserRecord> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  static Future<UserRecord> getDocumentOnce(DocumentReference ref) => ref
      .get()
      .then((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  static UserRecord getDocumentFromData(
          Map<String, dynamic> data, DocumentReference reference) =>
      serializers.deserializeWith(serializer,
          {...mapFromFirestore(data), kDocumentReferenceField: reference})!;

  static void _initializeBuilder(UserRecordBuilder builder) => builder
    ..name = ''
    ..email = ''
    ..phoneNumber = ''
    ..photoUrl = ''
    ..uid = ''
    ..role = ''
    ..address = '';

  UserRecord._();
  factory UserRecord([void Function(UserRecordBuilder) updates]) = _$UserRecord;
}

Map<String, dynamic> createUserRecordData({
  String? name,
  String? email,
  String? phoneNumber,
  String? photoUrl,
  DateTime? createdTime,
  String? uid,
  String? role,
  String? address,
}) {
  final firestoreData = serializers
      .toFirestore(
        UserRecord.serializer,
        UserRecord(
          (u) => u
            ..name = name
            ..email = email
            ..phoneNumber = phoneNumber
            ..photoUrl = photoUrl
            ..createdTime = createdTime
            ..uid = uid
            ..role = role
            ..address = address,
        ),
      )
      .withoutNulls;

  return firestoreData;
}
