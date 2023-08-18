import 'dart:convert';

import 'package:blueraymarket/backend/backend.dart';
import 'package:blueraymarket/backend/schema/discount/discount_record.dart';
import 'package:blueraymarket/backend/schema/product/product_record.dart';
import 'package:blueraymarket/backend/schema/sub_category/sub_category_record.dart';
import 'package:blueraymarket/tools/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

import '../schema/category/category_record.dart';
import '../schema/serializers.dart';

abstract class HiveModel<T> extends HiveObject {
  Future<List<T?>> getDataFromCache(
      {int? limit, Query<Object?> Function(Query<Object?>)? queryBuilder});

  Map<String, dynamic> toJson();
}

class DocumentReferenceHiveAdapter
    extends TypeAdapter<DocumentReference<Object?>> {
  @override
  final int typeId = 1; // Use a unique typeId for DocumentReference

  @override
  DocumentReference<Object?> read(BinaryReader reader) {
    final path = reader.readString();
    return FirebaseFirestore.instance.doc(path);
  }

  @override
  void write(
      BinaryWriter writer, DocumentReference<Object?> documentReference) {
    writer.writeString(documentReference.path);
  }
}

class SubCategoryHiveAdapter extends TypeAdapter<SubCategoryHive> {
  @override
  final int typeId = 0; // Use a unique typeId for SubCategoryHive
  @override
  SubCategoryHive read(BinaryReader reader) {
    final subCategoryHive = SubCategoryHive();
    subCategoryHive.subCategoryName = reader.readString();
    subCategoryHive.image = reader.readString();
    subCategoryHive.createdAt =
        DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    subCategoryHive.modifiedAt =
        DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    subCategoryHive.createdBy = reader.read() as DocumentReference<Object?>?;
    subCategoryHive.ffRef = reader.read() as DocumentReference<Object?>?;
    return subCategoryHive;
  }

  @override
  void write(BinaryWriter writer, SubCategoryHive subCategoryHive) {
    writer.writeString(subCategoryHive.subCategoryName!);
    writer.writeString(subCategoryHive.image!);
    writer.writeInt(subCategoryHive.createdAt?.millisecondsSinceEpoch ?? 0);
    writer.writeInt(subCategoryHive.modifiedAt?.millisecondsSinceEpoch ?? 0);
    writer.write(subCategoryHive.createdBy);
    writer.write(subCategoryHive.ffRef);
  }
}

@HiveType(typeId: 0)
class SubCategoryHive extends HiveModel<SubCategoryRecord> {
  SubCategoryHive({
    this.subCategoryName,
    this.image,
    this.createdAt,
    this.modifiedAt,
    this.createdBy,
    this.ffRef,
  });

  @HiveField(0)
  DateTime? createdAt;

  @HiveField(1)
  DocumentReference<Object?>? createdBy;

  @HiveField(2)
  DocumentReference<Object?>? ffRef;

  @HiveField(3)
  String? image;

  @HiveField(4)
  DateTime? modifiedAt;

  @HiveField(5)
  String? subCategoryName;

  Future<List<SubCategoryRecord?>> getDataFromCache({
    int? limit,
    Query<Object?> Function(Query<Object?>)? queryBuilder,
  }) async {
    final box = await Hive.openBox<SubCategoryHive>('subcategories');
    //await box.clear();
    if (box.isNotEmpty) {
      return box.values
          .map((subCategoryHive) => serializers.deserializeWith(
              SubCategoryRecord.serializer, subCategoryHive.toJson()))
          .toList();
    } else {
      final data = await querySubCategoriesRecordOnce(
          limit: limit ?? -1, queryBuilder: queryBuilder);
      await box.clear(); // Clear previous data (optional)

      // Save data to the cache
      await box.addAll(data.map(
        (subCategoryRecord) => SubCategoryHive(
          subCategoryName: subCategoryRecord.subCategoryName,
          image: subCategoryRecord.image,
          createdAt: subCategoryRecord.createdAt,
          modifiedAt: subCategoryRecord.modifiedAt,
          createdBy: subCategoryRecord.createdBy,
          ffRef: subCategoryRecord.ffRef,
        ),
      ));

      return data;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'created_at': this.createdAt,
      'modified_at': this.modifiedAt,
      'created_by': this.createdBy,
      kDocumentReferenceField: this.ffRef,
      'image': this.image,
      'sub_category_name': this.subCategoryName,
    };
  }
}

void clearSubcategoryBox() {
  final box = Hive.box<SubCategoryHive>('subcategories');
  box.clear();
}

