import 'package:chatnest/app/app.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  ProductController(this.presenter);

  final ProductPresenter presenter;

  TextEditingController productSearchController = TextEditingController();

  double ratting = 1.0;
  bool isLowtoHigh = false;
  bool isFilter = false;
  bool isHightoLow = false;
  bool isNewest = false;
  bool isTopratted = false;

  List<FriendProductData>? friendProductList = [];

  FriendProductData? friendProductDoc = FriendProductData();
  bool isProductSend = false;
  int productMediaIndex = 0;

  Future<void> postfriendsproducts() async {
    var response = await presenter.postfriendsproducts(
      search: productSearchController.text,
      userid: "",
      business: "",
      parentcategory: [],
      childcategory: [],
    );
    friendProductList?.clear();
    if (response != null) {
      friendProductList = response.data ?? [];
    }
    update();
  }

  List<String> imagesList = [];
  List<String> videosList = [];
  List<String> allVideoList = [];

  GetOneFriendProductData? getOneFriendData = GetOneFriendProductData();

  Future<void> postFriendProductGetOne(productid) async {
    var response = await presenter.postFriendProductGetOne(
      productid: productid,
      isLoading: true,
    );
    getOneFriendData = null;
    imagesList.clear();
    videosList.clear();
    allVideoList.clear();
    if (response?.data != null) {
      getOneFriendData = response?.data;

      final productData = response?.data?.productdata;

      for (var item in productData?.images ?? []) {
        imagesList.add(item);
      }
      for (var item in productData?.videos ?? []) {
        videosList.add(item);
      }
      if ((productData?.image ?? "").isNotEmpty) {
        allVideoList.add(productData!.image!);
      }
      allVideoList.addAll(
        [...imagesList, ...videosList].where((item) => item.isNotEmpty),
      );
    }
    update();
  }

  AuthorizedPermissions authorizedPermissions = AuthorizedPermissions(
    fullname: true,
    mobile: true,
    email: true,
    dob: true,
    gender: true,
    socialmedia: true,
    videocall: true,
    audiocall: true,
    ismute: false,
  );

  GlobalKey<FormState> sendRequestKey = GlobalKey<FormState>();
  TextEditingController messageController = TextEditingController();
  FocusNode messageFocusNode = FocusNode();

  Future<void> sendNewFriendRequest(String receiverid, String message) async {
    var response = await presenter.sendNewFriendRequest(
      receiverid: receiverid,
      message: message,
      product: "",
      authorizedPermissions: authorizedPermissions,
    );
    if (response != null) {
      messageController.clear();
      Utility.snacBar(response.message ?? "", ColorsValue.appColor);
    } else {
      messageController.clear();
    }
    update();
  }
}
