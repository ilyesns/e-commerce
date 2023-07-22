// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand_record.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<BrandRecord> _$brandRecordSerializer = new _$BrandRecordSerializer();

class _$BrandRecordSerializer implements StructuredSerializer<BrandRecord> {
  @override
  final Iterable<Type> types = const [BrandRecord, _$BrandRecord];
  @override
  final String wireName = 'BrandRecord';

  @override
  Iterable<Object?> serialize(Serializers serializers, BrandRecord object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.brandName;
    if (value != null) {
      result
        ..add('brand_name')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.image;
    if (value != null) {
      result
        ..add('image')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
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
    value = object.createdBy;
    if (value != null) {
      result
        ..add('created_by')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(
                DocumentReference, const [const FullType.nullable(Object)])));
    }
    return result;
  }

  @override
  BrandRecord deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new BrandRecordBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'brand_name':
          result.brandName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'image':
          result.image = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'created_at':
          result.createdAt = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime?;
          break;
        case 'modified_at':
          result.modifiedAt = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime?;
          break;
        case 'created_by':
          result.createdBy = serializers.deserialize(value,
              specifiedType: const FullType(DocumentReference, const [
                const FullType.nullable(Object)
              ])) as DocumentReference<Object?>?;
          break;
      }
    }

    return result.build();
  }
}

class _$BrandRecord extends BrandRecord {
  @override
  final String? brandName;
  @override
  final String? image;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? modifiedAt;
  @override
  final DocumentReference<Object?>? createdBy;

  factory _$BrandRecord([void Function(BrandRecordBuilder)? updates]) =>
      (new BrandRecordBuilder()..update(updates))._build();

  _$BrandRecord._(
      {this.brandName,
      this.image,
      this.createdAt,
      this.modifiedAt,
      this.createdBy})
      : super._();

  @override
  BrandRecord rebuild(void Function(BrandRecordBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BrandRecordBuilder toBuilder() => new BrandRecordBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BrandRecord &&
        brandName == other.brandName &&
        image == other.image &&
        createdAt == other.createdAt &&
        modifiedAt == other.modifiedAt &&
        createdBy == other.createdBy;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, brandName.hashCode);
    _$hash = $jc(_$hash, image.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, modifiedAt.hashCode);
    _$hash = $jc(_$hash, createdBy.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BrandRecord')
          ..add('brandName', brandName)
          ..add('image', image)
          ..add('createdAt', createdAt)
          ..add('modifiedAt', modifiedAt)
          ..add('createdBy', createdBy))
        .toString();
  }
}

class BrandRecordBuilder implements Builder<BrandRecord, BrandRecordBuilder> {
  _$BrandRecord? _$v;

  String? _brandName;
  String? get brandName => _$this._brandName;
  set brandName(String? brandName) => _$this._brandName = brandName;

  String? _image;
  String? get image => _$this._image;
  set image(String? image) => _$this._image = image;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _modifiedAt;
  DateTime? get modifiedAt => _$this._modifiedAt;
  set modifiedAt(DateTime? modifiedAt) => _$this._modifiedAt = modifiedAt;

  DocumentReference<Object?>? _createdBy;
  DocumentReference<Object?>? get createdBy => _$this._createdBy;
  set createdBy(DocumentReference<Object?>? createdBy) =>
      _$this._createdBy = createdBy;

  BrandRecordBuilder() {
    BrandRecord._initializeBuilder(this);
  }

  BrandRecordBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _brandName = $v.brandName;
      _image = $v.image;
      _createdAt = $v.createdAt;
      _modifiedAt = $v.modifiedAt;
      _createdBy = $v.createdBy;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BrandRecord other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$BrandRecord;
  }

  @override
  void update(void Function(BrandRecordBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BrandRecord build() => _build();

  _$BrandRecord _build() {
    final _$result = _$v ??
        new _$BrandRecord._(
            brandName: brandName,
            image: image,
            createdAt: createdAt,
            modifiedAt: modifiedAt,
            createdBy: createdBy);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
