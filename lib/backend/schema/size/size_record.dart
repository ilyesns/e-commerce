import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../serializers.dart';

part 'size_record.g.dart';

abstract class SizeRecord implements Built<SizeRecord, SizeRecordBuilder> {
  // fields go here
  static Serializer<SizeRecord> get serializer => _$sizeRecordSerializer;

  @BuiltValueField(wireName: 'size_code')
  String? get sizeCode;

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('sizes');

  static Stream<SizeRecord> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  static Future<SizeRecord> getDocumentOnce(DocumentReference ref) => ref
      .get()
      .then((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  static void _initializeBuilder(SizeRecordBuilder builder) =>
      builder..sizeCode = '';

  SizeRecord._();

  factory SizeRecord([updates(SizeRecordBuilder b)]) = _$SizeRecord;
}

Map<String, dynamic> createColorRecordData({String? sizeName}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'size_code': sizeName,
    },
  ).withoutNulls;

  return firestoreData;
}
