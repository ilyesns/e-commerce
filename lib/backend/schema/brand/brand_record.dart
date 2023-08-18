import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../serializers.dart';

part 'brand_record.g.dart';

abstract class BrandRecord implements Built<BrandRecord, BrandRecordBuilder> {
  static Serializer<BrandRecord> get serializer => _$brandRecordSerializer;

  // fields go here
  @BuiltValueField(wireName: 'brand_name')
  String? get brandName;

  @BuiltValueField(wireName: 'image')
  String? get image;

  @BuiltValueField(wireName: 'created_at')
  DateTime? get createdAt;

  @BuiltValueField(wireName: 'modified_at')
  DateTime? get modifiedAt;
  @BuiltValueField(wireName: 'created_by')
  DocumentReference? get createdBy;

  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference? get ffRef;
  DocumentReference get reference => ffRef!;

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('brands');

  static Stream<BrandRecord> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  static Future<BrandRecord> getDocumentOnce(DocumentReference ref) => ref
      .get()
      .then((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  static void _initializeBuilder(BrandRecordBuilder builder) =>
      builder..brandName = '';

  BrandRecord._();

  factory BrandRecord([updates(BrandRecordBuilder b)]) = _$BrandRecord;
}

Map<String, dynamic> createBrandRecordData({
  String? brandName,
  String? image,
  DateTime? createdAt,
  DateTime? modifiedAt,
  DocumentReference? createdBy,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'brand_name': brandName,
      'image': image,
      'created_at': createdAt,
      'modified_at': modifiedAt,
      'created_by': createdBy,
    },
  ).withoutNulls;

  return firestoreData;
}
