//
// import 'package:task_one_think/data/products_model.dart';
//
// class ProductsResponse{
//   List<Product>? products;
//   int? total;
//   int? skip;
//   int? limit;
//
//   ProductsResponse({this.products, this.total, this.skip, this.limit});
//
//   ProductsResponse.fromJson(Map<String, dynamic> json) {
//     if (json['products'] != null) {
//       products = <Product>[]; //clearing the list
//       json['products'].forEach((item) {
//         products!.add( Product.fromJson(item));
//       });
//     }
//     total = json['total'];
//     skip = json['skip'];
//     limit = json['limit'];
//   }
//
// }