import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../serializers.dart';

part 'sub_category_record.g.dart';

abstract class SubCategoryRecord
    implements Built<SubCategoryRecord, SubCategoryRecordBuilder> {
  static Serializer<SubCategoryRecord> get serializer =>
      _$subCategoryRecordSerializer;
  // fields go here
  @BuiltValueField(wireName: 'sub_category_name')
  String? get subCategoryName;

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

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('sub_categories')
          : FirebaseFirestore.instance.collectionGroup('sub_categories');

  static DocumentReference createDoc(DocumentReference parent) =>
      parent.collection('sub_categories').doc();

  static Stream<SubCategoryRecord> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  static Future<SubCategoryRecord> getDocumentOnce(DocumentReference ref) => ref
      .get()
      .then((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  static void _initializeBuilder(SubCategoryRecordBuilder builder) => builder
    ..subCategoryName = ''
    ..image = '';

  SubCategoryRecord._();

  factory SubCategoryRecord([updates(SubCategoryRecordBuilder b)]) =
      _$SubCategoryRecord;
}

Map<String, dynamic> createSubCategoryRecordData({
  String? categoryName,
  String? image,
  DateTime? createdAt,
  DateTime? modifiedAt,
  DocumentReference? createdBy,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'category_name': categoryName,
      'image': image,
      'created_at': createdAt,
      'modified_at': modifiedAt,
      'created_by': createdBy,
    },
  ).withoutNulls;

  return firestoreData;
}
