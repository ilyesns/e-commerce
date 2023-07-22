// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'variant_record.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<VariantRecord> _$variantRecordSerializer =
    new _$VariantRecordSerializer();

class _$VariantRecordSerializer implements StructuredSerializer<VariantRecord> {
  @override
  final Iterable<Type> types = const [VariantRecord, _$VariantRecord];
  @override
  final String wireName = 'VariantRecord';

  @override
  Iterable<Object?> serialize(Serializers serializers, VariantRecord object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.quantity;
    if (value != null) {
      result
        ..add('quantity')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.colorCode;
    if (value != null) {
      result
        ..add('color_code')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(Color)));
    }
    value = object.idColor;
    if (value != null) {
      result
        ..add('id_color')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(
                DocumentReference, const [const FullType.nullable(Object)])));
    }
    value = object.sizeCode;
    if (value != null) {
      result
        ..add('size_code')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.idSize;
    if (value != null) {
      result
        ..add('id_size')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(
                DocumentReference, const [const FullType.nullable(Object)])));
    }
    value = object.images;
    if (value != null) {
      result
        ..add('images')
        ..add(serializers.serialize(value,
            specifiedType:
                const FullType(BuiltList, const [const FullType(String)])));
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
    return result;
  }

  @override
  VariantRecord deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new VariantRecordBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'quantity':
          result.quantity = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int?;
          break;
        case 'color_code':
          result.colorCode = serializers.deserialize(value,
              specifiedType: const FullType(Color)) as Color?;
          break;
        case 'id_color':
          result.idColor = serializers.deserialize(value,
              specifiedType: const FullType(DocumentReference, const [
                const FullType.nullable(Object)
              ])) as DocumentReference<Object?>?;
          break;
        case 'size_code':
          result.sizeCode = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'id_size':
          result.idSize = serializers.deserialize(value,
              specifiedType: const FullType(DocumentReference, const [
                const FullType.nullable(Object)
              ])) as DocumentReference<Object?>?;
          break;
        case 'images':
          result.images.replace(serializers.deserialize(value,
                  specifiedType: const FullType(
                      BuiltList, const [const FullType(String)]))!
              as BuiltList<Object?>);
          break;
        case 'created_at':
          result.createdAt = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime?;
          break;
        case 'modified_at':
          result.modifiedAt = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime?;
          break;
      }
    }

    return result.build();
  }
}

class _$VariantRecord extends VariantRecord {
  @override
  final int? quantity;
  @override
  final Color? colorCode;
  @override
  final DocumentReference<Object?>? idColor;
  @override
  final String? sizeCode;
  @override
  final DocumentReference<Object?>? idSize;
  @override
  final BuiltList<String>? images;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? modifiedAt;

  factory _$VariantRecord([void Function(VariantRecordBuilder)? updates]) =>
      (new VariantRecordBuilder()..update(updates))._build();

  _$VariantRecord._(
      {this.quantity,
      this.colorCode,
      this.idColor,
      this.sizeCode,
      this.idSize,
      this.images,
      this.createdAt,
      this.modifiedAt})
      : super._();

  @override
  VariantRecord rebuild(void Function(VariantRecordBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VariantRecordBuilder toBuilder() => new VariantRecordBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VariantRecord &&
        quantity == other.quantity &&
        colorCode == other.colorCode &&
        idColor == other.idColor &&
        sizeCode == other.sizeCode &&
        idSize == other.idSize &&
        images == other.images &&
        createdAt == other.createdAt &&
        modifiedAt == other.modifiedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, quantity.hashCode);
    _$hash = $jc(_$hash, colorCode.hashCode);
    _$hash = $jc(_$hash, idColor.hashCode);
    _$hash = $jc(_$hash, sizeCode.hashCode);
    _$hash = $jc(_$hash, idSize.hashCode);
    _$hash = $jc(_$hash, images.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, modifiedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VariantRecord')
          ..add('quantity', quantity)
          ..add('colorCode', colorCode)
          ..add('idColor', idColor)
          ..add('sizeCode', sizeCode)
          ..add('idSize', idSize)
          ..add('images', images)
          ..add('createdAt', createdAt)
          ..add('modifiedAt', modifiedAt))
        .toString();
  }
}

class VariantRecordBuilder
    implements Builder<VariantRecord, VariantRecordBuilder> {
  _$VariantRecord? _$v;

  int? _quantity;
  int? get quantity => _$this._quantity;
  set quantity(int? quantity) => _$this._quantity = quantity;

  Color? _colorCode;
  Color? get colorCode => _$this._colorCode;
  set colorCode(Color? colorCode) => _$this._colorCode = colorCode;

  DocumentReference<Object?>? _idColor;
  DocumentReference<Object?>? get idColor => _$this._idColor;
  set idColor(DocumentReference<Object?>? idColor) => _$this._idColor = idColor;

  String? _sizeCode;
  String? get sizeCode => _$this._sizeCode;
  set sizeCode(String? sizeCode) => _$this._sizeCode = sizeCode;

  DocumentReference<Object?>? _idSize;
  DocumentReference<Object?>? get idSize => _$this._idSize;
  set idSize(DocumentReference<Object?>? idSize) => _$this._idSize = idSize;

  ListBuilder<String>? _images;
  ListBuilder<String> get images =>
      _$this._images ??= new ListBuilder<String>();
  set images(ListBuilder<String>? images) => _$this._images = images;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _modifiedAt;
  DateTime? get modifiedAt => _$this._modifiedAt;
  set modifiedAt(DateTime? modifiedAt) => _$this._modifiedAt = modifiedAt;

  VariantRecordBuilder() {
    VariantRecord._initializeBuilder(this);
  }

  VariantRecordBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _quantity = $v.quantity;
      _colorCode = $v.colorCode;
      _idColor = $v.idColor;
      _sizeCode = $v.sizeCode;
      _idSize = $v.idSize;
      _images = $v.images?.toBuilder();
      _createdAt = $v.createdAt;
      _modifiedAt = $v.modifiedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VariantRecord other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$VariantRecord;
  }

  @override
  void update(void Function(VariantRecordBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VariantRecord build() => _build();

  _$VariantRecord _build() {
    _$VariantRecord _$result;
    try {
      _$result = _$v ??
          new _$VariantRecord._(
              quantity: quantity,
              colorCode: colorCode,
              idColor: idColor,
              sizeCode: sizeCode,
              idSize: idSize,
              images: _images?.build(),
              createdAt: createdAt,
              modifiedAt: modifiedAt);
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'images';
        _images?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'VariantRecord', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
