// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'size_record.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<SizeRecord> _$sizeRecordSerializer = new _$SizeRecordSerializer();

class _$SizeRecordSerializer implements StructuredSerializer<SizeRecord> {
  @override
  final Iterable<Type> types = const [SizeRecord, _$SizeRecord];
  @override
  final String wireName = 'SizeRecord';

  @override
  Iterable<Object?> serialize(Serializers serializers, SizeRecord object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.sizeCode;
    if (value != null) {
      result
        ..add('size_code')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  SizeRecord deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new SizeRecordBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'size_code':
          result.sizeCode = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$SizeRecord extends SizeRecord {
  @override
  final String? sizeCode;

  factory _$SizeRecord([void Function(SizeRecordBuilder)? updates]) =>
      (new SizeRecordBuilder()..update(updates))._build();

  _$SizeRecord._({this.sizeCode}) : super._();

  @override
  SizeRecord rebuild(void Function(SizeRecordBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SizeRecordBuilder toBuilder() => new SizeRecordBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SizeRecord && sizeCode == other.sizeCode;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, sizeCode.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SizeRecord')
          ..add('sizeCode', sizeCode))
        .toString();
  }
}

class SizeRecordBuilder implements Builder<SizeRecord, SizeRecordBuilder> {
  _$SizeRecord? _$v;

  String? _sizeCode;
  String? get sizeCode => _$this._sizeCode;
  set sizeCode(String? sizeCode) => _$this._sizeCode = sizeCode;

  SizeRecordBuilder() {
    SizeRecord._initializeBuilder(this);
  }

  SizeRecordBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _sizeCode = $v.sizeCode;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SizeRecord other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$SizeRecord;
  }

  @override
  void update(void Function(SizeRecordBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SizeRecord build() => _build();

  _$SizeRecord _build() {
    final _$result = _$v ?? new _$SizeRecord._(sizeCode: sizeCode);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
