import 'package:blueraymarket/backend/schema/variant/variant_record.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import '../../../backend/schema/product/product_record.dart';

abstract class AddToCartEvent extends Equatable {
  const AddToCartEvent();
}

class AddToCartItemEvent extends AddToCartEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
  final ProductRecord productRecord;
  final VariantRecord variantRecord;
  AddToCartItemEvent(
      {required this.productRecord, required this.variantRecord});
}

class IncreaseQuantityItem extends AddToCartEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
  final ProductRecord productRecord;
  final VariantRecord variantRecord;
  IncreaseQuantityItem(
      {required this.productRecord, required this.variantRecord});
}

class RemoveFromCartItemEvent extends AddToCartEvent {
  @override
  List<Object?> get props => [];
  final ProductRecord productRecord;
  RemoveFromCartItemEvent({required this.productRecord});
}
