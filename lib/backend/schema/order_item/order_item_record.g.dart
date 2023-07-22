// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item_record.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<OrderItemRecord> _$orderItemRecordSerializer =
    new _$OrderItemRecordSerializer();

class _$OrderItemRecordSerializer
    implements StructuredSerializer<OrderItemRecord> {
  @override
  final Iterable<Type> types = const [OrderItemRecord, _$OrderItemRecord];
  @override
  final String wireName = 'OrderItemRecord';

  @override
  Iterable<Object?> serialize(Serializers serializers, OrderItemRecord object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.productTitle;
    if (value != null) {
      result
        ..add('product_title')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.quantityOrder;
    if (value != null) {
      result
        ..add('quantity_order')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.discountPercent;
    if (value != null) {
      result
        ..add('discount_percent')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(double)));
    }
    value = object.createdAt;
    if (value != null) {
      result
        ..add('created_at')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(DateTime)));
    }
    value = object.modifiedAt;
    if (value != null) {
      result
        ..add('modified_at')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(DateTime)));
    }
    value = object.variantOrder;
    if (value != null) {
      result
        ..add('variant_order')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(
                DocumentReference, const [const FullType.nullable(Object)])));
    }
    value = object.productId;
    if (value != null) {
      result
        ..add('product_id')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(
                DocumentReference, const [const FullType.nullable(Object)])));
    }
    value = object.userId;
    if (value != null) {
      result
        ..add('user_id')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(
                DocumentReference, const [const FullType.nullable(Object)])));
    }
    value = object.orderDetailsId;
    if (value != null) {
      result
        ..add('order_details_id')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(
                DocumentReference, const [const FullType.nullable(Object)])));
    }
    return result;
  }

  @override
  OrderItemRecord deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new OrderItemRecordBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'product_title':
          result.productTitle = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'quantity_order':
          result.quantityOrder = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'discount_percent':
          result.discountPercent = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double?;
          break;
        case 'created_at':
          result.createdAt = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime?;
          break;
        case 'modified_at':
          result.modifiedAt = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime?;
          break;
        case 'variant_order':
          result.variantOrder = serializers.deserialize(value,
              specifiedType: const FullType(DocumentReference, const [
                const FullType.nullable(Object)
              ])) as DocumentReference<Object?>?;
          break;
        case 'product_id':
          result.productId = serializers.deserialize(value,
              specifiedType: const FullType(DocumentReference, const [
                const FullType.nullable(Object)
              ])) as DocumentReference<Object?>?;
          break;
        case 'user_id':
          result.userId = serializers.deserialize(value,
              specifiedType: const FullType(DocumentReference, const [
                const FullType.nullable(Object)
              ])) as DocumentReference<Object?>?;
          break;
        case 'order_details_id':
          result.orderDetailsId = serializers.deserialize(value,
              specifiedType: const FullType(DocumentReference, const [
                const FullType.nullable(Object)
              ])) as DocumentReference<Object?>?;
          break;
      }
    }

    return result.build();
  }
}

class _$OrderItemRecord extends OrderItemRecord {
  @override
  final String? productTitle;
  @override
  final int? quantityOrder;
  @override
  final double? discountPercent;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? modifiedAt;
  @override
  final DocumentReference<Object?>? variantOrder;
  @override
  final DocumentReference<Object?>? productId;
  @override
  final DocumentReference<Object?>? userId;
  @override
  final DocumentReference<Object?>? orderDetailsId;

  factory _$OrderItemRecord([void Function(OrderItemRecordBuilder)? updates]) =>
      (new OrderItemRecordBuilder()..update(updates))._build();

  _$OrderItemRecord._(
      {this.productTitle,
      this.quantityOrder,
      this.discountPercent,
      this.createdAt,
      this.modifiedAt,
      this.variantOrder,
      this.productId,
      this.userId,
      this.orderDetailsId})
      : super._();

