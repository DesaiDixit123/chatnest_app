import 'package:chatnest/domain/domain.dart';

class ProductPresenter {
  ProductPresenter(this.productUsecases, this.commonUsecases);

  final ProductUsecases productUsecases;
  final CommonUsecases commonUsecases;

  Future<FriendProductModel?> postfriendsproducts({
    bool isLoading = false,
    required String search,
    required String userid,
    required String business,
    required List<String> parentcategory,
    required List<String> childcategory,
  }) async =>
      await commonUsecases.postfriendsproducts(
        search: search,
        userid: userid,
        business: business,
        parentcategory: parentcategory,
        childcategory: childcategory,
        isLoading: isLoading,
      );

  Future<GetOneFriendProductModel?> postFriendProductGetOne({
    required String productid,
    bool isLoading = false,
  }) async =>
      await commonUsecases.postFriendProductGetOne(
        isLoading: isLoading,
        productid: productid,
      );

  Future<SendRequestModel?> sendNewFriendRequest({
    bool isLoading = false,
    required String receiverid,
    required String message,
    required String product,
    required AuthorizedPermissions authorizedPermissions,
  }) async =>
      await commonUsecases.sendNewFriendRequest(
        isLoading: isLoading,
        receiverid: receiverid,
        message: message,
        product: product,
        authorizedPermissions: authorizedPermissions,
      );
}
