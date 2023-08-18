import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../serializers.dart';

part 'product_record.g.dart';

abstract class ProductRecord
    implements Built<ProductRecord, ProductRecordBuilder> {
  static Serializer<ProductRecord> get serializer => _$productRecordSerializer;

  // fields go here
  @BuiltValueField(wireName: 'title')
  String? get title;

  @BuiltValueField(wireName: 'description')
  String? get description;

  @BuiltValueField(wireName: 'price')
  double? get price;

  @BuiltValueField(wireName: 'image')
  String? get image;

  @BuiltValueField(wireName: 'rating')
  double? get rating;

  @BuiltValueField(wireName: 'id_brand')
  DocumentReference? get idBrand;

  @BuiltValueField(wireName: 'brand_name')
  String? get brandName;

  @BuiltValueField(wireName: 'id_category')
  DocumentReference? get idCategories;

  @BuiltValueField(wireName: 'category_name')
  String? get categoryName;

  @BuiltValueField(wireName: 'id_subcategory')
  DocumentReference? get idSubCategory;

  @BuiltValueField(wireName: 'subcategory_name')
  String? get subcategoryName;

  @BuiltValueField(wireName: 'id_discount')
  DocumentReference? get idDiscount;

  @BuiltValueField(wireName: 'created_at')
  DateTime? get createdAt;

  @BuiltValueField(wireName: 'modified_at')
  DateTime? get modifiedAt;
  @BuiltValueField(wireName: 'created_by')
  DocumentReference? get createdBy;

  @BuiltValueField(wireName: kDocumentReferenceField)
  DocumentReference? get ffRef;
  DocumentReference get reference => ffRef!;

  ProductRecord._();

  factory ProductRecord([updates(ProductRecordBuilder b)]) = _$ProductRecord;
  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('products');

  static Stream<ProductRecord> getDocument(DocumentReference ref) => ref
      .snapshots()
      .map((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  static Future<ProductRecord> getDocumentOnce(DocumentReference ref) => ref
      .get()
      .then((s) => serializers.deserializeWith(serializer, serializedData(s))!);

  static ProductRecord getDocumentFromData(
          Map<String, dynamic> data, DocumentReference reference) =>
      serializers.deserializeWith(serializer,
          {...mapFromFirestore(data), kDocumentReferenceField: reference})!;

  static void _initializeBuilder(ProductRecordBuilder builder) => builder
    ..title = ''
    ..description = ''
    ..price = 0.0
    ..image = ''
    ..rating = 1.0;
}

Map<String, dynamic> createProductRecordData({
  String? title,
  String? description,
  double? price,
  String? image,
  double? rating,
  DocumentReference? idBrand,
  String? brandName,
  DocumentReference? idCategory,
  String? categoryName,
  DocumentReference? idSubcategory,
  String? subcategoryName,
  DocumentReference? idDiscount,
  DateTime? createdAt,
  DateTime? modifiedAt,
  DocumentReference? createdBy,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'title': title,
      'description': description,
      'price': price,
      'image': image,
      'rating': rating,
      'id_brand': idBrand,
      'brand_name': brandName,
      'id_category': idCategory,
      'category_name': categoryName,
      'id_subcategory': idSubcategory,
      'subcategory_name': subcategoryName,
      'id_discount': idDiscount,
      'created_at': createdAt,
      'modified_at': modifiedAt,
      'created_by': createdBy,
    },
  ).withoutNulls;

  return firestoreData;
}