@HiveType(typeId: 2)
class ProductHive extends HiveModel<ProductRecord> {
  ProductHive({
    this.title,
    this.description,
    this.price,
    this.rating,
    this.brandname,
    this.idbrand,
    this.categoryname,
    this.idcategory,
    this.subcategoryname,
    this.idsubcategory,
    this.iddiscount,
    this.image,
    this.createdAt,
    this.modifiedAt,
    this.createdBy,
    this.ffRef,
  });

  @HiveField(0)
  DateTime? createdAt;

  @HiveField(1)
  DocumentReference<Object?>? createdBy;

  @HiveField(2)
  DocumentReference<Object?>? ffRef;

  @HiveField(3)
  String? image;

  @HiveField(4)
  DateTime? modifiedAt;

  @HiveField(5)
  String? title;

  @HiveField(6)
  String? description;

  @HiveField(7)
  double? price;

  @HiveField(8)
  double? rating;

  @HiveField(9)
  DocumentReference<Object?>? idbrand;

  @HiveField(10)
  String? brandname;

  @HiveField(11)
  DocumentReference<Object?>? idcategory;

  @HiveField(12)
  String? categoryname;

  @HiveField(13)
  DocumentReference<Object?>? idsubcategory;

  @HiveField(14)
  String? subcategoryname;

  @HiveField(15)
  DocumentReference<Object?>? iddiscount;

  @override
  Future<List<ProductRecord?>> getDataFromCache({
    int? limit,
    Query<Object?> Function(Query<Object?>)? queryBuilder,
    DocumentReference? filter,
  }) async {
    final box = await Hive.openBox<ProductHive>('products');

    if (box.isNotEmpty) {
      // Data is available in the cache, return it
      if (filter != null) {
        return box.values
            .map((productHive) => serializers.deserializeWith(
                ProductRecord.serializer, productHive.toJson()))
            .where((e) => e!.idSubCategory == filter)
            .toList();
      } else {
        final test = box.values
            .map((productHive) => serializers.deserializeWith(
                ProductRecord.serializer, productHive.toJson()))
            .toList();
        return test;
      }
    } else {
      // Data is not available in the cache, fetch it from the network
      final data = await queryProductsRecordOnce(limit: limit ?? -1);
      // Save data to the cache

      await box.addAll(data.map(
        (productRecord) => ProductHive(
          title: productRecord.title,
          description: productRecord.description,
          price: productRecord.price,
          rating: productRecord.rating,
          brandname: productRecord.brandName,
          idbrand: productRecord.idBrand,
          categoryname: productRecord.categoryName ?? '',
          idcategory: productRecord.idCategories,
          subcategoryname: productRecord.subcategoryName,
          idsubcategory: productRecord.idSubCategory,
          iddiscount: productRecord.idDiscount,
          image: productRecord.image,
          createdAt: productRecord.createdAt,
          modifiedAt: productRecord.modifiedAt,
          createdBy: productRecord.createdBy,
          ffRef: productRecord.ffRef,
        ),
      ));

      return data;
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'title': this.title,
      'description': this.description,
      'price': this.price,
      'rating': this.rating,
      'id_brand': this.idbrand,
      'brand_name': this.brandname,
      'id_category': this.idcategory,
      'category_name': this.categoryname,
      'id_subcategory': this.idsubcategory,
      'subcategory_name': this.subcategoryname,
      'image': this.image,
      'created_at': this.createdAt,
      'modified_at': this.modifiedAt,
      'created_by': this.createdBy,
      kDocumentReferenceField: this.ffRef,
      'id_discount': this.iddiscount
    };
  }
}

void clearProductsBox() async {
  final box = Hive.box<ProductHive>('products');
  box.clear();
}

class ProductHiveAdapter extends TypeAdapter<ProductHive> {
  @override
  final int typeId = 2; // Use a unique typeId for ProductHive

  @override
  ProductHive read(BinaryReader reader) {
    final productHive = ProductHive();
    productHive.title = reader.readString();
    productHive.description = reader.readString();
    productHive.price = reader.readDouble();
    productHive.rating = reader.readDouble();
    productHive.brandname = reader.readString();
    productHive.idbrand = reader.read() as DocumentReference<Object?>?;
    productHive.idcategory = reader.read() as DocumentReference<Object?>?;
    productHive.categoryname = reader.readString();
    productHive.idsubcategory = reader.read() as DocumentReference<Object?>?;
    productHive.subcategoryname = reader.readString();
    productHive.iddiscount = reader.read() as DocumentReference<Object?>?;
    productHive.image = reader.readString();
    productHive.createdAt =
        DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    productHive.modifiedAt =
        DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    productHive.createdBy = reader.read() as DocumentReference<Object?>?;
    productHive.ffRef = reader.read() as DocumentReference<Object?>?;

    return productHive;
  }

