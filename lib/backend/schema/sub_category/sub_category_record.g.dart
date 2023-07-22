// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sub_category_record.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<SubCategoryRecord> _$subCategoryRecordSerializer =
    new _$SubCategoryRecordSerializer();

class _$SubCategoryRecordSerializer
    implements StructuredSerializer<SubCategoryRecord> {
  @override
  final Iterable<Type> types = const [SubCategoryRecord, _$SubCategoryRecord];
  @override
  final String wireName = 'SubCategoryRecord';

  @override
  Iterable<Object?> serialize(Serializers serializers, SubCategoryRecord object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.subCategoryName;
    if (value != null) {
      result
        ..add('sub_category_name')
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
  SubCategoryRecord deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new SubCategoryRecordBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'sub_category_name':
          result.subCategoryName = serializers.deserialize(value,
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

class _$SubCategoryRecord extends SubCategoryRecord {
  @override
  final String? subCategoryName;
  @override
  final String? image;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? modifiedAt;
  @override
  final DocumentReference<Object?>? createdBy;

  factory _$SubCategoryRecord(
          [void Function(SubCategoryRecordBuilder)? updates]) =>
      (new SubCategoryRecordBuilder()..update(updates))._build();

  _$SubCategoryRecord._(
      {this.subCategoryName,
      this.image,
      this.createdAt,
      this.modifiedAt,
      this.createdBy})
      : super._();

  @override
  SubCategoryRecord rebuild(void Function(SubCategoryRecordBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SubCategoryRecordBuilder toBuilder() =>
      new SubCategoryRecordBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SubCategoryRecord &&
        subCategoryName == other.subCategoryName &&
        image == other.image &&
        createdAt == other.createdAt &&
        modifiedAt == other.modifiedAt &&
        createdBy == other.createdBy;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, subCategoryName.hashCode);
    _$hash = $jc(_$hash, image.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, modifiedAt.hashCode);
    _$hash = $jc(_$hash, createdBy.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SubCategoryRecord')
          ..add('subCategoryName', subCategoryName)
          ..add('image', image)
          ..add('createdAt', createdAt)
          ..add('modifiedAt', modifiedAt)
          ..add('createdBy', createdBy))
        .toString();
  }
}

class SubCategoryRecordBuilder
    implements Builder<SubCategoryRecord, SubCategoryRecordBuilder> {
  _$SubCategoryRecord? _$v;

  String? _subCategoryName;
  String? get subCategoryName => _$this._subCategoryName;
  set subCategoryName(String? subCategoryName) =>
      _$this._subCategoryName = subCategoryName;

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

  SubCategoryRecordBuilder() {
    SubCategoryRecord._initializeBuilder(this);
  }

  SubCategoryRecordBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _subCategoryName = $v.subCategoryName;
      _image = $v.image;
      _createdAt = $v.createdAt;
      _modifiedAt = $v.modifiedAt;
      _createdBy = $v.createdBy;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SubCategoryRecord other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$SubCategoryRecord;
  }

  @override
  void update(void Function(SubCategoryRecordBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SubCategoryRecord build() => _build();

  _$SubCategoryRecord _build() {
    final _$result = _$v ??
        new _$SubCategoryRecord._(
            subCategoryName: subCategoryName,
            image: image,
            createdAt: createdAt,
            modifiedAt: modifiedAt,
            createdBy: createdBy);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
