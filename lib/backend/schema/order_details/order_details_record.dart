import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../serializers.dart';

part 'order_details_record.g.dart';

abstract class OrderDetailsRecord
    implements Built<OrderDetailsRecord, OrderDetailsRecordBuilder> {
  // fields go here

  static Serializer<OrderDetailsRecord> get serializer =>
      _$orderDetailsRecordSerializer;

  @BuiltValueField(wireName: 'user_id')
  DocumentReference? get userId;

  @BuiltValueField(wireName: 'status')
  bool? get status;

  @BuiltValueField(wireName: 'order_items_id')
  BuiltList<DocumentReference>? get orderItemsId;

  @BuiltValueField(wireName: 'created_at')
  DateTime? get createdAt;

  @BuiltValueField(wireName: 'modified_at')
  DateTime? get modifiedAt;

  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference? get ffRef;
  DocumentReference get reference => ffRef!;

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('order_details');

  static Stream<OrderDetailsRecord> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  static Future<OrderDetailsRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then(
          (s) => serializers.deserializeWith(serializer, serializedData(s))!);

  static void _initializeBuilder(OrderDetailsRecordBuilder builder) =>
      builder..status = false;

  OrderDetailsRecord._();

  factory OrderDetailsRecord([updates(OrderDetailsRecordBuilder b)]) =
      _$OrderDetailsRecord;
}

Map<String, dynamic> createOrderItemRecordData({
  DocumentReference? userId,
  bool? status,
  ListBuilder<DocumentReference>? orderItemsId,
  DateTime? createdAt,
  DateTime? modifiedAt,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'user_id': userId,
      'status': status,
      'order_items_id': orderItemsId,
      'created_at': createdAt,
      'modified_at': modifiedAt,
    },
  ).withoutNulls;

  return firestoreData;
}
