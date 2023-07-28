import 'dart:ui';

import 'package:blueraymarket/backend/schema/serializers.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'variant_record.g.dart';

abstract class VariantRecord
    implements Built<VariantRecord, VariantRecordBuilder> {
  static Serializer<VariantRecord> get serializer => _$variantRecordSerializer;
  // fields go here
  @BuiltValueField(wireName: 'quantity')
  int? get quantity;

  @BuiltValueField(wireName: 'color_code')
  Color? get colorCode;

  @BuiltValueField(wireName: 'id_color')
  DocumentReference? get idColor;

  @BuiltValueField(wireName: 'size_code')
  String? get sizeCode;

  @BuiltValueField(wireName: 'id_size')
  DocumentReference? get idSize;

  @BuiltValueField(wireName: 'id_feature')
  DocumentReference? get idFeature;

  @BuiltValueField(wireName: 'images')
  BuiltList<String>? get images;

  @BuiltValueField(wireName: 'created_at')
  DateTime? get createdAt;

  @BuiltValueField(wireName: 'modified_at')
  DateTime? get modifiedAt;

  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference? get ffRef;
  DocumentReference get reference => ffRef!;

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('variants')
          : FirebaseFirestore.instance.collectionGroup('variants');

  static DocumentReference createDoc(DocumentReference parent) =>
      parent.collection('variants').doc();

  static Stream<VariantRecord> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  static Future<VariantRecord> getDocumentOnce(DocumentReference ref) => ref
      .get()
      .then((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  static void _initializeBuilder(VariantRecordBuilder builder) =>
      builder..quantity = 0;

  VariantRecord._();

  factory VariantRecord([updates(VariantRecordBuilder b)]) = _$VariantRecord;
}

Map<String, dynamic> createVariantRecordData({
  int? quantity,
  ListBuilder<String>? images,
  Color? colorCode,
  Size? sizeCode,
  DocumentReference? idColor,
  DocumentReference? idSize,
  DateTime? createdAt,
  DateTime? modifiedAt,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'quantity': quantity,
      'color_code': colorCode,
      'id_color': idColor,
      'size_code': sizeCode,
      'id_size': idSize,
      'images': images,
      'created_at': createdAt,
      'modified_at': modifiedAt,
    },
  ).withoutNulls;

  return firestoreData;
}
