import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../serializers.dart';

part 'address_books_record.g.dart';

abstract class AddressBooksRecord
    implements Built<AddressBooksRecord, AddressBooksRecordBuilder> {
  static Serializer<AddressBooksRecord> get serializer =>
      _$addressBooksRecordSerializer;
  // fields go here
  @BuiltValueField(wireName: 'full_name')
  String? get fullName;

  @BuiltValueField(wireName: 'street_address')
  String? get streetAddress;

  @BuiltValueField(wireName: 'city')
  String? get city;

  @BuiltValueField(wireName: 'state')
  String? get state;

  @BuiltValueField(wireName: 'postal_code')
  String? get postalCode;

  @BuiltValueField(wireName: 'country')
  String? get country;

  @BuiltValueField(wireName: 'phone_number')
  String? get phoneNumber;

  @BuiltValueField(wireName: 'is_default_address')
  bool? get isDefaultAddress;

  @BuiltValueField(wireName: 'added_at')
  DateTime? get addedAt;

  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference? get ffRef;
  DocumentReference get reference => ffRef!;

  static Query<Map<String, dynamic>> collection([DocumentReference? parent]) =>
      parent != null
          ? parent.collection('address_books')
          : FirebaseFirestore.instance.collectionGroup('address_books');

  static DocumentReference createDoc(DocumentReference parent) =>
      parent.collection('address_books').doc();

  static Stream<AddressBooksRecord> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  static Future<AddressBooksRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then(
          (s) => serializers.deserializeWith(serializer, serializedData(s))!);

  static void _initializeBuilder(AddressBooksRecordBuilder builder) => builder
    ..fullName = ''
    ..streetAddress = '';

  AddressBooksRecord._();

  factory AddressBooksRecord([updates(AddressBooksRecordBuilder b)]) =
      _$AddressBooksRecord;
}

Map<String, dynamic> createAddressBooksRecordData({
  String? fullName,
  String? streetAddress,
  String? city,
  String? state,
  String? postalCode,
  String? country,
  String? phoneNumber,
  bool? isDefaultAddress,
  DateTime? addedAt,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'full_name': fullName,
      'street_address': streetAddress,
      'city': city,
      'state': state,
      'postal_code': postalCode,
      'country': country,
      'phone_number': phoneNumber,
      'is_default_address': isDefaultAddress,
      'added_at': addedAt,
    },
  ).withoutNulls;

  return firestoreData;
}
