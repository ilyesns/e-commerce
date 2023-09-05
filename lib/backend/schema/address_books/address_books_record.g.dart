// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_books_record.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<AddressBooksRecord> _$addressBooksRecordSerializer =
    new _$AddressBooksRecordSerializer();

class _$AddressBooksRecordSerializer
    implements StructuredSerializer<AddressBooksRecord> {
  @override
  final Iterable<Type> types = const [AddressBooksRecord, _$AddressBooksRecord];
  @override
  final String wireName = 'AddressBooksRecord';

  @override
  Iterable<Object?> serialize(
      Serializers serializers, AddressBooksRecord object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[];
    Object? value;
    value = object.fullName;
    if (value != null) {
      result
        ..add('full_name')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.streetAddress;
    if (value != null) {
      result
        ..add('street_address')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.city;
    if (value != null) {
      result
        ..add('city')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.state;
    if (value != null) {
      result
        ..add('state')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.postalCode;
    if (value != null) {
      result
        ..add('postal_code')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.country;
    if (value != null) {
      result
        ..add('country')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.phoneNumber;
    if (value != null) {
      result
        ..add('phone_number')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.isDefaultAddress;
    if (value != null) {
      result
        ..add('is_default_address')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.addedAt;
    if (value != null) {
      result
        ..add('added_at')
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
  AddressBooksRecord deserialize(
      Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new AddressBooksRecordBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'full_name':
          result.fullName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'street_address':
          result.streetAddress = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'city':
          result.city = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'state':
          result.state = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'postal_code':
          result.postalCode = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'country':
          result.country = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'phone_number':
          result.phoneNumber = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String?;
          break;
        case 'is_default_address':
          result.isDefaultAddress = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool?;
          break;
        case 'added_at':
          result.addedAt = serializers.deserialize(value,
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

class _$AddressBooksRecord extends AddressBooksRecord {
  @override
  final String? fullName;
  @override
  final String? streetAddress;
  @override
  final String? city;
  @override
  final String? state;
  @override
  final String? postalCode;
  @override
  final String? country;
  @override
  final String? phoneNumber;
  @override
  final bool? isDefaultAddress;
  @override
  final DateTime? addedAt;
  @override
  final DocumentReference<Object?>? ffRef;

  factory _$AddressBooksRecord(
          [void Function(AddressBooksRecordBuilder)? updates]) =>
      (new AddressBooksRecordBuilder()..update(updates))._build();

  _$AddressBooksRecord._(
      {this.fullName,
      this.streetAddress,
      this.city,
      this.state,
      this.postalCode,
      this.country,
      this.phoneNumber,
      this.isDefaultAddress,
      this.addedAt,
      this.ffRef})
      : super._();

  @override
  AddressBooksRecord rebuild(
          void Function(AddressBooksRecordBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AddressBooksRecordBuilder toBuilder() =>
      new AddressBooksRecordBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AddressBooksRecord &&
        fullName == other.fullName &&
        streetAddress == other.streetAddress &&
        city == other.city &&
        state == other.state &&
        postalCode == other.postalCode &&
        country == other.country &&
        phoneNumber == other.phoneNumber &&
        isDefaultAddress == other.isDefaultAddress &&
        addedAt == other.addedAt &&
        ffRef == other.ffRef;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, fullName.hashCode);
    _$hash = $jc(_$hash, streetAddress.hashCode);
    _$hash = $jc(_$hash, city.hashCode);
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, postalCode.hashCode);
    _$hash = $jc(_$hash, country.hashCode);
    _$hash = $jc(_$hash, phoneNumber.hashCode);
    _$hash = $jc(_$hash, isDefaultAddress.hashCode);
    _$hash = $jc(_$hash, addedAt.hashCode);
    _$hash = $jc(_$hash, ffRef.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AddressBooksRecord')
          ..add('fullName', fullName)
          ..add('streetAddress', streetAddress)
          ..add('city', city)
          ..add('state', state)
          ..add('postalCode', postalCode)
          ..add('country', country)
          ..add('phoneNumber', phoneNumber)
          ..add('isDefaultAddress', isDefaultAddress)
          ..add('addedAt', addedAt)
          ..add('ffRef', ffRef))
        .toString();
  }
}

class AddressBooksRecordBuilder
    implements Builder<AddressBooksRecord, AddressBooksRecordBuilder> {
  _$AddressBooksRecord? _$v;

  String? _fullName;
  String? get fullName => _$this._fullName;
  set fullName(String? fullName) => _$this._fullName = fullName;

  String? _streetAddress;
  String? get streetAddress => _$this._streetAddress;
  set streetAddress(String? streetAddress) =>
      _$this._streetAddress = streetAddress;

  String? _city;
  String? get city => _$this._city;
  set city(String? city) => _$this._city = city;

  String? _state;
  String? get state => _$this._state;
  set state(String? state) => _$this._state = state;

  String? _postalCode;
  String? get postalCode => _$this._postalCode;
  set postalCode(String? postalCode) => _$this._postalCode = postalCode;

  String? _country;
  String? get country => _$this._country;
  set country(String? country) => _$this._country = country;

  String? _phoneNumber;
  String? get phoneNumber => _$this._phoneNumber;
  set phoneNumber(String? phoneNumber) => _$this._phoneNumber = phoneNumber;

  bool? _isDefaultAddress;
  bool? get isDefaultAddress => _$this._isDefaultAddress;
  set isDefaultAddress(bool? isDefaultAddress) =>
      _$this._isDefaultAddress = isDefaultAddress;

  DateTime? _addedAt;
  DateTime? get addedAt => _$this._addedAt;
  set addedAt(DateTime? addedAt) => _$this._addedAt = addedAt;

  DocumentReference<Object?>? _ffRef;
  DocumentReference<Object?>? get ffRef => _$this._ffRef;
  set ffRef(DocumentReference<Object?>? ffRef) => _$this._ffRef = ffRef;

  AddressBooksRecordBuilder() {
    AddressBooksRecord._initializeBuilder(this);
  }

  AddressBooksRecordBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _fullName = $v.fullName;
      _streetAddress = $v.streetAddress;
      _city = $v.city;
      _state = $v.state;
      _postalCode = $v.postalCode;
      _country = $v.country;
      _phoneNumber = $v.phoneNumber;
      _isDefaultAddress = $v.isDefaultAddress;
      _addedAt = $v.addedAt;
      _ffRef = $v.ffRef;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AddressBooksRecord other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$AddressBooksRecord;
  }

  @override
  void update(void Function(AddressBooksRecordBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AddressBooksRecord build() => _build();

  _$AddressBooksRecord _build() {
    final _$result = _$v ??
        new _$AddressBooksRecord._(
            fullName: fullName,
            streetAddress: streetAddress,
            city: city,
            state: state,
            postalCode: postalCode,
            country: country,
            phoneNumber: phoneNumber,
            isDefaultAddress: isDefaultAddress,
            addedAt: addedAt,
            ffRef: ffRef);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
