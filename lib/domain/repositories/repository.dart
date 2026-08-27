import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/domain/domain.dart';

import '../../data/repositories/data_repositories.dart';
import '../../device/repositories/device_repositories.dart';

/// The main repository which will get the data from [DeviceRepository] or the
/// [DataRepository].
class Repository {
  /// [_deviceRepository] : the local repository.
  /// [_dataRepository] : the data repository like api and all.
  Repository(this._deviceRepository, this._dataRepository);

  final DeviceRepository _deviceRepository;
  final DataRepository _dataRepository;

  /// Clear data from local storage for [key].
  void clearData(dynamic key) {
    try {
      _deviceRepository.clearData(
        key,
      );
    } catch (_) {
      _dataRepository.clearData(
        key,
      );
    }
  }

  /// Get the string value for the [key].
  ///
  /// [key] : The key whose value is needed.
  String getStringValue(String key) {
    try {
      return _deviceRepository.getStringValue(
        key,
      );
    } catch (_) {
      return _dataRepository.getStringValue(
        key,
      );
    }
  }

  int getIntValue(String key) {
    try {
      return _deviceRepository.getIntValue(
        key,
      );
    } catch (_) {
      return _dataRepository.getIntValue(
        key,
      );
    }
  }

  /// Save the value to the string.
  ///
  /// [key] : The key to which [value] will be saved.
  /// [value] : The value which needs to be saved.
  void saveValue(dynamic key, dynamic value) {
    try {
      _deviceRepository.saveValue(
        key,
        value,
      );
    } catch (_) {
      _dataRepository.saveValue(
        key,
        value,
      );
    }
  }

  /// Get the bool value for the [key].
  ///
  /// [key] : The key whose value is needed.
  bool getBoolValue(String key) {
    try {
      return _deviceRepository.getBoolValue(
        key,
      );
    } catch (_) {
      return _dataRepository.getBoolValue(
        key,
      );
    }
  }

  /// Get the stored value for the [key].
  ///
  /// [key] : The key whose value is needed.
  bool getStoredValue(String key) {
    try {
      return _deviceRepository.getBoolValue(
        key,
      );
    } catch (_) {
      return _dataRepository.getBoolValue(
        key,
      );
    }
  }

  /// Get the secure value for the [key].
  /// [key] : The key whose value is needed.
  Future<String> getSecureValue(String key) async {
    try {
      return await _deviceRepository.getSecuredValue(key);
    } catch (_) {
      return await _dataRepository.getSecuredValue(key);
    }
  }

  /// Save the value to the string.
  ///
  /// [key] : The key to which [value] will be saved.
  /// [value] : The value which needs to be saved.
  void saveSecureValue(String key, String value) {
    try {
      _deviceRepository.saveValueSecurely(
        key,
        value,
      );
    } catch (_) {
      _dataRepository.saveValueSecurely(
        key,
        value,
      );
    }
  }

  /// Clear data from secure storage for [key].
  void deleteSecuredValue(String key) {
    try {
      _deviceRepository.deleteSecuredValue(
        key,
      );
    } catch (_) {
      _dataRepository.deleteSecuredValue(
        key,
      );
    }
  }

  /// Clear all data from secure storage .
  void deleteAllSecuredValues() {
    try {
      _deviceRepository.deleteAllSecuredValues();
    } catch (_) {
      _dataRepository.deleteAllSecuredValues();
    }
  }

