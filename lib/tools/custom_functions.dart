import 'package:blueraymarket/backend/schema/category/category_record.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<(DocumentReference<Object?>, String?)> getNameRefCategory(
    DocumentReference? subcategoryRef) async {
  final query =
      await CategoryRecord.getDocumentOnce(subcategoryRef!.parent.parent!);

  return (query.reference, query.categoryName);
}
