// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_details_record.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<OrderDetailsRecord> _$orderDetailsRecordSerializer =
    new _$OrderDetailsRecordSerializer();

class _$OrderDetailsRecordSerializer
    implements StructuredSerializer<OrderDetailsRecord> {
  @override
  final Iterable<Type> types = const [OrderDetailsRecord, _$OrderDetailsRecord];
  @override
  final String wireName = 'OrderDetailsRecord';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, OrderDetailsRecord object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.userId;
    if (value != null) {
      result
        ..add('user_id')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(
                DocumentReference, const [const FullType.nullable(Object)])));
    }
    value = object.status;
    if (value != null) {
      result
        ..add('status')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.orderItemsId;
    if (value != null) {
      result
        ..add('order_items_id')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(BuiltList, const [
              const FullType(
                  DocumentReference, const [const FullType.nullable(Object)])
            ])));
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
    value = object.ffRef;
    if (value != null) {
      result
        ..add('Document__Reference__Field')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(
                DocumentReference, const [const FullType.nullable(Object)])));
    }
    return result;
  }

  @override
  OrderDetailsRecord deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new OrderDetailsRecordBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'user_id':
          result.userId = serializers.deserialize(value,
              specifiedType: const FullType(DocumentReference, const [
                const FullType.nullable(Object)
              ])) as DocumentReference<Object?>?;
          break;
        case 'status':
          result.status = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'order_items_id':
          result.orderItemsId.replace(serializers.deserialize(value,
              specifiedType: const FullType(BuiltList, const [
                const FullType(
                    DocumentReference, const [const FullType.nullable(Object)])
              ]))! as BuiltList<Object?>);
          break;
        case 'created_at':
          result.createdAt = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime?;
          break;
        case 'modified_at':
          result.modifiedAt = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime?;
          break;
        case 'Document__Reference__Field':
          result.ffRef = serializers.deserialize(value,
              specifiedType: const FullType(DocumentReference, const [
                const FullType.nullable(Object)
              ])) as DocumentReference<Object?>?;
          break;
      }
    }

    return result.build();
  }
}

class _$OrderDetailsRecord extends OrderDetailsRecord {
  @override
  final DocumentReference<Object?>? userId;
  @override
  final bool? status;
  @override
  final BuiltList<DocumentReference<Object?>>? orderItemsId;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? modifiedAt;
  @override
  final DocumentReference<Object?>? ffRef;

  factory _$OrderDetailsRecord(
          [void Function(OrderDetailsRecordBuilder)? updates]) =>
      (new OrderDetailsRecordBuilder()..update(updates))._build();

  _$OrderDetailsRecord._(
      {this.userId,
      this.status,
      this.orderItemsId,
      this.createdAt,
      this.modifiedAt,
      this.ffRef})
      : super._();

  @override
  OrderDetailsRecord rebuild(
          void Function(OrderDetailsRecordBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  OrderDetailsRecordBuilder toBuilder() =>
      new OrderDetailsRecordBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OrderDetailsRecord &&
        userId == other.userId &&
        status == other.status &&
        orderItemsId == other.orderItemsId &&
        createdAt == other.createdAt &&
        modifiedAt == other.modifiedAt &&
        ffRef == other.ffRef;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, orderItemsId.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, modifiedAt.hashCode);
    _$hash = $jc(_$hash, ffRef.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OrderDetailsRecord')
          ..add('userId', userId)
          ..add('status', status)
          ..add('orderItemsId', orderItemsId)
          ..add('createdAt', createdAt)
          ..add('modifiedAt', modifiedAt)
          ..add('ffRef', ffRef))
        .toString();
  }
}

class OrderDetailsRecordBuilder
    implements Builder<OrderDetailsRecord, OrderDetailsRecordBuilder> {
  _$OrderDetailsRecord? _$v;

  DocumentReference<Object?>? _userId;
  DocumentReference<Object?>? get userId => _$this._userId;
  set userId(DocumentReference<Object?>? userId) => _$this._userId = userId;

  bool? _status;
  bool? get status => _$this._status;
  set status(bool? status) => _$this._status = status;

  ListBuilder<DocumentReference<Object?>>? _orderItemsId;
  ListBuilder<DocumentReference<Object?>> get orderItemsId =>
      _$this._orderItemsId ??= new ListBuilder<DocumentReference<Object?>>();
  set orderItemsId(ListBuilder<DocumentReference<Object?>>? orderItemsId) =>
      _$this._orderItemsId = orderItemsId;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _modifiedAt;
  DateTime? get modifiedAt => _$this._modifiedAt;
  set modifiedAt(DateTime? modifiedAt) => _$this._modifiedAt = modifiedAt;

  DocumentReference<Object?>? _ffRef;
  DocumentReference<Object?>? get ffRef => _$this._ffRef;
  set ffRef(DocumentReference<Object?>? ffRef) => _$this._ffRef = ffRef;

  OrderDetailsRecordBuilder() {
    OrderDetailsRecord._initializeBuilder(this);
  }

  OrderDetailsRecordBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _userId = $v.userId;
      _status = $v.status;
      _orderItemsId = $v.orderItemsId?.toBuilder();
      _createdAt = $v.createdAt;
      _modifiedAt = $v.modifiedAt;
      _ffRef = $v.ffRef;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OrderDetailsRecord other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$OrderDetailsRecord;
  }

  @override
  void update(void Function(OrderDetailsRecordBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OrderDetailsRecord build() => _build();

  _$OrderDetailsRecord _build() {
    _$OrderDetailsRecord _$result;
    try {
      _$result = _$v ??
          new _$OrderDetailsRecord._(
              userId: userId,
              status: status,
              orderItemsId: _orderItemsId?.build(),
              createdAt: createdAt,
              modifiedAt: modifiedAt,
              ffRef: ffRef);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'orderItemsId';
        _orderItemsId?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'OrderDetailsRecord', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
