import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../serializers.dart';

part 'category_record.g.dart';

abstract class CategoryRecord
    implements Built<CategoryRecord, CategoryRecordBuilder> {
  // fields go here
  static Serializer<CategoryRecord> get serializer =>
      _$categoryRecordSerializer;

  @BuiltValueField(wireName: 'category_name')
  String? get categoryName;

  @BuiltValueField(wireName: 'image')
  String? get image;

  @BuiltValueField(wireName: 'display_at_home')
  bool? get displayAtHome;

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
      FirebaseFirestore.instance.collection('categories');

  static Stream<CategoryRecord> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  static Future<CategoryRecord> getDocumentOnce(DocumentReference ref) => ref
      .get()
      .then((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  static void _initializeBuilder(CategoryRecordBuilder builder) =>
      builder..categoryName = '';

  CategoryRecord._();

  factory CategoryRecord([updates(CategoryRecordBuilder b)]) = _$CategoryRecord;
}

Map<String, dynamic> createCategoryRecordData({
  String? categoryName,
  String? image,
  bool displayAtHome = false,
  DateTime? createdAt,
  DateTime? modifiedAt,
  DocumentReference? createdBy,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'category_name': categoryName,
      'image': image,
      'display_at_home': displayAtHome,
      'created_at': createdAt,
      'modified_at': modifiedAt,
      'created_by': createdBy,
    },
  ).withoutNulls;

  return firestoreData;
}