  /// API to login
  Future<SendOtpModel?> sendOtpApi({
    required String mobile,
    required String countryCode,
    required String fcmToken,
    bool isLoading = false,
  }) async {
    try {
      var response = await _dataRepository.sendOtpApi(
        mobile: mobile,
        countryCode: countryCode,
        fcmToken: fcmToken,
        isLoading: isLoading,
      );
      var loginResponse = sendOtpModelFromJson(response.data);
      if (loginResponse.status == 200) {
        return loginResponse;
      } else {
        return loginResponse;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  /// verifyOtpApi
  Future<VerifyOtpModel?> verifyOtpApi({
    required String key,
    required String otp,
    required String mobile,
    bool isLoading = false,
  }) async {
    try {
      var response = await _dataRepository.verifyOtpApi(
        mobile: mobile,
        key: key,
        otp: otp,
        isLoading: isLoading,
      );
      var verifyOtpModel = verifyOtpModelFromJson(response.data);
      if (verifyOtpModel.status == 200) {
        saveValue(LocalKeys.authToken, verifyOtpModel.data.token.toString());

        saveValue(LocalKeys.locale, 'en');
        return verifyOtpModel;
      } else {
        Utility.showMessage(verifyOtpModel.message.toString(),
            MessageType.error, () => null, '');
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<String?> uploadBrochure({
    bool isLoading = false,
    required String filePath,
  }) async {
    try {
      var response = await _dataRepository.uploadBrochure(
        isLoading: isLoading,
        filePath: filePath,
      );
      if (response.statusCode == 200) {
        return json.decode(response.data)['Data']['url'];
      } else {
        Utility.showMessage(json.decode(response.data)['Message'].toString(),
            MessageType.error, () => null, '');
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> setProfile({
    bool isLoading = false,
    required String profileimage,
    required String fullname,
    required String nickname,
    required String email,
    required String dob,
    required String hashtag,
    required String gender,
    required String aboutme,
    required List<String> hobbies,
    required double latitude,
    required double longitude,
    required String interestedin,
    required int interestedagerangemin,
    required int interestedagerangemax,
    required List<Socialmedialink> socialmedialinks,
  }) async {
    try {
      var response = await _dataRepository.setProfile(
        profileimage: profileimage,
        fullname: fullname,
        nickname: nickname,
        email: email,
        dob: dob,
        hashtag: hashtag,
        gender: gender,
        aboutme: aboutme,
        hobbies: hobbies,
        latitude: latitude,
        longitude: longitude,
        interestedin: interestedin,
        interestedagerangemin: interestedagerangemin,
        interestedagerangemax: interestedagerangemax,
        socialmedialinks: socialmedialinks,
        isLoading: isLoading,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<String?> setProfilePic({
    bool isLoading = false,
    required String filePath,
  }) async {
    try {
      var response = await _dataRepository.setProfilePic(
        isLoading: isLoading,
        filePath: filePath,
      );
      if (response.statusCode == 200) {
        return json.decode(response.data)['Data']['url'];
      } else {
        Utility.showMessage(json.decode(response.data)['Message'].toString(),
            MessageType.error, () => null, '');
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<GetProfileModel?> getProfile({
    bool isLoading = false,
  }) async {
    try {
      var response = await _dataRepository.getProfile(
        isLoading: isLoading,
      );
      var getProfileModel = getProfileModelFromJson(response.data);
      if (getProfileModel.status == 200) {
        return getProfileModel;
      } else {
        Utility.showMessage(getProfileModel.message.toString(),
            MessageType.error, () => null, '');
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<GetBusinessCategoriesModel?> getBusinessCategories({
    bool isLoading = false,
  }) async {
    try {
      var response = await _dataRepository.getBusinessCategories(
        isLoading: isLoading,
      );
      var getProfileModel = getBusinessCategoriesModelFromJson(response.data);
      if (getProfileModel.status == 200) {
        return getProfileModel;
      } else {
        Utility.showMessage(getProfileModel.message.toString(),
            MessageType.error, () => null, '');
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ProductCategoryModel?> getProductCategory({
    bool isLoading = false,
    required int page,
    required int limit,
    required String search,
  }) async {
    try {
      var response = await _dataRepository.getProductCategory(
        isLoading: isLoading,
        page: page,
        limit: limit,
        search: search,
      );
      var productCategoryModel = productCategoryModelFromJson(response.data);
      if (productCategoryModel.status == 200) {
        return productCategoryModel;
      } else {
        Utility.showMessage(productCategoryModel.message.toString(),
            MessageType.error, () => null, '');
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> setBusinessProfile({
    bool isLoading = false,
    required String businessid,
    required String profileimage,
    required String name,
    required List<AddBusinessCategory> categories,
    required String about,
    required String mobile,
    required String mobileCountryCode,
    required String wamobile,
    required String wamobileCountryCode,
    required String email,
    required String website,
    required List<AddBusinessCategory> interestedCategories,
    required List<String> brochures,
    required List<String> photos,
    required List<String> videos,
    required AddBusinessAddress address,
    required double latitude,
    required double longitude,
    required bool isBusinessCategories,
    required List<AddBusinessBusinesshour> businesshours,
    required List<Socialmedialink> socialmedialinks,
  }) async {
    try {
      var response = await _dataRepository.setBusinessProfile(
        isLoading: isLoading,
        businessid: businessid,
        profileimage: profileimage,
        name: name,
        categories: categories,
        about: about,
        mobile: mobile,
        mobileCountryCode: mobileCountryCode,
        wamobile: wamobile,
        wamobileCountryCode: wamobileCountryCode,
        email: email,
        website: website,
        interestedCategories: interestedCategories,
        brochures: brochures,
        photos: photos,
        videos: videos,
        address: address,
        latitude: latitude,
        longitude: longitude,
        businesshours: businesshours,
        socialmedialinks: socialmedialinks,
        isBusinessCategories: isBusinessCategories,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<SaveProductModel?> addProduct({
    bool isLoading = false,
    required List<AddBusinessCategory> categories,
    required List<String> images,
    required List<String> videos,
    required String businessid,
    required String productid,
    required String name,
    required String image,
    required String description,
    required int price,
    required int offer,
    required String offerType,
  }) async {
    try {
      var response = await _dataRepository.addProduct(
        isLoading: isLoading,
        categories: categories,
        images: images,
        videos: videos,
        businessid: businessid,
        productid: productid,
        name: name,
        image: image,
        description: description,
        price: price,
        offer: offer,
        offerType: offerType,
      );
      var saveProductModel = saveProductModelFromJson(response.data);
      if (saveProductModel.status == 200) {
        return saveProductModel;
      } else {
        Utility.showMessage(saveProductModel.message.toString(),
            MessageType.error, () => null, '');
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  // Future<ResponseModel?> addProduct({
  //   bool isLoading = false,

  // }) async {
  //   try {
  //     var response = await _dataRepository.addProduct(

  //     );
  //     return response;
  //   } catch (_) {
  //     Utility.closeDialog();
  //     UnimplementedError();
  //     return null;
  //   }
  // }

  // Future<SaveProductModel?> addProduct({
  //   bool isLoading = false,
  //   required List<AddBusinessCategory> categories,
  //   required List<String> images,
  //   required List<String> videos,
  //   required String businessid,
  //   required String productid,
  //   required String name,
  //   required String image,
  //   required String description,
  //   required int price,
  //   required int offer,
  //   required String offerType,
  // }) async {
  //   try {
  //     var response = await _dataRepository.addProduct(
  //       isLoading: isLoading,
  //       categories: categories,
  //       images: images,
  //       videos: videos,
  //       businessid: businessid,
  //       productid: productid,
  //       name: name,
  //       image: image,
  //       description: description,
  //       price: price,
  //       offer: offer,
  //       offerType: offerType,
  //     );
  //     var saveProductModel = saveProductModelFromJson(response.data);
  //     if (saveProductModel.status == 200) {
  //       return saveProductModel;
  //     } else {
  //       Utility.showMessage(saveProductModel.message.toString(),
  //           MessageType.error, () => null, '');
  //       return null;
  //     }
  //   } catch (_) {
  //     Utility.closeDialog();
  //     UnimplementedError();
  //     return null;
  //   }
  // }

  Future<String?> setProductPhoto({
    bool isLoading = false,
    required String filePath,
  }) async {
    try {
      var response = await _dataRepository.setProductPhoto(
        isLoading: isLoading,
        filePath: filePath,
      );
      if (response.statusCode == 200) {
        return json.decode(response.data)['Data']['url'];
      } else {
        Utility.showMessage(json.decode(response.data)['Message'].toString(),
            MessageType.error, () => null, '');
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<String?> uploadProductVideo({
    bool isLoading = false,
    required String filePath,
  }) async {
    try {
      var response = await _dataRepository.uploadProductVideo(
        isLoading: isLoading,
        filePath: filePath,
      );
      if (response.statusCode == 200) {
        return json.decode(response.data)['Data']['url'];
      } else {
        Utility.showMessage(json.decode(response.data)['Message'].toString(),
            MessageType.error, () => null, '');
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<GetProductListModel?> getproductList({
    bool isLoading = false,
    required int page,
    required int limit,
    required String search,
    required String business,
    required List<String> parentcategory,
    required List<String> childcategory,
  }) async {
    try {
      var response = await _dataRepository.getproductList(
        isLoading: isLoading,
        page: page,
        limit: limit,
        search: search,
        business: business,
        childcategory: childcategory,
        parentcategory: parentcategory,
      );
      var getProductListModel = getProductListModelFromJson(response.data);
      if (getProductListModel.status == 200) {
        return getProductListModel;
      } else {
        Utility.showMessage(getProductListModel.message.toString(),
            MessageType.error, () => null, '');
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<GetOneProductModel?> getOneProduct({
    bool isLoading = false,
    required String productid,
  }) async {
    try {
      var response = await _dataRepository.getOneProduct(
        isLoading: isLoading,
        productid: productid,
      );
      var getoneProductModel = getOneProductModelFromJson(response.data);
      if (getoneProductModel.status == 200) {
        return getoneProductModel;
      } else {
        Utility.showMessage(getoneProductModel.message.toString(),
            MessageType.error, () => null, '');
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<String?> removeProduct({
    bool isLoading = false,
    required String productid,
  }) async {
    try {
      var response = await _dataRepository.removeProduct(
        isLoading: isLoading,
        productid: productid,
      );
      if (response.statusCode == 200) {
        return json.decode(response.data)['Message'];
      } else {
        Utility.showMessage(json.decode(response.data)['Message'].toString(),
            MessageType.error, () => null, '');
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<String?> removeProductPhoto({
    bool isLoading = false,
    required String filekey,
  }) async {
    try {
      var response = await _dataRepository.removeProductPhoto(
        isLoading: isLoading,
        filekey: filekey,
      );
      if (response.statusCode == 200) {
        return json.decode(response.data)['Message'];
      } else {
        Utility.showMessage(json.decode(response.data)['Message'].toString(),
            MessageType.error, () => null, '');
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<String?> removeProductVideo({
    bool isLoading = false,
    required String filekey,
  }) async {
    try {
      var response = await _dataRepository.removeProductVideo(
        isLoading: isLoading,
        filekey: filekey,
      );
      if (response.statusCode == 200) {
        return json.decode(response.data)['Message'];
      } else {
        Utility.showMessage(json.decode(response.data)['Message'].toString(),
            MessageType.error, () => null, '');
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<String?> setBusinessProfilePic({
    bool isLoading = false,
    required String filePath,
  }) async {
    try {
      var response = await _dataRepository.setBusinessProfilePic(
        isLoading: isLoading,
        filePath: filePath,
      );
      if (response.statusCode == 200) {
        return json.decode(response.data)['Data']['url'];
      } else {
        Utility.showMessage(json.decode(response.data)['Message'].toString(),
            MessageType.error, () => null, '');
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<String?> uploadBusinessPhoto({
    bool isLoading = false,
    required String filePath,
  }) async {
    try {
      var response = await _dataRepository.uploadBusinessPhoto(
        isLoading: isLoading,
        filePath: filePath,
      );
      if (response.statusCode == 200) {
        return json.decode(response.data)['Data']['url'];
      } else {
        Utility.showMessage(json.decode(response.data)['Message'].toString(),
            MessageType.error, () => null, '');
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<String?> uploadBusinessVideo({
    bool isLoading = false,
    required String filePath,
  }) async {
    try {
      var response = await _dataRepository.uploadBusinessVideo(
        isLoading: isLoading,
        filePath: filePath,
      );
      if (response.statusCode == 200) {
        return json.decode(response.data)['Data']['url'];
      } else {
        Utility.showMessage(json.decode(response.data)['Message'].toString(),
            MessageType.error, () => null, '');
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<String?> removeBrochure({
    bool isLoading = false,
    required String filekey,
  }) async {
    try {
      var response = await _dataRepository.removeBrochure(
        isLoading: isLoading,
        filekey: filekey,
      );
      if (response.statusCode == 200) {
        return json.decode(response.data)['Message'];
      } else {
        Utility.showMessage(json.decode(response.data)['Message'].toString(),
            MessageType.error, () => null, '');
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<String?> removeBusinessPhoto({
    bool isLoading = false,
    required String filekey,
  }) async {
    try {
      var response = await _dataRepository.removeBusinessPhoto(
        isLoading: isLoading,
        filekey: filekey,
      );
      if (response.statusCode == 200) {
        return json.decode(response.data)['Message'];
      } else {
        Utility.showMessage(json.decode(response.data)['Message'].toString(),
            MessageType.error, () => null, '');
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<String?> removeBusinessVideo({
    bool isLoading = false,
    required String filekey,
  }) async {
    try {
      var response = await _dataRepository.removeBusinessVideo(
        isLoading: isLoading,
        filekey: filekey,
      );
      if (response.statusCode == 200) {
        return json.decode(response.data)['Message'];
      } else {
        Utility.showMessage(json.decode(response.data)['Message'].toString(),
            MessageType.error, () => null, '');
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<FindFirendsLocationModel?> postFindFriendsLocation({
    bool isLoading = false,
    required double latitude,
    required double longitude,
  }) async {
    try {
      var response = await _dataRepository.postFindFriendsLocation(
        isLoading: isLoading,
        latitude: latitude,
        longitude: longitude,
      );
      var findFirendsLocationModel =
          findFirendsLocationModelFromJson(response.data);
      if (findFirendsLocationModel.status == 200) {
        return findFirendsLocationModel;
      } else {
        Utility.showMessage(findFirendsLocationModel.message.toString(),
            MessageType.error, () => null, '');
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<FindFirendsListModel?> postFindFriendsList({
    bool isLoading = false,
    required int page,
    required int limit,
    required String search,
  }) async {
    try {
      var response = await _dataRepository.postFindFriendsList(
        isLoading: isLoading,
        page: page,
        limit: limit,
        search: search,
      );
      var findFirendsList = findFirendsListModelFromJson(response.data);
      if (findFirendsList.status == 200) {
        return findFirendsList;
      } else {
        Utility.showMessage(findFirendsList.message.toString(),
            MessageType.error, () => null, '');
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<SendRequestModel?> sendNewFriendRequest({
    bool isLoading = false,
    required String receiverid,
    required String message,
    required String product,
    required AuthorizedPermissions authorizedPermissions,
  }) async {
    try {
      var response = await _dataRepository.sendNewFriendRequest(
        receiverid: receiverid,
        message: message,
        product: product,
        authorizedPermissions: authorizedPermissions,
        isLoading: isLoading,
      );
      var sendRequestModel = sendRequestModelFromJson(response.data);
      if (sendRequestModel.status == 200) {
        return sendRequestModel;
      } else {
        Utility.showMessage(sendRequestModel.message.toString(),
            MessageType.error, () => null, '');
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> cancelSentRequest({
    bool isLoading = false,
    required String friendrequestid,
  }) async {
    try {
      var response = await _dataRepository.cancelSentRequest(
        friendrequestid: friendrequestid,
        isLoading: isLoading,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<SentFirendsListModel?> sentRequestList({
    bool isLoading = false,
    required int page,
    required int limit,
  }) async {
    try {
      var response = await _dataRepository.sentRequestList(
        isLoading: isLoading,
        page: page,
        limit: limit,
      );
      var sentFirendsListModel = sentFirendsListModelFromJson(response.data);
      if (sentFirendsListModel.status == 200) {
        return sentFirendsListModel;
      } else {
        Utility.showMessage(sentFirendsListModel.message.toString(),
            MessageType.error, () => null, '');
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<BlockedUserListModel?> blockedUserList({
    bool isLoading = false,
    required int page,
    required int limit,
  }) async {
    try {
      var response = await _dataRepository.blockedUserList(
        isLoading: isLoading,
        page: page,
        limit: limit,
      );
      var blockedUserListModel = blockedUserListModelFromJson(response.data);
      if (blockedUserListModel.status == 200) {
        return blockedUserListModel;
      } else {
        Utility.showMessage(blockedUserListModel.message.toString(),
            MessageType.error, () => null, '');
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ReceiveRequestModel?> receivedrRequestList({
    bool isLoading = false,
    required int page,
    required int limit,
  }) async {
    try {
      var response = await _dataRepository.receivedrRequestList(
        isLoading: isLoading,
        page: page,
        limit: limit,
      );
      var receiveRequestModel = receiveRequestModelFromJson(response.data);
      if (receiveRequestModel.status == 200) {
        return receiveRequestModel;
      } else {
        Utility.showMessage(receiveRequestModel.message.toString(),
            MessageType.error, () => null, '');
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> respondFriendsRequest({
    bool isLoading = false,
    required String friendrequestid,
    required String status,
    required AuthorizedPermissions authorizedPermissions,
  }) async {
    try {
      var response = await _dataRepository.respondFriendsRequest(
        isLoading: isLoading,
        friendrequestid: friendrequestid,
        status: status,
        authorizedPermissions: authorizedPermissions,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> updateFriendsRequest({
    bool isLoading = false,
    required String friendrequestid,
    required String status,
    required AuthorizedPermissions authorizedPermissions,
  }) async {
    try {
      var response = await _dataRepository.updateFriendsRequest(
        isLoading: isLoading,
        friendrequestid: friendrequestid,
        status: status,
        authorizedPermissions: authorizedPermissions,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> unblockUser({
    bool isLoading = false,
    required String blockeduserid,
  }) async {
    try {
      var response = await _dataRepository.unblockUser(
        isLoading: isLoading,
        blockeduserid: blockeduserid,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<GetBusinessListModel?> getBusinessList({
    bool isLoading = false,
  }) async {
    try {
      var response = await _dataRepository.getBusinessList(
        isLoading: isLoading,
      );
      var getBusinessList = getBusinessListModelFromJson(response.data);
      if (getBusinessList.status == 200) {
        return getBusinessList;
      } else {
        Utility.showMessage(getBusinessList.message.toString(),
            MessageType.error, () => null, '');
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<GetOneBusinessModel?> getOneBusiness({
    bool isLoading = false,
    required String businessid,
  }) async {
    try {
      var response = await _dataRepository.getOneBusiness(
        businessid: businessid,
        isLoading: isLoading,
      );
      var getOneBusinessModel = getOneBusinessModelFromJson(response.data);
      if (getOneBusinessModel.status == 200) {
        return getOneBusinessModel;
      } else {
        Utility.showMessage(getOneBusinessModel.message.toString(),
            MessageType.error, () => null, '');
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> removeBusiness({
    bool isLoading = false,
    required String businessid,
  }) async {
    try {
      var response = await _dataRepository.removeBusiness(
        businessid: businessid,
        isLoading: isLoading,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<MyFriendsModel?> myFriendsList({
    bool isLoading = false,
    required int page,
    required int limit,
    required String search,
    required bool unreadMessages,
    required bool contactFriend,
    required bool fefieldFriend,
    required bool receiverFriend,
    required bool senderFriend,
  }) async {
    try {
      var response = await _dataRepository.myFriendsList(
        page: page,
        limit: limit,
        search: search,
        unreadMessages: unreadMessages,
        contactFriend: contactFriend,
        fefieldFriend: fefieldFriend,
        receiverFriend: receiverFriend,
        senderFriend: senderFriend,
        isLoading: isLoading,
      );
      // Debug logging to trace why controller may receive `null`.
      try {
        print('Repository.myFriendsList - raw response.data: ${response.data}');
        print(
            'Repository.myFriendsList - response.data runtimeType: ${response.data.runtimeType}');
      } catch (e) {
        print('Repository.myFriendsList - error printing response.data: $e');
      }

      MyFriendsModel? myFriendsModel;
      try {
        myFriendsModel = myFriendsModelFromJson(response.data);
        print(
            'Repository.myFriendsList - parsed status: ${myFriendsModel.status}, list length: ${myFriendsModel.data?.list?.length}');
      } catch (e, st) {
        print('Repository.myFriendsList - parse error: $e');
        print(st);
        try {
          final s = response.data?.toString() ?? '';
          final preview =
              s.length > 300 ? s.substring(0, 300) + '...(truncated)' : s;
          print('Repository.myFriendsList - response.data preview: $preview');
        } catch (e2) {
          print(
              'Repository.myFriendsList - error while previewing response.data: $e2');
        }
        return null;
      }

      if (myFriendsModel != null && myFriendsModel.status == 200) {
        return myFriendsModel;
      } else if (myFriendsModel != null) {
        Utility.showMessage(myFriendsModel.message.toString(),
            MessageType.error, () => null, '');
        return null;
      } else {
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> createGroupApi({
    bool isLoading = false,
    required String groupid,
    required String profileimage,
    required String name,
    required String description,
    required List<String> members,
    required AuthorizedPermissions authorizedPermissions,
  }) async {
    try {
      var response = await _dataRepository.createGroupApi(
        isLoading: isLoading,
        groupid: groupid,
        profileimage: profileimage,
        name: name,
        description: description,
        members: members,
        authorizedPermissions: authorizedPermissions,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<String?> uploadGroupProfile({
    bool isLoading = false,
    required String filePath,
  }) async {
    try {
      var response = await _dataRepository.uploadGroupProfile(
        isLoading: isLoading,
        filePath: filePath,
      );
      if (response.statusCode == 200) {
        return json.decode(response.data)['Data']['url'];
      } else {
        Utility.showMessage(json.decode(response.data)['Message'].toString(),
            MessageType.error, () => null, '');
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<GroupUserListModel?> groupsChatList({
    bool isLoading = false,
    required int page,
    required int limit,
    required String search,
    required bool isunreadmessagefilteronoff,
  }) async {
    try {
      var response = await _dataRepository.groupsChatList(
        page: page,
        limit: limit,
        search: search,
        isunreadmessagefilteronoff: isunreadmessagefilteronoff,
        isLoading: isLoading,
      );
      var groupUserListModel = groupUserListModelFromJson(response.data);
      if (groupUserListModel.status == 200) {
        return groupUserListModel;
      } else {
        Utility.showMessage(groupUserListModel.message.toString(),
            MessageType.error, () => null, '');
        return groupUserListModel;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<GroupUserListModel?> postGroupListWithoutPaging({
    bool isLoading = false,
    required String search,
    required bool isunreadmessagefilteronoff,
  }) async {
    try {
      var response = await _dataRepository.postGroupListWithoutPaging(
        search: search,
        isunreadmessagefilteronoff: isunreadmessagefilteronoff,
        isLoading: isLoading,
      );
      var groupUserListModel = groupUserListModelFromJson(response.data);
      if (groupUserListModel.status == 200) {
        return groupUserListModel;
      } else {
        Utility.showMessage(groupUserListModel.message.toString(),
            MessageType.error, () => null, '');
        return groupUserListModel;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<GetOneGroupModel?> getOneGroup({
    bool isLoading = false,
    required String groupid,
  }) async {
    try {
      var response = await _dataRepository.getOneGroup(
        groupid: groupid,
        isLoading: isLoading,
      );
      var getOneGroupModel = getOneGroupModelFromJson(response.data);
      if (getOneGroupModel.status == 200) {
        return getOneGroupModel;
      } else {
        Utility.showMessage(getOneGroupModel.message.toString(),
            MessageType.error, () => null, '');
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> groupSetManager({
    bool isLoading = false,
    required String groupid,
    required String userid,
  }) async {
    try {
      var response = await _dataRepository.groupSetManager(
        groupid: groupid,
        userid: userid,
        isLoading: isLoading,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> groupUnSetManager({
    bool isLoading = false,
    required String groupid,
    required String userid,
  }) async {
    try {
      var response = await _dataRepository.groupUnSetManager(
        groupid: groupid,
        userid: userid,
        isLoading: isLoading,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> leaveGroup({
    bool isLoading = false,
    required String groupid,
  }) async {
    try {
      var response = await _dataRepository.leaveGroup(
        groupid: groupid,
        isLoading: isLoading,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> addMemberGroup({
    bool isLoading = false,
    required String groupid,
    required List<String> membersList,
  }) async {
    try {
      var response = await _dataRepository.addMemberGroup(
        isLoading: isLoading,
        groupid: groupid,
        membersList: membersList,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> removeMemberGroup({
    bool isLoading = false,
    required String groupid,
    required List<String> membersList,
  }) async {
    try {
      var response = await _dataRepository.removeMemberGroup(
        isLoading: isLoading,
        groupid: groupid,
        membersList: membersList,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> groupSetPermission({
    bool isLoading = false,
    required String groupid,
    required AuthorizedPermissions authorizedPermissions,
  }) async {
    try {
      var response = await _dataRepository.groupSetPermission(
        isLoading: isLoading,
        groupid: groupid,
        authorizedPermissions: authorizedPermissions,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> removeGroupProfile({
    bool isLoading = false,
    required String filekey,
  }) async {
    try {
      var response = await _dataRepository.removeGroupProfile(
        isLoading: isLoading,
        filekey: filekey,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<GetOneFriendsModel?> getOneFriends({
    bool isLoading = false,
    required String userid,
  }) async {
    debugPrint(
        "[ANTIGRAVITY_DEBUG] Repository.getOneFriends called for userid: $userid");
    try {
      var response = await _dataRepository.getOneFriends(
        isLoading: isLoading,
        userid: userid,
      );
      debugPrint(
          "[ANTIGRAVITY_DEBUG] Repository getOneFriends status: ${response.statusCode}");
      debugPrint(
          "[ANTIGRAVITY_DEBUG] Repository getOneFriends raw data: ${response.data}");
      var getOneFriendsModel = getOneFriendsModelFromJson(response.data);
      if (getOneFriendsModel.status == 200) {
        return getOneFriendsModel;
      } else {
        debugPrint(
            "[ANTIGRAVITY_DEBUG] Repository getOneFriends status not 200: ${getOneFriendsModel.status}");
        Utility.showMessage(getOneFriendsModel.message.toString(),
            MessageType.error, () => null, '');
        return null;
      }
    } catch (e, stack) {
      debugPrint("[ANTIGRAVITY_DEBUG] Error in Repository.getOneFriends: $e");
      debugPrint("[ANTIGRAVITY_DEBUG] Stack trace: $stack");
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<GetUserStatusModel?> getOneUserStatus({
    bool isLoading = false,
    required String userid,
  }) async {
    try {
      var response = await _dataRepository.getOneUserStatus(
        isLoading: isLoading,
        userid: userid,
      );
      var model = getUserStatusModelFromJson(response.data);
      if (model.status == 200) {
        return model;
      } else {
        Utility.showMessage(
            model.message.toString(), MessageType.error, () => null, '');
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ChatListsModel?> getChatLists({
    bool isLoading = false,
    required String userid,
    required String search,
    required int page,
    required int limit,
  }) async {
    try {
      var response = await _dataRepository.getChatLists(
        isLoading: isLoading,
        userid: userid,
        page: page,
        limit: limit,
        search: search,
      );
      var chatListsModel = chatListsModelFromJson(response.data);
      if (chatListsModel.status == 200) {
        return chatListsModel;
      } else {
        Utility.showMessage(chatListsModel.message.toString(),
            MessageType.error, () => null, '');
        return null;
      }
    } catch (e, stack) {
      debugPrint("[ANTIGRAVITY_DEBUG] Exception in getChatLists parsing: $e\n$stack");
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<GetOnePollsModel?> createPolls({
    bool isLoading = false,
    required String pollid,
    required String polltitle,
    required List<String> optionsList,
    required bool allowmultipleans,
  }) async {
    try {
      var response = await _dataRepository.createPolls(
        isLoading: isLoading,
        pollid: pollid,
        polltitle: polltitle,
        optionsList: optionsList,
        allowmultipleans: allowmultipleans,
      );
      var getOnePollsModel = getOnePollsModelFromJson(response.data);
      if (getOnePollsModel.status == 200) {
        return getOnePollsModel;
      } else {
        Utility.showMessage(getOnePollsModel.message.toString(),
            MessageType.error, () => null, '');
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<GetOnePollsModel?> getOnePoll({
    bool isLoading = false,
    required String pollid,
  }) async {
    try {
      var response = await _dataRepository.getOnePoll(
        isLoading: isLoading,
        pollid: pollid,
      );
      var getOnePollsModel = getOnePollsModelFromJson(response.data);
      if (getOnePollsModel.status == 200) {
        return getOnePollsModel;
      } else {
        Utility.showMessage(getOnePollsModel.message.toString(),
            MessageType.error, () => null, '');
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ChatListsDoc?> sendMessage({
    required String receiverid,
    String? message,
    String? product,
    String? latitude,
    String? longitude,
    String? pollid,
    String? context,
    List<String>? usersList,
    List<ImageFormData>? mediaFileList,
    PhoneContact? phonecontactData,
    bool isLoading = false,
  }) async {
    try {
      var response = await _dataRepository.sendMessage(
        isLoading: isLoading,
        receiverid: receiverid,
        message: message,
        product: product,
        latitude: latitude,
        longitude: longitude,
        pollid: pollid,
        context: context,
        usersList: usersList,
        mediaFileList: mediaFileList,
        phonecontactData: phonecontactData,
      );
      if (!response.hasError) {
        return ChatListsDoc.fromJson(json.decode(response.data)['Data']);
      } else {
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<MyFriendsModel?> myFriendsWithoutPaginationList({
    bool isLoading = false,
    required String search,
    required bool unreadMessages,
    required bool contactFriend,
    required bool fefieldFriend,
    required bool receiverFriend,
    required bool senderFriend,
  }) async {
    try {
      var response = await _dataRepository.myFriendsWithoutPaginationList(
        search: search,
        unreadMessages: unreadMessages,
        contactFriend: contactFriend,
        fefieldFriend: fefieldFriend,
        receiverFriend: receiverFriend,
        senderFriend: senderFriend,
        isLoading: isLoading,
      );
      var myFriendsModel = myFriendsModelFromJson(response.data);
      if (myFriendsModel.status == 200) {
        return myFriendsModel;
      } else {
        Utility.showMessage(myFriendsModel.message.toString(),
            MessageType.error, () => null, '');
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> postDeliveredMessage({
    required String messageid,
    bool isLoading = false,
  }) async {
    try {
      var response = await _dataRepository.postDeliveredMessage(
        isLoading: isLoading,
        messageid: messageid,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> postSeenMessage({
    required String messageid,
    bool isLoading = false,
  }) async {
    try {
      var response = await _dataRepository.postSeenMessage(
        isLoading: isLoading,
        messageid: messageid,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> sendGroupMessage({
    required String receiverid,
    String? message,
    String? product,
    String? latitude,
    String? longitude,
    String? pollid,
    String? context,
    List<String>? usersList,
    List<ImageFormData>? mediaFileList,
    PhoneContact? phonecontactData,
    bool isLoading = false,
  }) async {
    try {
      var response = await _dataRepository.sendGroupMessage(
        isLoading: isLoading,
        receiverid: receiverid,
        message: message,
        product: product,
        latitude: latitude,
        longitude: longitude,
        pollid: pollid,
        context: context,
        usersList: usersList,
        mediaFileList: mediaFileList,
        phonecontactData: phonecontactData,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ChatListsDoc?> postChatSendBulkMessage({
    required String receiverid,
    String? message,
    String? context,
    List<ImageFormData>? mediaFileList,
    bool isLoading = false,
  }) async {
    try {
      var response = await _dataRepository.postChatSendBulkMessage(
        isLoading: isLoading,
        receiverid: receiverid,
        message: message,
        context: context,
        mediaFileList: mediaFileList,
      );
      if (!response.hasError) {
        return ChatListsDoc.fromJson(json.decode(response.data)['Data']);
      } else {
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ChatListsDoc?> postGroupChatSendBulkMessage({
    required String receiverid,
    String? message,
    String? context,
    List<ImageFormData>? mediaFileList,
    bool isLoading = false,
  }) async {
    try {
      var response = await _dataRepository.postGroupChatSendBulkMessage(
        isLoading: isLoading,
        receiverid: receiverid,
        message: message,
        context: context,
        mediaFileList: mediaFileList,
      );
      if (!response.hasError) {
        return ChatListsDoc.fromJson(json.decode(response.data)['Data']);
      } else {
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ChatListsModel?> getGroupChatLists({
    bool isLoading = false,
    required String groupid,
    required String search,
    required int page,
    required int limit,
  }) async {
    try {
      var response = await _dataRepository.getGroupChatLists(
        isLoading: isLoading,
        groupid: groupid,
        page: page,
        limit: limit,
        search: search,
      );
      var groupChatListModel = chatListsModelFromJson(response.data);
      if (groupChatListModel.status == 200) {
        return groupChatListModel;
      } else {
        Utility.showMessage(groupChatListModel.message.toString(),
            MessageType.error, () => null, '');
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> postGroupDeliveredMessage({
    required String messageid,
    bool isLoading = false,
  }) async {
    try {
      var response = await _dataRepository.postGroupDeliveredMessage(
        isLoading: isLoading,
        messageid: messageid,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> postGroupSeenMessage({
    required String messageid,
    bool isLoading = false,
  }) async {
    try {
      var response = await _dataRepository.postGroupSeenMessage(
        isLoading: isLoading,
        messageid: messageid,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<FriendProductModel?> postfriendsproducts({
    bool isLoading = false,
    required String search,
    required String userid,
    required String business,
    required List<String> parentcategory,
    required List<String> childcategory,
  }) async {
    try {
      var response = await _dataRepository.postfriendsproducts(
        search: search,
        userid: userid,
        business: business,
        parentcategory: parentcategory,
        childcategory: childcategory,
        isLoading: isLoading,
      );
      var friendProductModel = friendProductModelFromJson(response.data);
      if (friendProductModel.status == 200) {
        return friendProductModel;
      } else {
        Utility.showMessage(friendProductModel.message.toString(),
            MessageType.error, () => null, '');
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> postChatDeleteMessage({
    required String messageid,
    required String deletefor,
    bool isLoading = false,
  }) async {
    try {
      var response = await _dataRepository.postChatDeleteMessage(
        isLoading: isLoading,
        messageid: messageid,
        deletefor: deletefor,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> postChatMessageEdit({
    required String messageid,
    required String message,
    bool isLoading = false,
  }) async {
    try {
      var response = await _dataRepository.postChatMessageEdit(
        isLoading: isLoading,
        messageid: messageid,
        message: message,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ReactionChatModel?> postChatBookmarkAndRemove({
    required String messageid,
    bool isLoading = false,
  }) async {
    try {
      var response = await _dataRepository.postChatBookmarkAndRemove(
        isLoading: isLoading,
        messageid: messageid,
      );
      var reactionChatModel = reactionChatModelFromJson(response.data);
      if (reactionChatModel.status == 200) {
        return reactionChatModel;
      } else {
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ReactionChatModel?> postChatFavoriteAndRemove({
    required String messageid,
    bool isLoading = false,
  }) async {
    try {
      var response = await _dataRepository.postChatFavoriteAndRemove(
        isLoading: isLoading,
        messageid: messageid,
      );
      var reactionChatModel = reactionChatModelFromJson(response.data);
      if (reactionChatModel.status == 200) {
        return reactionChatModel;
      } else {
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ReactionChatModel?> postChatMessageReaction({
    required String messageid,
    required String reaction,
    bool isLoading = false,
  }) async {
    try {
      var response = await _dataRepository.postChatMessageReaction(
        isLoading: isLoading,
        messageid: messageid,
        reaction: reaction,
      );
      var reactionChatModel = reactionChatModelFromJson(response.data);
      if (reactionChatModel.status == 200) {
        return reactionChatModel;
      } else {
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ReactionChatModel?> postChatMessageUnReaction({
    required String messageid,
    bool isLoading = false,
  }) async {
    try {
      var response = await _dataRepository.postChatMessageUnReaction(
        isLoading: isLoading,
        messageid: messageid,
      );
      var reactionChatModel = reactionChatModelFromJson(response.data);
      if (reactionChatModel.status == 200) {
        return reactionChatModel;
      } else {
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> postChatGroupDeleteMessage({
    required String messageid,
    required String deletefor,
    bool isLoading = false,
  }) async {
    try {
      var response = await _dataRepository.postChatGroupDeleteMessage(
        isLoading: isLoading,
        messageid: messageid,
        deletefor: deletefor,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> postChatGroupMessageEdit({
    required String messageid,
    required String message,
    bool isLoading = false,
  }) async {
    try {
      var response = await _dataRepository.postChatGroupMessageEdit(
        isLoading: isLoading,
        messageid: messageid,
        message: message,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ReactionChatModel?> postChatGroupBookmarkRemove({
    required String messageid,
    bool isLoading = false,
  }) async {
    try {
      var response = await _dataRepository.postChatGroupBookmarkRemove(
        isLoading: isLoading,
        messageid: messageid,
      );
      var reactionChatModel = reactionChatModelFromJson(response.data);
      if (reactionChatModel.status == 200) {
        return reactionChatModel;
      } else {
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ReactionChatModel?> postChatGroupFavoriteRemove({
    required String messageid,
    bool isLoading = false,
  }) async {
    try {
      var response = await _dataRepository.postChatGroupFavoriteRemove(
        isLoading: isLoading,
        messageid: messageid,
      );
      var reactionChatModel = reactionChatModelFromJson(response.data);
      if (reactionChatModel.status == 200) {
        return reactionChatModel;
      } else {
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ReactionChatModel?> postChatGroupMessageReaction({
    required String messageid,
    required String reaction,
    bool isLoading = false,
  }) async {
    try {
      var response = await _dataRepository.postChatGroupMessageReaction(
        isLoading: isLoading,
        messageid: messageid,
        reaction: reaction,
      );
      var reactionChatModel = reactionChatModelFromJson(response.data);
      if (reactionChatModel.status == 200) {
        return reactionChatModel;
      } else {
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ReactionChatModel?> postChatGroupMessageUnReaction({
    required String messageid,
    bool isLoading = false,
  }) async {
    try {
      var response = await _dataRepository.postChatGroupMessageUnReaction(
        isLoading: isLoading,
        messageid: messageid,
      );
      var reactionChatModel = reactionChatModelFromJson(response.data);
      if (reactionChatModel.status == 200) {
        return reactionChatModel;
      } else {
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> postChatPinUnPin({
    required String userid,
    required bool isPinned,
    bool isLoading = false,
  }) async {
    try {
      var response = await _dataRepository.postChatPinUnPin(
        isLoading: isLoading,
        userid: userid,
        isPinned: isPinned,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> postGroupChatPinUnPin({
    required String groupid,
    required bool isPinned,
    bool isLoading = false,
  }) async {
    try {
      var response = await _dataRepository.postGroupChatPinUnPin(
        isLoading: isLoading,
        groupid: groupid,
        isPinned: isPinned,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> postChatForward({
    bool isLoading = false,
    required String messageid,
    required List<String> forwardto,
  }) async {
    try {
      var response = await _dataRepository.postChatForward(
        isLoading: isLoading,
        messageid: messageid,
        forwardto: forwardto,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  // post call initiate api
  Future<GetCallInitiatedDataModel?> postCallInitaite({
    bool isLoading = false,
    required String receiverId,
    required bool isVideoCall,
    required bool isAudioCall,
    required bool isGroupCall,
  }) async {
    try {
      var response = await _dataRepository.postCallInitaite(
        isLoading: isLoading,
        isAudioCall: isAudioCall,
        isGroupCall: isGroupCall,
        isVideoCall: isVideoCall,
        receiverId: receiverId,
      );
      print("[CALL_INITIATE] Raw status: ${response.statusCode}, data: ${response.data}");
      var getCallInitiatedDataModel =
          getCallInitiatedDataModelFromJson(response.data);
      if (getCallInitiatedDataModel.status == 200) {
        return getCallInitiatedDataModel;
      } else {
        print("[CALL_INITIATE] Status not 200: ${getCallInitiatedDataModel.status} ${getCallInitiatedDataModel.message}");
        return null;
      }
    } catch (e, stack) {
      print("[CALL_INITIATE] Exception during initiate: $e\n$stack");
      Utility.closeDialog();
      return null;
    }
  }

  Future<CallHistoryModel?> postCallHistory({
    bool isLoading = false,
    required int page,
    required int limit,
    required String calltype,
  }) async {
    try {
      var response = await _dataRepository.postCallHistory(
        page: page,
        limit: limit,
        calltype: calltype,
        isLoading: isLoading,
      );
      var callHistoryModel = callHistoryModelFromJson(response.data);
      if (callHistoryModel.status == 200) {
        return callHistoryModel;
      } else {
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> postChatLeaveCall({
    bool isLoading = false,
    required String callid,
  }) async {
    try {
      var response = await _dataRepository.postChatLeaveCall(
        callid: callid,
        isLoading: isLoading,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> postChatMissedCall({
    bool isLoading = false,
    required String callid,
  }) async {
    try {
      var response = await _dataRepository.postChatMissedCall(
        callid: callid,
        isLoading: isLoading,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> postChatJoinCall({
    bool isLoading = false,
    required String callid,
  }) async {
    try {
      var response = await _dataRepository.postChatJoinCall(
        callid: callid,
        isLoading: isLoading,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> postKickMember({
    bool isLoading = false,
    required String callid,
    required String memberid,
  }) async {
    try {
      var response = await _dataRepository.postKickMember(
        callid: callid,
        memberid: memberid,
        isLoading: isLoading,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<CallHistoryByUserModel?> postHistoryByUser({
    bool isLoading = false,
    required String userid,
  }) async {
    try {
      var response = await _dataRepository.postHistoryByUser(
        userid: userid,
        isLoading: isLoading,
      );
      var callHistoryByUserModel =
          callHistoryByUserModelFromJson(response.data);
      if (callHistoryByUserModel.status != 200 &&
          (callHistoryByUserModel.message ?? "").isNotEmpty) {
        Utility.errorMessage(callHistoryByUserModel.message ?? "");
      }
      return callHistoryByUserModel;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<CallHistoryByUserModel?> postHistoryByGroup({
    bool isLoading = false,
    required String groupid,
  }) async {
    try {
      var response = await _dataRepository.postHistoryByGroup(
        groupid: groupid,
        isLoading: isLoading,
      );
      var callHistoryByUserModel =
          callHistoryByUserModelFromJson(response.data);
      if (callHistoryByUserModel.status != 200 &&
          (callHistoryByUserModel.message ?? "").isNotEmpty) {
        Utility.errorMessage(callHistoryByUserModel.message ?? "");
      }
      return callHistoryByUserModel;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<BroadcastListModel?> postListBroadcast({
    bool isLoading = false,
    required int page,
    required int limit,
    required String search,
  }) async {
    try {
      var response = await _dataRepository.postListBroadcast(
        page: page,
        limit: limit,
        search: search,
        isLoading: isLoading,
      );
      var broadcastListModel = broadcastListModelFromJson(response.data);
      if (broadcastListModel.status == 200) {
        return broadcastListModel;
      } else {
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<GetOneBroadcastModel?> getOneBroadcast({
    bool isLoading = false,
    required String broadcastid,
  }) async {
    try {
      var response = await _dataRepository.getOneBroadcast(
        broadcastid: broadcastid,
        isLoading: isLoading,
      );
      var broadcastListModel = getOneBroadcastModelFromJson(response.data);
      if (broadcastListModel.status == 200) {
        return broadcastListModel;
      } else {
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> postAddBroadcast({
    bool isLoading = false,
    required String broadcastid,
    required String broadcasttitle,
    required List<String> membersList,
  }) async {
    try {
      var response = await _dataRepository.postAddBroadcast(
        broadcastid: broadcastid,
        broadcasttitle: broadcasttitle,
        membersList: membersList,
        isLoading: isLoading,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> postPinUnPinBroadcast({
    bool isLoading = false,
    required String broadcastid,
  }) async {
    try {
      var response = await _dataRepository.postPinUnPinBroadcast(
        broadcastid: broadcastid,
        isLoading: isLoading,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> postDeleteBroadcast({
    bool isLoading = false,
    required String broadcastid,
  }) async {
    try {
      var response = await _dataRepository.postDeleteBroadcast(
        broadcastid: broadcastid,
        isLoading: isLoading,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ChatListsModel?> postChatListBroadcast({
    bool isLoading = false,
    required int page,
    required int limit,
    required String broadcastid,
  }) async {
    try {
      var response = await _dataRepository.postChatListBroadcast(
        page: page,
        limit: limit,
        broadcastid: broadcastid,
        isLoading: isLoading,
      );
      var broadcastListModel = chatListsModelFromJson(response.data);
      if (broadcastListModel.status == 200) {
        return broadcastListModel;
      } else {
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ChatListsDoc?> postSendMessageBroadcast({
    required String broadcastid,
    String? message,
    String? product,
    String? latitude,
    String? longitude,
    String? pollid,
    String? context,
    List<String>? usersList,
    List<ImageFormData>? mediaFileList,
    bool isLoading = false,
  }) async {
    try {
      var response = await _dataRepository.postSendMessageBroadcast(
        broadcastid: broadcastid,
        message: message,
        product: product,
        latitude: latitude,
        longitude: longitude,
        usersList: usersList,
        pollid: pollid,
        context: context,
        mediaFileList: mediaFileList,
        isLoading: isLoading,
      );
      if (!response.hasError) {
        return ChatListsDoc.fromJson(json.decode(response.data)['Data']);
      } else {
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ChatListsDoc?> postSendMultiMediaBroadcast({
    required String broadcastid,
    String? message,
    String? context,
    List<ImageFormData>? mediaFileList,
    bool isLoading = false,
  }) async {
    try {
      var response = await _dataRepository.postSendMultiMediaBroadcast(
        broadcastid: broadcastid,
        message: message,
        context: context,
        mediaFileList: mediaFileList,
        isLoading: isLoading,
      );
      if (!response.hasError) {
        print(response.data);
        return ChatListsDoc.fromJson(json.decode(response.data)['Data']);
      } else {
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> postSendFcmApi({
    required String registrationToken,
    required String userName,
    required String callid,
    required String agoratoken,
    required String type,
    required String banner,
    required String fromid,
    required String toid,
    required String agorachannelName,
    required String isaudiocall,
    required String isgroupcall,
    required String isvideocall,
    required String authToken,
    bool isLoading = false,
  }) async {
    try {
      var response = await _dataRepository.postSendFcmApi(
        registrationToken: registrationToken,
        userName: userName,
        callid: callid,
        agoratoken: agoratoken,
        type: type,
        banner: banner,
        fromid: fromid,
        toid: toid,
        agorachannelName: agorachannelName,
        isaudiocall: isaudiocall,
        isgroupcall: isgroupcall,
        isvideocall: isvideocall,
        authToken: authToken,
        isLoading: isLoading,
      );
      return response;
    } catch (e) {
      print(e);
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> postOnlineOffline({
    bool isLoading = false,
    required bool isonline,
  }) async {
    try {
      var response = await _dataRepository.postOnlineOffline(
        isonline: isonline,
        isLoading: isLoading,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ChatListsModel?> postPhotoVideo({
    bool isLoading = false,
    required String userid,
    required int page,
    required int limit,
  }) async {
    try {
      var response = await _dataRepository.postPhotoVideo(
        userid: userid,
        page: page,
        limit: limit,
        isLoading: isLoading,
      );
      var broadcastListModel = chatListsModelFromJson(response.data);
      if (broadcastListModel.status == 200) {
        return broadcastListModel;
      } else {
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ChatListsModel?> postAudios({
    bool isLoading = false,
    required String userid,
    required int page,
    required int limit,
  }) async {
    try {
      var response = await _dataRepository.postAudios(
        userid: userid,
        page: page,
        limit: limit,
        isLoading: isLoading,
      );
      var broadcastListModel = chatListsModelFromJson(response.data);
      if (broadcastListModel.status == 200) {
        return broadcastListModel;
      } else {
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ChatListsModel?> postDocs({
    bool isLoading = false,
    required String userid,
    required int page,
    required int limit,
  }) async {
    try {
      var response = await _dataRepository.postDocs(
        userid: userid,
        page: page,
        limit: limit,
        isLoading: isLoading,
      );
      var broadcastListModel = chatListsModelFromJson(response.data);
      if (broadcastListModel.status == 200) {
        return broadcastListModel;
      } else {
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ChatListsModel?> postLinks({
    bool isLoading = false,
    required String userid,
    required int page,
    required int limit,
  }) async {
    try {
      var response = await _dataRepository.postLinks(
        userid: userid,
        page: page,
        limit: limit,
        isLoading: isLoading,
      );
      var broadcastListModel = chatListsModelFromJson(response.data);
      if (broadcastListModel.status == 200) {
        return broadcastListModel;
      } else {
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ChatListsModel?> listFavoriteMessage({
    bool isLoading = false,
    required String userid,
    required int page,
    required int limit,
  }) async {
    try {
      var response = await _dataRepository.listFavoriteMessage(
        userid: userid,
        page: page,
        limit: limit,
        isLoading: isLoading,
      );
      var broadcastListModel = chatListsModelFromJson(response.data);
      if (broadcastListModel.status == 200) {
        return broadcastListModel;
      } else {
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ChatListsModel?> listGroupFavoriteMessage({
    bool isLoading = false,
    required String groupid,
    required int page,
    required int limit,
  }) async {
    try {
      var response = await _dataRepository.listGroupFavoriteMessage(
        groupid: groupid,
        page: page,
        limit: limit,
        isLoading: isLoading,
      );
      var broadcastListModel = chatListsModelFromJson(response.data);
      if (broadcastListModel.status == 200) {
        return broadcastListModel;
      } else {
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ChatListsModel?> listChatBookmarkMessage({
    bool isLoading = false,
    required int page,
    required int limit,
  }) async {
    try {
      var response = await _dataRepository.listChatBookmarkMessage(
        page: page,
        limit: limit,
        isLoading: isLoading,
      );
      var broadcastListModel = chatListsModelFromJson(response.data);
      if (broadcastListModel.status == 200) {
        return broadcastListModel;
      } else {
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ChatListsModel?> listGroupBookmarkMessage({
    bool isLoading = false,
    required int page,
    required int limit,
  }) async {
    try {
      var response = await _dataRepository.listGroupBookmarkMessage(
        page: page,
        limit: limit,
        isLoading: isLoading,
      );
      var broadcastListModel = chatListsModelFromJson(response.data);
      if (broadcastListModel.status == 200) {
        return broadcastListModel;
      } else {
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> postPollVote({
    bool isLoading = false,
    required String pollid,
    required String optionid,
  }) async {
    try {
      var response = await _dataRepository.postPollVote(
        pollid: pollid,
        optionid: optionid,
        isLoading: isLoading,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ContactListModel?> postSyncContacts({
    required List<Map<String, dynamic>> contactLists,
    bool isLoading = false,
  }) async {
    try {
      debugPrint('🔍 Repository.postSyncContacts: Starting...');
      var response = await _dataRepository.postSyncContacts(
        contactLists: contactLists,
        isLoading: isLoading,
      );
      debugPrint(
          '🔍 Repository.postSyncContacts: Got response from _dataRepository');
      debugPrint(
          '🔍 Repository.postSyncContacts: response.data type = ${response.data.runtimeType}');

      // Pass the String directly - contactListModelFromJson handles JSON decoding internally
      var broadcastListModel = contactListModelFromJson(response.data);
      debugPrint(
          '🔍 Repository.postSyncContacts: Created model, status = ${broadcastListModel.status}');

      if (broadcastListModel.status == 200) {
        debugPrint(
            '🔍 Repository.postSyncContacts: Returning model with ${broadcastListModel.data?.length ?? 0} contacts');
        return broadcastListModel;
      } else {
        debugPrint(
            '🔍 Repository.postSyncContacts: Status not 200, returning null');
        return null;
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Repository.postSyncContacts: Exception caught!');
      debugPrint('❌ Repository.postSyncContacts: Error = $e');
      debugPrint('❌ Repository.postSyncContacts: StackTrace = $stackTrace');
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> postBrodcastDeleteMeg({
    bool isLoading = false,
    required String messageid,
  }) async {
    try {
      var response = await _dataRepository.postBrodcastDeleteMeg(
        messageid: messageid,
        isLoading: isLoading,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ReactionChatModel?> postBrodcastFavorite({
    bool isLoading = false,
    required String messageid,
  }) async {
    try {
      var response = await _dataRepository.postBrodcastFavorite(
        messageid: messageid,
        isLoading: isLoading,
      );
      var broadcastListModel = reactionChatModelFromJson(response.data);
      if (broadcastListModel.status == 200) {
        return broadcastListModel;
      } else {
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> postDeleteCall({
    bool isLoading = false,
    required String callid,
  }) async {
    try {
      var response = await _dataRepository.postDeleteCall(
        callid: callid,
        isLoading: isLoading,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> postLogout({
    bool isLoading = false,
  }) async {
    try {
      var response = await _dataRepository.postLogout(
        isLoading: isLoading,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> postSaveMetting({
    bool isLoading = false,
    required String meetingId,
    required String title,
    required String description,
    required String meetingstartdate,
    required String meetingstarttime,
    required String meetingenddate,
    required String meetingendtime,
    required List<String> memberList,
  }) async {
    try {
      var response = await _dataRepository.postSaveMetting(
        meetingId: meetingId,
        title: title,
        description: description,
        meetingstartdate: meetingstartdate,
        meetingstarttime: meetingstarttime,
        meetingenddate: meetingenddate,
        meetingendtime: meetingendtime,
        memberList: memberList,
        isLoading: isLoading,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ChatListsModel?> postListFavoriteMessages({
    bool isLoading = false,
    required String broadcastid,
    required int page,
    required int limit,
  }) async {
    try {
      var response = await _dataRepository.postListFavoriteMessages(
        broadcastid: broadcastid,
        page: page,
        limit: limit,
        isLoading: isLoading,
      );
      var broadcastListModel = chatListsModelFromJson(response.data);
      if (broadcastListModel.status == 200) {
        return broadcastListModel;
      } else {
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<BookmarkListModel?> postBookmarksList({
    bool isLoading = false,
    required int page,
    required int limit,
  }) async {
    try {
      var response = await _dataRepository.postBookmarksList(
        page: page,
        limit: limit,
        isLoading: isLoading,
      );
      var broadcastListModel = bookmarkListModelFromJson(response.data);
      if (broadcastListModel.status == 200) {
        return broadcastListModel;
      } else {
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ChatListsModel?> postBrodcastPhoto({
    bool isLoading = false,
    required String broadcastid,
    required int page,
    required int limit,
  }) async {
    try {
      var response = await _dataRepository.postBrodcastPhoto(
        broadcastid: broadcastid,
        page: page,
        limit: limit,
        isLoading: isLoading,
      );
      var broadcastListModel = chatListsModelFromJson(response.data);
      if (broadcastListModel.status == 200) {
        return broadcastListModel;
      } else {
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ChatListsModel?> postBrodcastAudio({
    bool isLoading = false,
    required String broadcastid,
    required int page,
    required int limit,
  }) async {
    try {
      var response = await _dataRepository.postBrodcastAudio(
        broadcastid: broadcastid,
        page: page,
        limit: limit,
        isLoading: isLoading,
      );
      var broadcastListModel = chatListsModelFromJson(response.data);
      if (broadcastListModel.status == 200) {
        return broadcastListModel;
      } else {
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ChatListsModel?> postBrodcastDoc({
    bool isLoading = false,
    required String broadcastid,
    required int page,
    required int limit,
  }) async {
    try {
      var response = await _dataRepository.postBrodcastDoc(
        broadcastid: broadcastid,
        page: page,
        limit: limit,
        isLoading: isLoading,
      );
      var broadcastListModel = chatListsModelFromJson(response.data);
      if (broadcastListModel.status == 200) {
        return broadcastListModel;
      } else {
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ChatListsModel?> postBrodcastLink({
    bool isLoading = false,
    required String broadcastid,
    required int page,
    required int limit,
  }) async {
    try {
      var response = await _dataRepository.postBrodcastLink(
        broadcastid: broadcastid,
        page: page,
        limit: limit,
        isLoading: isLoading,
      );
      var broadcastListModel = chatListsModelFromJson(response.data);
      if (broadcastListModel.status == 200) {
        return broadcastListModel;
      } else {
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> postBrodcastMemberRemove({
    bool isLoading = false,
    required String broadcastid,
    required String memberid,
  }) async {
    try {
      var response = await _dataRepository.postBrodcastMemberRemove(
        broadcastid: broadcastid,
        memberid: memberid,
        isLoading: isLoading,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<GetOneMeetingModel?> postMeetingGetOne({
    bool isLoading = false,
    required String meetingid,
  }) async {
    try {
      var response = await _dataRepository.postMeetingGetOne(
        meetingid: meetingid,
        isLoading: isLoading,
      );
      var hostMeetingListModel = getOneMeetingModelFromJson(response.data);
      if (hostMeetingListModel.status == 200) {
        return hostMeetingListModel;
      } else {
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<HostMeetingListModel?> postMeetingHostingList({
    bool isLoading = false,
    required int page,
    required int limit,
    required String search,
  }) async {
    try {
      var response = await _dataRepository.postMeetingHostingList(
        page: page,
        limit: limit,
        search: search,
        isLoading: isLoading,
      );
      var hostMeetingListModel = hostMeetingListModelFromJson(response.data);
      if (hostMeetingListModel.status == 200) {
        return hostMeetingListModel;
      } else {
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<HostMeetingListModel?> postMeetingJoinList({
    bool isLoading = false,
    required int page,
    required int limit,
    required String search,
  }) async {
    try {
      var response = await _dataRepository.postMeetingJoinList(
        page: page,
        limit: limit,
        search: search,
        isLoading: isLoading,
      );
      var hostMeetingListModel = hostMeetingListModelFromJson(response.data);
      if (hostMeetingListModel.status == 200) {
        return hostMeetingListModel;
      } else {
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<HostMeetingListModel?> postMeetingPastList({
    bool isLoading = false,
    required int page,
    required int limit,
    required String search,
  }) async {
    try {
      var response = await _dataRepository.postMeetingPastList(
        page: page,
        limit: limit,
        search: search,
        isLoading: isLoading,
      );
      var hostMeetingListModel = hostMeetingListModelFromJson(response.data);
      if (hostMeetingListModel.status == 200) {
        return hostMeetingListModel;
      } else {
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<GetOneMeetingModel?> postHostMeetingStart({
    bool isLoading = false,
    required String meetingid,
  }) async {
    try {
      var response = await _dataRepository.postHostMeetingStart(
        meetingid: meetingid,
        isLoading: isLoading,
      );
      var hostMeetingListModel = getOneMeetingModelFromJson(response.data);
      if (hostMeetingListModel.status == 200) {
        return hostMeetingListModel;
      } else {
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<GetOneMeetingModel?> postMeetingJoin({
    bool isLoading = false,
    required String meetingid,
  }) async {
    try {
      var response = await _dataRepository.postMeetingJoin(
        meetingid: meetingid,
        isLoading: isLoading,
      );
      var hostMeetingListModel = getOneMeetingModelFromJson(response.data);
      if (hostMeetingListModel.status == 200) {
        return hostMeetingListModel;
      } else {
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<GetOneMeetingModel?> postMeetingLeave({
    bool isLoading = false,
    required String meetingid,
  }) async {
    try {
      var response = await _dataRepository.postMeetingLeave(
        meetingid: meetingid,
        isLoading: isLoading,
      );
      var hostMeetingListModel = getOneMeetingModelFromJson(response.data);
      if (hostMeetingListModel.status == 200) {
        return hostMeetingListModel;
      } else {
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> postOutgoingCallAddMember({
    bool isLoading = false,
    required String userid,
    required String meetingid,
  }) async {
    try {
      var response = await _dataRepository.postOutgoingCallAddMember(
        userid: userid,
        meetingid: meetingid,
        isLoading: isLoading,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ChatListsModel?> postGroupPhoto({
    bool isLoading = false,
    required String groupid,
    required int page,
    required int limit,
  }) async {
    try {
      var response = await _dataRepository.postGroupPhoto(
        groupid: groupid,
        page: page,
        limit: limit,
        isLoading: isLoading,
      );
      var broadcastListModel = chatListsModelFromJson(response.data);
      if (broadcastListModel.status == 200) {
        return broadcastListModel;
      } else {
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ChatListsModel?> postGroupAudio({
    bool isLoading = false,
    required String groupid,
    required int page,
    required int limit,
  }) async {
    try {
      var response = await _dataRepository.postGroupAudio(
        groupid: groupid,
        page: page,
        limit: limit,
        isLoading: isLoading,
      );
      var broadcastListModel = chatListsModelFromJson(response.data);
      if (broadcastListModel.status == 200) {
        return broadcastListModel;
      } else {
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ChatListsModel?> postGroupDoc({
    bool isLoading = false,
    required String groupid,
    required int page,
    required int limit,
  }) async {
    try {
      var response = await _dataRepository.postGroupDoc(
        groupid: groupid,
        page: page,
        limit: limit,
        isLoading: isLoading,
      );
      var broadcastListModel = chatListsModelFromJson(response.data);
      if (broadcastListModel.status == 200) {
        return broadcastListModel;
      } else {
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ChatListsModel?> postGroupLink({
    bool isLoading = false,
    required String groupid,
    required int page,
    required int limit,
  }) async {
    try {
      var response = await _dataRepository.postGroupLink(
        groupid: groupid,
        page: page,
        limit: limit,
        isLoading: isLoading,
      );
      var broadcastListModel = chatListsModelFromJson(response.data);
      if (broadcastListModel.status == 200) {
        return broadcastListModel;
      } else {
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> postChatHide({
    bool isLoading = false,
    required List<String> friendrequestids,
  }) async {
    try {
      var response = await _dataRepository.postChatHide(
        friendrequestids: friendrequestids,
        isLoading: isLoading,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> postGroupChatHide({
    bool isLoading = false,
    required List<String> groupids,
  }) async {
    try {
      var response = await _dataRepository.postGroupChatHide(
        groupids: groupids,
        isLoading: isLoading,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> postChatLock({
    bool isLoading = false,
    required List<String> friendrequestids,
  }) async {
    try {
      var response = await _dataRepository.postChatLock(
        friendrequestids: friendrequestids,
        isLoading: isLoading,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> postGroupChatLock({
    bool isLoading = false,
    required List<String> groupids,
  }) async {
    try {
      var response = await _dataRepository.postGroupChatLock(
        groupids: groupids,
        isLoading: isLoading,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<CreateLockPinModel?> postCreatePinLock({
    bool isLoading = false,
    required String pin,
  }) async {
    try {
      var response = await _dataRepository.postCreatePinLock(
        pin: pin,
        isLoading: isLoading,
      );
      var broadcastListModel = createLockPinModelFromJson(response.data);
      if (broadcastListModel.status == 200) {
        saveValue(LocalKeys.authorizationlockpin,
            broadcastListModel.data?.token.toString());
        return broadcastListModel;
      } else {
        return broadcastListModel;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<VerifyChatLockModel?> postVerifyPinLock({
    bool isLoading = false,
    required String pin,
  }) async {
    try {
      var response = await _dataRepository.postVerifyPinLock(
        pin: pin,
        isLoading: isLoading,
      );
      var broadcastListModel = verifyChatLockModelFromJson(response.data);
      if (broadcastListModel.status == 200) {
        saveValue(LocalKeys.authorizationlockpin,
            broadcastListModel.data?.token.toString());
        return broadcastListModel;
      } else {
        return broadcastListModel;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> postChangePinLock({
    bool isLoading = false,
    required String oldpin,
    required String newpin,
  }) async {
    try {
      var response = await _dataRepository.postChangePinLock(
        oldpin: oldpin,
        newpin: newpin,
        isLoading: isLoading,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> postForgotPinLock({
    bool isLoading = false,
  }) async {
    try {
      var response = await _dataRepository.postForgotPinLock(
        isLoading: isLoading,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> postDisableAccount({
    bool isLoading = false,
  }) async {
    try {
      var response = await _dataRepository.postDisableAccount(
        isLoading: isLoading,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> postDeleteAccount({
    bool isLoading = false,
  }) async {
    try {
      var response = await _dataRepository.postDeleteAccount(
        isLoading: isLoading,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<SettingNotificationModel?> postNotificationStatusforChat({
    bool isLoading = false,
  }) async {
    try {
      var response = await _dataRepository.postNotificationStatusforChat(
        isLoading: isLoading,
      );
      var broadcastListModel = settingNotificationModelFromJson(response.data);
      if (broadcastListModel.status == 200) {
        return broadcastListModel;
      } else {
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<SettingNotificationModel?> postNotificationStatusforGroup({
    bool isLoading = false,
  }) async {
    try {
      var response = await _dataRepository.postNotificationStatusforGroup(
        isLoading: isLoading,
      );
      var broadcastListModel = settingNotificationModelFromJson(response.data);
      if (broadcastListModel.status == 200) {
        return broadcastListModel;
      } else {
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> postRecoveryEmail({
    bool isLoading = false,
    required String email,
  }) async {
    try {
      var response = await _dataRepository.postRecoveryEmail(
        isLoading: isLoading,
        email: email,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<StorageModel?> postStorageInfo({
    bool isLoading = false,
  }) async {
    try {
      var response = await _dataRepository.postStorageInfo(
        isLoading: isLoading,
      );
      var broadcastListModel = storageModelFromJson(response.data);
      if (broadcastListModel.status == 200) {
        return broadcastListModel;
      } else {
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<FriendsListModel?> postChatLockFriends({
    bool isLoading = false,
    required int page,
    required int limit,
    required String search,
    required bool unreadMessages,
    required bool contactFriend,
    required bool fefieldFriend,
    required bool receiverFriend,
    required bool senderFriend,
  }) async {
    try {
      var response = await _dataRepository.postChatLockFriends(
        page: page,
        limit: limit,
        search: search,
        unreadMessages: unreadMessages,
        contactFriend: contactFriend,
        fefieldFriend: fefieldFriend,
        receiverFriend: receiverFriend,
        senderFriend: senderFriend,
        isLoading: isLoading,
      );
      var myFriendsModel = friendsListModelFromJson(response.data);
      if (myFriendsModel.status == 200) {
        return myFriendsModel;
      } else {
        Utility.showMessage(myFriendsModel.message.toString(),
            MessageType.error, () => null, '');
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<GroupFriendListModel?> postGroupChatLockList({
    bool isLoading = false,
    required int page,
    required int limit,
    required String search,
    required bool isunreadmessagefilteronoff,
  }) async {
    try {
      var response = await _dataRepository.postGroupChatLockList(
        page: page,
        limit: limit,
        search: search,
        isunreadmessagefilteronoff: isunreadmessagefilteronoff,
        isLoading: isLoading,
      );
      var groupUserListModel = groupFriendListModelFromJson(response.data);
      if (groupUserListModel.status == 200) {
        return groupUserListModel;
      } else {
        Utility.showMessage(groupUserListModel.message.toString(),
            MessageType.error, () => null, '');
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> postUnLockChat({
    bool isLoading = false,
    required List<String> friendrequestids,
  }) async {
    try {
      var response = await _dataRepository.postUnLockChat(
        friendrequestids: friendrequestids,
        isLoading: isLoading,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> postUnLockGroup({
    bool isLoading = false,
    required List<String> groupids,
  }) async {
    try {
      var response = await _dataRepository.postUnLockGroup(
        groupids: groupids,
        isLoading: isLoading,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<CreateLockPinModel?> postCreatePinHide({
    bool isLoading = false,
    required String pin,
  }) async {
    try {
      var response = await _dataRepository.postCreatePinHide(
        pin: pin,
        isLoading: isLoading,
      );
      var broadcastListModel = createLockPinModelFromJson(response.data);
      if (broadcastListModel.status == 200) {
        saveValue(LocalKeys.authorizationhidepin,
            broadcastListModel.data?.token.toString());
        return broadcastListModel;
      } else {
        return broadcastListModel;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<VerifyChatLockModel?> postVerifyPinHide({
    bool isLoading = false,
    required String pin,
  }) async {
    try {
      var response = await _dataRepository.postVerifyPinHide(
        pin: pin,
        isLoading: isLoading,
      );
      var broadcastListModel = verifyChatLockModelFromJson(response.data);
      if (broadcastListModel.status == 200) {
        saveValue(LocalKeys.authorizationhidepin,
            broadcastListModel.data?.token.toString());
        return broadcastListModel;
      } else {
        return broadcastListModel;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> postChangePinHide({
    bool isLoading = false,
    required String oldpin,
    required String newpin,
  }) async {
    try {
      var response = await _dataRepository.postChangePinHide(
        oldpin: oldpin,
        newpin: newpin,
        isLoading: isLoading,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> postForgotPinHide({
    bool isLoading = false,
  }) async {
    try {
      var response = await _dataRepository.postForgotPinHide(
        isLoading: isLoading,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<FriendsListModel?> postChatHideFriends({
    bool isLoading = false,
    required int page,
    required int limit,
    required String search,
    required bool unreadMessages,
    required bool contactFriend,
    required bool fefieldFriend,
    required bool receiverFriend,
    required bool senderFriend,
  }) async {
    try {
      var response = await _dataRepository.postChatHideFriends(
        page: page,
        limit: limit,
        search: search,
        unreadMessages: unreadMessages,
        contactFriend: contactFriend,
        fefieldFriend: fefieldFriend,
        receiverFriend: receiverFriend,
        senderFriend: senderFriend,
        isLoading: isLoading,
      );
      var myFriendsModel = friendsListModelFromJson(response.data);
      if (myFriendsModel.status == 200) {
        return myFriendsModel;
      } else {
        Utility.showMessage(myFriendsModel.message.toString(),
            MessageType.error, () => null, '');
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<GroupFriendListModel?> postGroupChatHideList({
    bool isLoading = false,
    required int page,
    required int limit,
    required String search,
    required bool isunreadmessagefilteronoff,
  }) async {
    try {
      var response = await _dataRepository.postGroupChatHideList(
        page: page,
        limit: limit,
        search: search,
        isunreadmessagefilteronoff: isunreadmessagefilteronoff,
        isLoading: isLoading,
      );
      var groupUserListModel = groupFriendListModelFromJson(response.data);
      if (groupUserListModel.status == 200) {
        return groupUserListModel;
      } else {
        Utility.showMessage(groupUserListModel.message.toString(),
            MessageType.error, () => null, '');
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> postSaveSubUser({
    bool isLoading = false,
    required String subuserid,
    required String fullname,
    required String username,
    required String email,
    required String mobile,
    required String country_code,
    // required String country_wise_contact,
    required String password,
    required List<String?> chats,
    required List<String?> groups,
  }) async {
    try {
      var response = await _dataRepository.postSaveSubUser(
        subuserid: subuserid,
        fullname: fullname,
        username: username,
        email: email,
        mobile: mobile,
        country_code: country_code,
        // country_wise_contact: country_wise_contact,
        password: password,
        chats: chats,
        groups: groups,
        isLoading: isLoading,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<MultiUserAccountModel?> postSubUserList({
    bool isLoading = false,
    required int page,
    required int limit,
    required String search,
  }) async {
    try {
      var response = await _dataRepository.postSubUserList(
        page: page,
        limit: limit,
        search: search,
        isLoading: isLoading,
      );
      var groupUserListModel = multiUserAccountModelFromJson(response.data);
      if (groupUserListModel.status == 200) {
        return groupUserListModel;
      } else {
        Utility.showMessage(groupUserListModel.message.toString(),
            MessageType.error, () => null, '');
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> postChangePassword({
    bool isLoading = false,
    required String subuserid,
    required String password,
  }) async {
    try {
      var response = await _dataRepository.postChangePassword(
        subuserid: subuserid,
        password: password,
        isLoading: isLoading,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<MultiUserAccountUpdateModel?> postUpdateSubUser({
    bool isLoading = false,
    required String subuserid,
  }) async {
    try {
      var response = await _dataRepository.postUpdateSubUser(
        subuserid: subuserid,
        isLoading: isLoading,
      );
      var groupUserListModel =
          multiUserAccountUpdateModelFromJson(response.data);
      if (groupUserListModel.status == 200) {
        return groupUserListModel;
      } else {
        Utility.showMessage(groupUserListModel.message.toString(),
            MessageType.error, () => null, '');
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> postClearChats({
    bool isLoading = false,
  }) async {
    try {
      var response = await _dataRepository.postClearChats(
        isLoading: isLoading,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<SettingNotificationModel?> postReadReceiptsstatus({
    bool isLoading = false,
  }) async {
    try {
      var response = await _dataRepository.postReadReceiptsstatus(
        isLoading: isLoading,
      );
      var broadcastListModel = settingNotificationModelFromJson(response.data);
      if (broadcastListModel.status == 200) {
        return broadcastListModel;
      } else {
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<SettingNotificationModel?> postLastSeenOnlineOfflineStatus({
    bool isLoading = false,
  }) async {
    try {
      var response = await _dataRepository.postLastSeenOnlineOfflineStatus(
        isLoading: isLoading,
      );
      var broadcastListModel = settingNotificationModelFromJson(response.data);
      if (broadcastListModel.status == 200) {
        return broadcastListModel;
      } else {
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> postChatLockVerifyOtp({
    bool isLoading = false,
    required int otp,
    required int pin,
  }) async {
    try {
      var response = await _dataRepository.postChatLockVerifyOtp(
        otp: otp,
        pin: pin,
        isLoading: isLoading,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> postChatHideVerifyOtp({
    bool isLoading = false,
    required int otp,
    required int pin,
  }) async {
    try {
      var response = await _dataRepository.postChatHideVerifyOtp(
        otp: otp,
        pin: pin,
        isLoading: isLoading,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<SendOtpModel?> postChangeNumber({
    bool isLoading = false,
    required String oldmobile,
    required String oldcountry_code,
    required String newmobile,
    required String newcountry_code,
  }) async {
    try {
      var response = await _dataRepository.postChangeNumber(
        oldmobile: oldmobile,
        oldcountry_code: oldcountry_code,
        newmobile: newmobile,
        newcountry_code: newcountry_code,
        isLoading: isLoading,
      );
      var loginResponse = sendOtpModelFromJson(response.data);
      if (loginResponse.status == 200) {
        return loginResponse;
      } else {
        return loginResponse;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<VerifyOtpModel?> postChangeNumberVerify({
    bool isLoading = false,
    required String key,
    required String otp,
    required String mobile,
  }) async {
    try {
      var response = await _dataRepository.postChangeNumberVerify(
        key: key,
        otp: otp,
        mobile: mobile,
        isLoading: isLoading,
      );
      var verifyOtpModel = verifyOtpModelFromJson(response.data);
      if (verifyOtpModel.status == 200) {
        saveValue(LocalKeys.authToken, verifyOtpModel.data.token.toString());

        saveValue(LocalKeys.locale, 'en');
        return verifyOtpModel;
      } else {
        Utility.showMessage(verifyOtpModel.message.toString(),
            MessageType.error, () => null, '');
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> postClearIndividualChats({
    bool isLoading = false,
    required String userid,
  }) async {
    try {
      var response = await _dataRepository.postClearIndividualChats(
        userid: userid,
        isLoading: isLoading,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> postClearGroupChats({
    bool isLoading = false,
    required String groupid,
  }) async {
    try {
      var response = await _dataRepository.postClearGroupChats(
        groupid: groupid,
        isLoading: isLoading,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> postArchiveChat({
    bool isLoading = false,
    required List<String> friendrequestids,
  }) async {
    try {
      var response = await _dataRepository.postArchiveChat(
        friendrequestids: friendrequestids,
        isLoading: isLoading,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> postArchiveGroupChat({
    bool isLoading = false,
    required List<String> groupids,
  }) async {
    try {
      var response = await _dataRepository.postArchiveGroupChat(
        groupids: groupids,
        isLoading: isLoading,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ArchiveChatListModel?> postArchiveChatList({
    bool isLoading = false,
    required String search,
    required bool unreadMessages,
    required bool contactFriend,
    required bool fefieldFriend,
    required bool receiverFriend,
    required bool senderFriend,
  }) async {
    try {
      var response = await _dataRepository.postArchiveChatList(
        search: search,
        unreadMessages: unreadMessages,
        contactFriend: contactFriend,
        fefieldFriend: fefieldFriend,
        receiverFriend: receiverFriend,
        senderFriend: senderFriend,
        isLoading: isLoading,
      );
      var myFriendsModel = archiveChatListModelFromJson(response.data);
      if (myFriendsModel.status == 200) {
        return myFriendsModel;
      } else {
        Utility.showMessage(myFriendsModel.message.toString(),
            MessageType.error, () => null, '');
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ArchiveGroupListModel?> postArchiveGroupChatList({
    bool isLoading = false,
    required String search,
    required bool isunreadmessagefilteronoff,
  }) async {
    try {
      var response = await _dataRepository.postArchiveGroupChatList(
        search: search,
        isunreadmessagefilteronoff: isunreadmessagefilteronoff,
        isLoading: isLoading,
      );
      var GroupUserListModel = archiveGroupListModelFromJson(response.data);
      if (GroupUserListModel.status == 200) {
        return GroupUserListModel;
      } else {
        Utility.showMessage(GroupUserListModel.message.toString(),
            MessageType.error, () => null, '');
        return null;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> postArchiveChatRemove({
    bool isLoading = false,
    required List<String> friendrequestids,
  }) async {
    try {
      var response = await _dataRepository.postArchiveChatRemove(
        friendrequestids: friendrequestids,
        isLoading: isLoading,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> postArchiveGroupChatRemove({
    bool isLoading = false,
    required List<String> groupids,
  }) async {
    try {
      var response = await _dataRepository.postArchiveGroupChatRemove(
        groupids: groupids,
        isLoading: isLoading,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> postReadChat({
    bool isLoading = false,
    required List<String> friendrequestids,
  }) async {
    try {
      var response = await _dataRepository.postReadChat(
        friendrequestids: friendrequestids,
        isLoading: isLoading,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> postUnReadChat({
    bool isLoading = false,
    required List<String> friendrequestids,
  }) async {
    try {
      var response = await _dataRepository.postUnReadChat(
        friendrequestids: friendrequestids,
        isLoading: isLoading,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> postReadGroupChat({
    bool isLoading = false,
    required List<String> groupids,
  }) async {
    try {
      var response = await _dataRepository.postReadGroupChat(
        groupids: groupids,
        isLoading: isLoading,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> postUnReadGroupChat({
    bool isLoading = false,
    required List<String> groupids,
  }) async {
    try {
      var response = await _dataRepository.postUnReadGroupChat(
        groupids: groupids,
        isLoading: isLoading,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<SubUserLoginModel?> postSubUserLogin({
    bool isLoading = false,
    required String username,
    required String password,
    required String fcmToken,
  }) async {
    try {
      var response = await _dataRepository.postSubUserLogin(
        username: username,
        password: password,
        fcmToken: fcmToken,
        isLoading: isLoading,
      );
      var groupUserListModel = subUserLoginModelFromJson(response.data);
      if (groupUserListModel.status == 200) {
        saveValue(LocalKeys.isSubUser, true);
        saveValue(
            LocalKeys.authToken, groupUserListModel.data?.token.toString());
        saveValue(
            LocalKeys.fullName, groupUserListModel.data?.profile?.fullname);
        return groupUserListModel;
      } else {
        return groupUserListModel;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<NotificationModel?> postNotificationList({
    bool isLoading = false,
    required int page,
    required int limit,
  }) async {
    try {
      var response = await _dataRepository.postNotificationList(
        page: page,
        limit: limit,
        isLoading: isLoading,
      );
      var groupUserListModel = notificationModelFromJson(response.data);
      if (groupUserListModel.status == 200) {
        return groupUserListModel;
      } else {
        Utility.showMessage(groupUserListModel.message.toString(),
            MessageType.error, () => null, '');
        return groupUserListModel;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<GetOneFriendProductModel?> postFriendProductGetOne({
    bool isLoading = false,
    required String productid,
  }) async {
    try {
      var response = await _dataRepository.postFriendProductGetOne(
        productid: productid,
        isLoading: isLoading,
      );
      var groupUserListModel = getOneFriendProductModelFromJson(response.data);
      if (groupUserListModel.status == 200) {
        return groupUserListModel;
      } else {
        Utility.showMessage(groupUserListModel.message.toString(),
            MessageType.error, () => null, '');
        return groupUserListModel;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> postDeleteNotification({
    bool isLoading = false,
    String? notificationId,
  }) async {
    try {
      var response = await _dataRepository.postDeleteNotification(
        notificationId: notificationId,
        isLoading: isLoading,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> postUnFriend({
    bool isLoading = false,
    required String friendrequestid,
  }) async {
    try {
      var response = await _dataRepository.postUnFriend(
        friendrequestid: friendrequestid,
        isLoading: isLoading,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<UserBookmarkModel?> postIndiviualBookmark({
    bool isLoading = false,
    required String userid,
    required int page,
    required int limit,
  }) async {
    try {
      var response = await _dataRepository.postIndiviualBookmark(
        userid: userid,
        page: page,
        limit: limit,
        isLoading: isLoading,
      );
      var groupUserListModel = userBookmarkModelFromJson(response.data);
      if (groupUserListModel.status == 200) {
        return groupUserListModel;
      } else {
        Utility.showMessage(groupUserListModel.message.toString(),
            MessageType.error, () => null, '');
        return groupUserListModel;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> postMoveHideToLock({
    bool isLoading = false,
    required List<String> friendrequestids,
  }) async {
    try {
      var response = await _dataRepository.postMoveHideToLock(
        friendrequestids: friendrequestids,
        isLoading: isLoading,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> postMoveHideToLockGroup({
    bool isLoading = false,
    required List<String> groupids,
  }) async {
    try {
      var response = await _dataRepository.postMoveHideToLockGroup(
        groupids: groupids,
        isLoading: isLoading,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> postChatReport({
    bool isLoading = false,
    required String reportid,
    required String userid,
    required String reason,
  }) async {
    try {
      var response = await _dataRepository.postChatReport(
        reportid: reportid,
        userid: userid,
        reason: reason,
        isLoading: isLoading,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ReportListModel?> postChatReportList({
    bool isLoading = false,
    required int page,
    required int limit,
  }) async {
    try {
      var response = await _dataRepository.postChatReportList(
        page: page,
        limit: limit,
        isLoading: isLoading,
      );
      var groupUserListModel = reportListModelFromJson(response.data);
      if (groupUserListModel.status == 200) {
        return groupUserListModel;
      } else {
        Utility.showMessage(groupUserListModel.message.toString(),
            MessageType.error, () => null, '');
        return groupUserListModel;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<GetOneReportModel?> postChatReportGetOne({
    bool isLoading = false,
    required String reportid,
  }) async {
    try {
      var response = await _dataRepository.postChatReportGetOne(
        reportid: reportid,
        isLoading: isLoading,
      );
      var groupUserListModel = getOneReportModelFromJson(response.data);
      if (groupUserListModel.status == 200) {
        return groupUserListModel;
      } else {
        Utility.showMessage(groupUserListModel.message.toString(),
            MessageType.error, () => null, '');
        return groupUserListModel;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> postGroupChatReport({
    bool isLoading = false,
    required String reportid,
    required String groupid,
    required String reason,
  }) async {
    try {
      var response = await _dataRepository.postGroupChatReport(
        reportid: reportid,
        groupid: groupid,
        reason: reason,
        isLoading: isLoading,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<GroupReportModel?> postGroupChatReportList({
    bool isLoading = false,
    required int page,
    required int limit,
  }) async {
    try {
      var response = await _dataRepository.postGroupChatReportList(
        page: page,
        limit: limit,
        isLoading: isLoading,
      );
      var groupUserListModel = groupReportModelFromJson(response.data);
      if (groupUserListModel.status == 200) {
        return groupUserListModel;
      } else {
        Utility.showMessage(groupUserListModel.message.toString(),
            MessageType.error, () => null, '');
        return groupUserListModel;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<GetOneGroupReportModel?> postGroupChatReportGetOne({
    bool isLoading = false,
    required String reportid,
  }) async {
    try {
      var response = await _dataRepository.postGroupChatReportGetOne(
        reportid: reportid,
        isLoading: isLoading,
      );
      var groupUserListModel = getOneGroupReportModelFromJson(response.data);
      if (groupUserListModel.status == 200) {
        return groupUserListModel;
      } else {
        Utility.showMessage(groupUserListModel.message.toString(),
            MessageType.error, () => null, '');
        return groupUserListModel;
      }
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> postMeetingCancle({
    bool isLoading = false,
    required String meetingid,
  }) async {
    try {
      var response = await _dataRepository.postMeetingCancle(
        meetingid: meetingid,
        isLoading: isLoading,
      );
      return response;
    } catch (_) {
      Utility.closeDialog();
      UnimplementedError();
      return null;
    }
  }

  Future<ResponseModel?> updateFcmToken({
    bool isLoading = false,
    required String fcmToken,
  }) async {
    try {
      var response = await _dataRepository.updateFcmToken(
        fcmToken: fcmToken,
        isLoading: isLoading,
      );
      return response;
    } catch (_) {
      return null;
    }
  }
}
