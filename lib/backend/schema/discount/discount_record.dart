import 'package:blueraymarket/backend/schema/serializers.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'discount_record.g.dart';

abstract class DiscountRecord
    implements Built<DiscountRecord, DiscountRecordBuilder> {
  static Serializer<DiscountRecord> get serializer =>
      _$discountRecordSerializer;
  // fields go here

  // fields go here
  @BuiltValueField(wireName: 'title')
  String? get title;

  @BuiltValueField(wireName: 'description')
  String? get description;

  @BuiltValueField(wireName: 'discount_percent')
  double? get discountPercent;

  @BuiltValueField(wireName: 'image')
  String? get image;

  @BuiltValueField(wireName: 'created_at')
  DateTime? get createdAt;

  @BuiltValueField(wireName: 'started_at')
  DateTime? get startedAt;

  @BuiltValueField(wireName: 'end_at')
  DateTime? get endAt;

  @BuiltValueField(wireName: 'modified_at')
  DateTime? get modifiedAt;

  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference? get ffRef;
  DocumentReference get reference => ffRef!;
  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('discounts');

  static Stream<DiscountRecord> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  static Future<DiscountRecord> getDocumentOnce(DocumentReference ref) => ref
      .get()
      .then((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  static void _initializeBuilder(DiscountRecordBuilder builder) => builder
    ..title = ''
    ..description = ''
    ..discountPercent = 0.0
    ..image = '';

  DiscountRecord._();

  factory DiscountRecord([updates(DiscountRecordBuilder b)]) = _$DiscountRecord;
}

Map<String, dynamic> createDiscountRecordData({
  String? title,
  ListBuilder<String>? description,
  double? discountPercent,
  String? image,
  DateTime? createdAt,
  DateTime? startedAt,
  DateTime? endAt,
  DateTime? modifiedAt,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'title': title,
      'description': description,
      'discount_percent': discountPercent,
      'image': image,
      'created_at': createdAt,
      'started_at': startedAt,
      'end_at': endAt,
      'modified_at': modifiedAt,
    },
  ).withoutNulls;

  return firestoreData;
}
