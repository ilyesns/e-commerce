import 'dart:ui';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../serializers.dart';

part 'color_record.g.dart';

abstract class ColorRecord implements Built<ColorRecord, ColorRecordBuilder> {
  // fields go here
  static Serializer<ColorRecord> get serializer => _$colorRecordSerializer;

  @BuiltValueField(wireName: 'color_name')
  String? get colorName;

  @BuiltValueField(wireName: 'color_code')
  Color? get colorCode;

  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference? get ffRef;
  DocumentReference get reference => ffRef!;
  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('colors');

  static Stream<ColorRecord> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  static Future<ColorRecord> getDocumentOnce(DocumentReference ref) => ref
      .get()
      .then((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  static void _initializeBuilder(ColorRecordBuilder builder) =>
      builder..colorName = '';

  ColorRecord._();

  factory ColorRecord([updates(ColorRecordBuilder b)]) = _$ColorRecord;
}

Map<String, dynamic> createColorRecordData(
    {String? colorName, Color? colorCode}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'color_name': colorName,
      'color_code': colorCode,
    },
  ).withoutNulls;

  return firestoreData;
}