  @override
  OrderItemRecord rebuild(void Function(OrderItemRecordBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OrderItemRecordBuilder toBuilder() =>
      new OrderItemRecordBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OrderItemRecord &&
        productTitle == other.productTitle &&
        quantityOrder == other.quantityOrder &&
        discountPercent == other.discountPercent &&
        createdAt == other.createdAt &&
        modifiedAt == other.modifiedAt &&
        variantOrder == other.variantOrder &&
        productId == other.productId &&
        userId == other.userId &&
        orderDetailsId == other.orderDetailsId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, productTitle.hashCode);
    _$hash = $jc(_$hash, quantityOrder.hashCode);
    _$hash = $jc(_$hash, discountPercent.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, modifiedAt.hashCode);
    _$hash = $jc(_$hash, variantOrder.hashCode);
    _$hash = $jc(_$hash, productId.hashCode);
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, orderDetailsId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OrderItemRecord')
          ..add('productTitle', productTitle)
          ..add('quantityOrder', quantityOrder)
          ..add('discountPercent', discountPercent)
          ..add('createdAt', createdAt)
          ..add('modifiedAt', modifiedAt)
          ..add('variantOrder', variantOrder)
          ..add('productId', productId)
          ..add('userId', userId)
          ..add('orderDetailsId', orderDetailsId))
        .toString();
  }
}

class OrderItemRecordBuilder
    implements Builder<OrderItemRecord, OrderItemRecordBuilder> {
  _$OrderItemRecord? _$v;

  String? _productTitle;
  String? get productTitle => _$this._productTitle;
  set productTitle(String? productTitle) => _$this._productTitle = productTitle;

  int? _quantityOrder;
  int? get quantityOrder => _$this._quantityOrder;
  set quantityOrder(int? quantityOrder) =>
      _$this._quantityOrder = quantityOrder;

  double? _discountPercent;
  double? get discountPercent => _$this._discountPercent;
  set discountPercent(double? discountPercent) =>
      _$this._discountPercent = discountPercent;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _modifiedAt;
  DateTime? get modifiedAt => _$this._modifiedAt;
  set modifiedAt(DateTime? modifiedAt) => _$this._modifiedAt = modifiedAt;

  DocumentReference<Object?>? _variantOrder;
  DocumentReference<Object?>? get variantOrder => _$this._variantOrder;
  set variantOrder(DocumentReference<Object?>? variantOrder) =>
      _$this._variantOrder = variantOrder;

  DocumentReference<Object?>? _productId;
  DocumentReference<Object?>? get productId => _$this._productId;
  set productId(DocumentReference<Object?>? productId) =>
      _$this._productId = productId;

  DocumentReference<Object?>? _userId;
  DocumentReference<Object?>? get userId => _$this._userId;
  set userId(DocumentReference<Object?>? userId) => _$this._userId = userId;

  DocumentReference<Object?>? _orderDetailsId;
  DocumentReference<Object?>? get orderDetailsId => _$this._orderDetailsId;
  set orderDetailsId(DocumentReference<Object?>? orderDetailsId) =>
      _$this._orderDetailsId = orderDetailsId;

  OrderItemRecordBuilder() {
    OrderItemRecord._initializeBuilder(this);
  }

  OrderItemRecordBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _productTitle = $v.productTitle;
      _quantityOrder = $v.quantityOrder;
      _discountPercent = $v.discountPercent;
      _createdAt = $v.createdAt;
      _modifiedAt = $v.modifiedAt;
      _variantOrder = $v.variantOrder;
      _productId = $v.productId;
      _userId = $v.userId;
      _orderDetailsId = $v.orderDetailsId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OrderItemRecord other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$OrderItemRecord;
  }

  @override
  void update(void Function(OrderItemRecordBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OrderItemRecord build() => _build();

  _$OrderItemRecord _build() {
    final _$result = _$v ??
        new _$OrderItemRecord._(
            productTitle: productTitle,
            quantityOrder: quantityOrder,
            discountPercent: discountPercent,
            createdAt: createdAt,
            modifiedAt: modifiedAt,
            variantOrder: variantOrder,
            productId: productId,
            userId: userId,
            orderDetailsId: orderDetailsId);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
