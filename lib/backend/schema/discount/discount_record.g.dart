// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discount_record.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<DiscountRecord> _$discountRecordSerializer =
    new _$DiscountRecordSerializer();

class _$DiscountRecordSerializer
    implements StructuredSerializer<DiscountRecord> {
  @override
  final Iterable<Type> types = const [DiscountRecord, _$DiscountRecord];
  @override
  final String wireName = 'DiscountRecord';

  @override
  Iterable<Object?> serialize(Serializers serializers, DiscountRecord object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.title;
    if (value != null) {
      result
        ..add('title')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.description;
    if (value != null) {
      result
        ..add('description')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.discountPercent;
    if (value != null) {
      result
        ..add('discount_percent')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(double)));
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
    value = object.startedAt;
    if (value != null) {
      result
        ..add('started_at')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(DateTime)));
    }
    value = object.endAt;
    if (value != null) {
      result
        ..add('end_at')
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
  DiscountRecord deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new DiscountRecordBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'title':
          result.title = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'description':
          result.description = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'discount_percent':
          result.discountPercent = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double?;
          break;
        case 'image':
          result.image = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'created_at':
          result.createdAt = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime?;
          break;
        case 'started_at':
          result.startedAt = serializers.deserialize(value,
              specifiedType: const FullType(DateTime)) as DateTime?;
          break;
        case 'end_at':
          result.endAt = serializers.deserialize(value,
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

class _$DiscountRecord extends DiscountRecord {
  @override
  final String? title;
  @override
  final String? description;
  @override
  final double? discountPercent;
  @override
  final String? image;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? startedAt;
  @override
  final DateTime? endAt;
  @override
  final DateTime? modifiedAt;

  factory _$DiscountRecord([void Function(DiscountRecordBuilder)? updates]) =>
      (new DiscountRecordBuilder()..update(updates))._build();

  _$DiscountRecord._(
      {this.title,
      this.description,
      this.discountPercent,
      this.image,
      this.createdAt,
      this.startedAt,
      this.endAt,
      this.modifiedAt})
      : super._();

  @override
  DiscountRecord rebuild(void Function(DiscountRecordBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DiscountRecordBuilder toBuilder() =>
      new DiscountRecordBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DiscountRecord &&
        title == other.title &&
        description == other.description &&
        discountPercent == other.discountPercent &&
        image == other.image &&
        createdAt == other.createdAt &&
        startedAt == other.startedAt &&
        endAt == other.endAt &&
        modifiedAt == other.modifiedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, discountPercent.hashCode);
    _$hash = $jc(_$hash, image.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, startedAt.hashCode);
    _$hash = $jc(_$hash, endAt.hashCode);
    _$hash = $jc(_$hash, modifiedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DiscountRecord')
          ..add('title', title)
          ..add('description', description)
          ..add('discountPercent', discountPercent)
          ..add('image', image)
          ..add('createdAt', createdAt)
          ..add('startedAt', startedAt)
          ..add('endAt', endAt)
          ..add('modifiedAt', modifiedAt))
        .toString();
  }
}

class DiscountRecordBuilder
    implements Builder<DiscountRecord, DiscountRecordBuilder> {
  _$DiscountRecord? _$v;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  double? _discountPercent;
  double? get discountPercent => _$this._discountPercent;
  set discountPercent(double? discountPercent) =>
      _$this._discountPercent = discountPercent;

  String? _image;
  String? get image => _$this._image;
  set image(String? image) => _$this._image = image;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _startedAt;
  DateTime? get startedAt => _$this._startedAt;
  set startedAt(DateTime? startedAt) => _$this._startedAt = startedAt;

  DateTime? _endAt;
  DateTime? get endAt => _$this._endAt;
  set endAt(DateTime? endAt) => _$this._endAt = endAt;

  DateTime? _modifiedAt;
  DateTime? get modifiedAt => _$this._modifiedAt;
  set modifiedAt(DateTime? modifiedAt) => _$this._modifiedAt = modifiedAt;

  DiscountRecordBuilder() {
    DiscountRecord._initializeBuilder(this);
  }

  DiscountRecordBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _title = $v.title;
      _description = $v.description;
      _discountPercent = $v.discountPercent;
      _image = $v.image;
      _createdAt = $v.createdAt;
      _startedAt = $v.startedAt;
      _endAt = $v.endAt;
      _modifiedAt = $v.modifiedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DiscountRecord other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$DiscountRecord;
  }

  @override
  void update(void Function(DiscountRecordBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DiscountRecord build() => _build();

  _$DiscountRecord _build() {
    final _$result = _$v ??
        new _$DiscountRecord._(
            title: title,
            description: description,
            discountPercent: discountPercent,
            image: image,
            createdAt: createdAt,
            startedAt: startedAt,
            endAt: endAt,
            modifiedAt: modifiedAt);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
