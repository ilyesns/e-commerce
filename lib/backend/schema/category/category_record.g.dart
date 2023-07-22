// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_record.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<CategoryRecord> _$categoryRecordSerializer =
    new _$CategoryRecordSerializer();

class _$CategoryRecordSerializer
    implements StructuredSerializer<CategoryRecord> {
  @override
  final Iterable<Type> types = const [CategoryRecord, _$CategoryRecord];
  @override
  final String wireName = 'CategoryRecord';

  @override
  Iterable<Object?> serialize(Serializers serializers, CategoryRecord object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.categoryName;
    if (value != null) {
      result
        ..add('category_name')
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
  CategoryRecord deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new CategoryRecordBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'category_name':
          result.categoryName = serializers.deserialize(value,
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

class _$CategoryRecord extends CategoryRecord {
  @override
  final String? categoryName;
  @override
  final String? image;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? modifiedAt;
  @override
  final DocumentReference<Object?>? createdBy;

  factory _$CategoryRecord([void Function(CategoryRecordBuilder)? updates]) =>
      (new CategoryRecordBuilder()..update(updates))._build();

  _$CategoryRecord._(
      {this.categoryName,
      this.image,
      this.createdAt,
      this.modifiedAt,
      this.createdBy})
      : super._();

  @override
  CategoryRecord rebuild(void Function(CategoryRecordBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CategoryRecordBuilder toBuilder() =>
      new CategoryRecordBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CategoryRecord &&
        categoryName == other.categoryName &&
        image == other.image &&
        createdAt == other.createdAt &&
        modifiedAt == other.modifiedAt &&
        createdBy == other.createdBy;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, categoryName.hashCode);
    _$hash = $jc(_$hash, image.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, modifiedAt.hashCode);
    _$hash = $jc(_$hash, createdBy.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CategoryRecord')
          ..add('categoryName', categoryName)
          ..add('image', image)
          ..add('createdAt', createdAt)
          ..add('modifiedAt', modifiedAt)
          ..add('createdBy', createdBy))
        .toString();
  }
}

class CategoryRecordBuilder
    implements Builder<CategoryRecord, CategoryRecordBuilder> {
  _$CategoryRecord? _$v;

  String? _categoryName;
  String? get categoryName => _$this._categoryName;
  set categoryName(String? categoryName) => _$this._categoryName = categoryName;

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

  CategoryRecordBuilder() {
    CategoryRecord._initializeBuilder(this);
  }

  CategoryRecordBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _categoryName = $v.categoryName;
      _image = $v.image;
      _createdAt = $v.createdAt;
      _modifiedAt = $v.modifiedAt;
      _createdBy = $v.createdBy;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CategoryRecord other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$CategoryRecord;
  }

  @override
  void update(void Function(CategoryRecordBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CategoryRecord build() => _build();

  _$CategoryRecord _build() {
    final _$result = _$v ??
        new _$CategoryRecord._(
            categoryName: categoryName,
            image: image,
            createdAt: createdAt,
            modifiedAt: modifiedAt,
            createdBy: createdBy);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
