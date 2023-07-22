import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../serializers.dart';

part 'order_item_record.g.dart';

abstract class OrderItemRecord
    implements Built<OrderItemRecord, OrderItemRecordBuilder> {
  // fields go here
  static Serializer<OrderItemRecord> get serializer =>
      _$orderItemRecordSerializer;

  @BuiltValueField(wireName: 'product_title')
  String? get productTitle;

  @BuiltValueField(wireName: 'quantity_order')
  int? get quantityOrder;

  @BuiltValueField(wireName: 'discount_percent')
  double? get discountPercent;

  @BuiltValueField(wireName: 'created_at')
  DateTime? get createdAt;

  @BuiltValueField(wireName: 'modified_at')
  DateTime? get modifiedAt;

  @BuiltValueField(wireName: 'variant_order')
  DocumentReference? get variantOrder;

  @BuiltValueField(wireName: 'product_id')
  DocumentReference? get productId;

  @BuiltValueField(wireName: 'user_id')
  DocumentReference? get userId;

  @BuiltValueField(wireName: 'order_details_id')
  DocumentReference? get orderDetailsId;

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('order_items');

  static Stream<OrderItemRecord> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  static Future<OrderItemRecord> getDocumentOnce(DocumentReference ref) => ref
      .get()
      .then((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  static void _initializeBuilder(OrderItemRecordBuilder builder) => builder
    ..productTitle = ''
    ..quantityOrder = 0
    ..discountPercent;

  OrderItemRecord._();

  factory OrderItemRecord([updates(OrderItemRecordBuilder b)]) =
      _$OrderItemRecord;
}

Map<String, dynamic> createOrderItemRecordData({
  String? productTitle,
  int? quantityOrder,
  double? discountPercent,
  DateTime? createdAt,
  DateTime? modifiedAt,
  DocumentReference? variantOrder,
  DocumentReference? productId,
  DocumentReference? userId,
  DocumentReference? orderDetailsId,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'product_title': productTitle,
      'quantity_order': quantityOrder,
      'discount_percent': discountPercent,
      'created_at': createdAt,
      'modified_at': modifiedAt,
      'variant_order': variantOrder,
      'product_id': productId,
      'user_id': userId,
      'order_details_id': orderDetailsId,
    },
  ).withoutNulls;

  return firestoreData;
}
