import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../serializers.dart';

part 'feature_record.g.dart';

abstract class FeatureRecord
    implements Built<FeatureRecord, FeatureRecordBuilder> {
  // fields go here
  static Serializer<FeatureRecord> get serializer => _$featureRecordSerializer;

  @BuiltValueField(wireName: 'geometry')
  String? get geometry;

  @BuiltValueField(wireName: 'weight')
  String? get weight;

  @BuiltValueField(wireName: 'type')
  String? get type;

  @BuiltValueField(wireName: 'name')
  String? get name;

  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference? get ffRef;
  DocumentReference get reference => ffRef!;
  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('features');

  static Stream<FeatureRecord> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  static Future<FeatureRecord> getDocumentOnce(DocumentReference ref) => ref
      .get()
      .then((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  static void _initializeBuilder(FeatureRecordBuilder builder) => builder
    ..name = ''
    ..geometry = ''
    ..weight = ''
    ..type = '';

  FeatureRecord._();

  factory FeatureRecord([updates(FeatureRecordBuilder b)]) = _$FeatureRecord;
}

Map<String, dynamic> createFeatureRecordData(
    {String? name, String? geometry, String? weight, String? type}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'name': name,
      'geometry': geometry,
      'weight': weight,
      'type': type
    },
  ).withoutNulls;

  return firestoreData;
}