  @override
  void write(BinaryWriter writer, ProductHive productHive) {
    writer.writeString(productHive.title!);
    writer.writeString(productHive.description!);
    writer.writeDouble(productHive.price!);
    writer.writeDouble(productHive.rating!);
    writer.writeString(productHive.brandname!);
    writer.write(productHive.idbrand!);
    writer.write(productHive.idcategory!);
    writer.writeString(productHive.categoryname!);
    writer.write(productHive.idsubcategory!);
    writer.writeString(productHive.subcategoryname!);
    writer.write(productHive.iddiscount!);
    writer.writeString(productHive.image!);
    writer.writeInt(productHive.createdAt?.millisecondsSinceEpoch ?? 0);
    writer.writeInt(productHive.modifiedAt?.millisecondsSinceEpoch ?? 0);
    writer.write(productHive.createdBy);
    writer.write(productHive.ffRef);
  }
}

class DiscountHiveAdapter extends TypeAdapter<DiscountHive> {
  @override
  final int typeId = 3; // Use a unique typeId for SubCategoryHive
  @override
  DiscountHive read(BinaryReader reader) {
    final discountHive = DiscountHive();
    discountHive.title = reader.readString();
    discountHive.description = reader.readString();
    discountHive.discountPercent = reader.readDouble();
    discountHive.active = reader.readBool();
    discountHive.displayAtHome = reader.readBool();
    discountHive.image = reader.readString();
    discountHive.createdAt =
        DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    discountHive.modifiedAt =
        DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    discountHive.startedAt =
        DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    discountHive.endAt = DateTime.fromMillisecondsSinceEpoch(reader.readInt());

    discountHive.ffRef = reader.read() as DocumentReference<Object?>?;
    return discountHive;
  }

  @override
  void write(BinaryWriter writer, DiscountHive discountHive) {
    writer.writeString(discountHive.title!);
    writer.writeString(discountHive.description!);
    writer.writeDouble(discountHive.discountPercent!);
    writer.writeBool(discountHive.active!);
    writer.writeBool(discountHive.displayAtHome!);
    writer.writeString(discountHive.image!);
    writer.writeInt(discountHive.createdAt?.millisecondsSinceEpoch ?? 0);
    writer.writeInt(discountHive.modifiedAt?.millisecondsSinceEpoch ?? 0);
    writer.writeInt(discountHive.startedAt?.millisecondsSinceEpoch ?? 0);
    writer.writeInt(discountHive.endAt?.millisecondsSinceEpoch ?? 0);
    writer.write(discountHive.ffRef);
  }
}

@HiveType(typeId: 3)
class DiscountHive extends HiveModel<DiscountRecord> {
  DiscountHive({
    this.title,
    this.description,
    this.discountPercent,
    this.active,
    this.displayAtHome,
    this.image,
    this.createdAt,
    this.modifiedAt,
    this.startedAt,
    this.endAt,
    this.ffRef,
  });

  @HiveField(0)
  DateTime? createdAt;

  @HiveField(1)
  DateTime? endAt;

  @HiveField(2)
  DocumentReference<Object?>? ffRef;

  @HiveField(3)
  String? image;

  @HiveField(4)
  DateTime? modifiedAt;

  @HiveField(5)
  String? title;

  @HiveField(6)
  String? description;

  @HiveField(7)
  double? discountPercent;

  @HiveField(8)
  bool? active;

  @HiveField(9)
  bool? displayAtHome;

  @HiveField(10)
  DateTime? startedAt;

