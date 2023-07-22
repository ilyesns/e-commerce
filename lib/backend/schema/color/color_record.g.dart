// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'color_record.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ColorRecord> _$colorRecordSerializer = new _$ColorRecordSerializer();

class _$ColorRecordSerializer implements StructuredSerializer<ColorRecord> {
  @override
  final Iterable<Type> types = const [ColorRecord, _$ColorRecord];
  @override
  final String wireName = 'ColorRecord';

  @override
  Iterable<Object?> serialize(Serializers serializers, ColorRecord object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.colorName;
    if (value != null) {
      result
        ..add('color_name')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.colorCode;
    if (value != null) {
      result
        ..add('color_code')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(Color)));
    }
    return result;
  }

  @override
  ColorRecord deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ColorRecordBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'color_name':
          result.colorName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'color_code':
          result.colorCode = serializers.deserialize(value,
              specifiedType: const FullType(Color)) as Color?;
          break;
      }
    }

    return result.build();
  }
}

class _$ColorRecord extends ColorRecord {
  @override
  final String? colorName;
  @override
  final Color? colorCode;

  factory _$ColorRecord([void Function(ColorRecordBuilder)? updates]) =>
      (new ColorRecordBuilder()..update(updates))._build();

  _$ColorRecord._({this.colorName, this.colorCode}) : super._();

  @override
  ColorRecord rebuild(void Function(ColorRecordBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ColorRecordBuilder toBuilder() => new ColorRecordBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ColorRecord &&
        colorName == other.colorName &&
        colorCode == other.colorCode;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, colorName.hashCode);
    _$hash = $jc(_$hash, colorCode.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ColorRecord')
          ..add('colorName', colorName)
          ..add('colorCode', colorCode))
        .toString();
  }
}

class ColorRecordBuilder implements Builder<ColorRecord, ColorRecordBuilder> {
  _$ColorRecord? _$v;

  String? _colorName;
  String? get colorName => _$this._colorName;
  set colorName(String? colorName) => _$this._colorName = colorName;

  Color? _colorCode;
  Color? get colorCode => _$this._colorCode;
  set colorCode(Color? colorCode) => _$this._colorCode = colorCode;

  ColorRecordBuilder() {
    ColorRecord._initializeBuilder(this);
  }

  ColorRecordBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _colorName = $v.colorName;
      _colorCode = $v.colorCode;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ColorRecord other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ColorRecord;
  }

  @override
  void update(void Function(ColorRecordBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ColorRecord build() => _build();

  _$ColorRecord _build() {
    final _$result =
        _$v ?? new _$ColorRecord._(colorName: colorName, colorCode: colorCode);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
