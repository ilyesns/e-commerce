// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feature_record.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<FeatureRecord> _$featureRecordSerializer =
    new _$FeatureRecordSerializer();

class _$FeatureRecordSerializer implements StructuredSerializer<FeatureRecord> {
  @override
  final Iterable<Type> types = const [FeatureRecord, _$FeatureRecord];
  @override
  final String wireName = 'FeatureRecord';

  @override
  Iterable<Object?> serialize(Serializers serializers, FeatureRecord object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.geometry;
    if (value != null) {
      result
        ..add('geometry')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.weight;
    if (value != null) {
      result
        ..add('weight')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.type;
    if (value != null) {
      result
        ..add('type')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.name;
    if (value != null) {
      result
        ..add('name')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
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
  FeatureRecord deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new FeatureRecordBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'geometry':
          result.geometry = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'weight':
          result.weight = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'type':
          result.type = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
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

class _$FeatureRecord extends FeatureRecord {
  @override
  final String? geometry;
  @override
  final String? weight;
  @override
  final String? type;
  @override
  final String? name;
  @override
  final DocumentReference<Object?>? ffRef;

  factory _$FeatureRecord([void Function(FeatureRecordBuilder)? updates]) =>
      (new FeatureRecordBuilder()..update(updates))._build();

  _$FeatureRecord._(
      {this.geometry, this.weight, this.type, this.name, this.ffRef})
      : super._();

  @override
  FeatureRecord rebuild(void Function(FeatureRecordBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FeatureRecordBuilder toBuilder() => new FeatureRecordBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FeatureRecord &&
        geometry == other.geometry &&
        weight == other.weight &&
        type == other.type &&
        name == other.name &&
        ffRef == other.ffRef;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, geometry.hashCode);
    _$hash = $jc(_$hash, weight.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, ffRef.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FeatureRecord')
          ..add('geometry', geometry)
          ..add('weight', weight)
          ..add('type', type)
          ..add('name', name)
          ..add('ffRef', ffRef))
        .toString();
  }
}

class FeatureRecordBuilder
    implements Builder<FeatureRecord, FeatureRecordBuilder> {
  _$FeatureRecord? _$v;

  String? _geometry;
  String? get geometry => _$this._geometry;
  set geometry(String? geometry) => _$this._geometry = geometry;

  String? _weight;
  String? get weight => _$this._weight;
  set weight(String? weight) => _$this._weight = weight;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  DocumentReference<Object?>? _ffRef;
  DocumentReference<Object?>? get ffRef => _$this._ffRef;
  set ffRef(DocumentReference<Object?>? ffRef) => _$this._ffRef = ffRef;

  FeatureRecordBuilder() {
    FeatureRecord._initializeBuilder(this);
  }

  FeatureRecordBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _geometry = $v.geometry;
      _weight = $v.weight;
      _type = $v.type;
      _name = $v.name;
      _ffRef = $v.ffRef;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FeatureRecord other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$FeatureRecord;
  }

  @override
  void update(void Function(FeatureRecordBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FeatureRecord build() => _build();

  _$FeatureRecord _build() {
    final _$result = _$v ??
        new _$FeatureRecord._(
            geometry: geometry,
            weight: weight,
            type: type,
            name: name,
            ffRef: ffRef);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