  Future<List<DiscountRecord?>> getDataFromCache({
    int? limit,
    Query<Object?> Function(Query<Object?>)? queryBuilder,
  }) async {
    final box = await Hive.openBox<DiscountHive>('discounts');
    //await box.clear();
    if (box.isNotEmpty) {
      return box.values
          .map((discountHive) => serializers.deserializeWith(
              DiscountRecord.serializer, discountHive.toJson()))
          .toList();
    } else {
      // Data is not available in the cache, fetch it from the network
      final data = await queryDiscountsRecordOnce(
          limit: limit ?? -1, queryBuilder: queryBuilder);
      await box.clear(); // Clear previous data (optional)

      // Save data to the cache
      // Clear previous data (optional)
      await box.addAll(data.map(
        (discountRecord) => DiscountHive(
          title: discountRecord.title ?? '',
          description: discountRecord.description ?? '',
          discountPercent: discountRecord.discountPercent ?? 0.0,
          active: discountRecord.active ?? false,
          displayAtHome: discountRecord.displayAtHome ?? false,
          image: discountRecord.image,
          createdAt: discountRecord.createdAt ?? getCurrentTimestamp,
          startedAt: discountRecord.startedAt ?? getCurrentTimestamp,
          endAt: discountRecord.endAt ?? getCurrentTimestamp,
          modifiedAt: discountRecord.modifiedAt ?? getCurrentTimestamp,
          ffRef: discountRecord.ffRef,
        ),
      ));

      return data;
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'created_at': createdAt,
      'end_at': endAt,
      kDocumentReferenceField: ffRef,
      'image': image,
      'modified_at': modifiedAt,
      'title': title,
      'description': description,
      'discount_percent': discountPercent,
      'active': active,
      'display_at_home': displayAtHome,
      'started_at': startedAt,
    };
  }
}

void clearDiscountsBox() async {
  final box = Hive.box<DiscountHive>('discounts');
  box.clear();
}

class CategoryHiveAdapter extends TypeAdapter<CategoryHive> {
  @override
  final int typeId = 4; // Use a unique typeId for SubCategoryHive
  @override
  CategoryHive read(BinaryReader reader) {
    final categoryHive = CategoryHive();
    categoryHive.categoryName = reader.readString();
    categoryHive.image = reader.readString();
    categoryHive.createdAt =
        DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    categoryHive.modifiedAt =
        DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    categoryHive.createdBy = reader.read() as DocumentReference<Object?>?;
    categoryHive.ffRef = reader.read() as DocumentReference<Object?>?;
    return categoryHive;
  }

  @override
  void write(BinaryWriter writer, CategoryHive subCategoryHive) {
    writer.writeString(subCategoryHive.categoryName!);
    writer.writeString(subCategoryHive.image!);
    writer.writeInt(subCategoryHive.createdAt?.millisecondsSinceEpoch ?? 0);
    writer.writeInt(subCategoryHive.modifiedAt?.millisecondsSinceEpoch ?? 0);
    writer.write(subCategoryHive.createdBy);
    writer.write(subCategoryHive.ffRef);
  }
}

@HiveType(typeId: 4)
class CategoryHive extends HiveModel<CategoryRecord> {
  CategoryHive({
    this.categoryName,
    this.image,
    this.displayAt,
    this.createdAt,
    this.modifiedAt,
    this.createdBy,
    this.ffRef,
  });

  @HiveField(0)
  DateTime? createdAt;

  @HiveField(1)
  DocumentReference<Object?>? createdBy;

  @HiveField(2)
  DocumentReference<Object?>? ffRef;

  @HiveField(3)
  String? image;

  @HiveField(4)
  DateTime? modifiedAt;

  @HiveField(5)
  String? categoryName;

  @HiveField(6)
  bool? displayAt;

  Future<List<CategoryRecord?>> getDataFromCache({
    int? limit,
    Query<Object?> Function(Query<Object?>)? queryBuilder,
  }) async {
    final box = await Hive.openBox<CategoryHive>('categories');
    //await box.clear();
    if (box.isNotEmpty) {
      return box.values
          .map((subCategoryHive) => serializers.deserializeWith(
              CategoryRecord.serializer, subCategoryHive.toJson()))
          .toList();
    } else {
      // Data is not available in the cache, fetch it from the network
      final data = await queryCategoriesRecordOnce(
          limit: limit ?? -1, queryBuilder: queryBuilder);
      await box.clear(); // Clear previous data (optional)

      // Save data to the cache
      // Clear previous data (optional)
      await box.addAll(data.map(
        (categoryRecord) => CategoryHive(
          categoryName: categoryRecord.categoryName,
          image: categoryRecord.image,
          displayAt: categoryRecord.displayAtHome ?? false,
          createdAt: categoryRecord.createdAt,
          modifiedAt: categoryRecord.modifiedAt,
          createdBy: categoryRecord.createdBy,
          ffRef: categoryRecord.ffRef,
        ),
      ));

      return data;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'created_at': this.createdAt,
      'modified_at': this.modifiedAt,
      'created_by': this.createdBy,
      kDocumentReferenceField: this.ffRef,
      'image': this.image,
      'display_at_home': this.displayAt,
      'category_name': this.categoryName,
    };
  }
}

void clearCategoriesBox() async {
  final box = Hive.box<CategoryHive>('categories');
  box.clear();
}
