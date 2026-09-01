// coverage:ignore-file
import 'dart:io';
import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:chatnest/data/helpers/helpers.dart';
import 'package:flutter/foundation.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:get/get.dart';
import 'package:http_parser/src/media_type.dart' as mediaType;
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:mime/mime.dart';

import '../../app/utils/utility.dart';

/// The helper class which will connect to the world to get the data.
class ConnectHelper {
  ConnectHelper() {
    _init();
  }

  late Dio dio;

  /// Api wrapper initialization
  final apiWrapper = ApiWrapper();

  /// Device info plugin initialization
  final deviceinfo = DeviceInfoPlugin();

  /// To get android device info
  AndroidDeviceInfo? androidDeviceInfo;

  /// To get iOS device info
  IosDeviceInfo? iosDeviceInfo;

  // IosDeviceInfo? iosDeviceInfo;

  // coverage:ignore-start
  /// initialize the andorid device information
  void _init() async {
    if (GetPlatform.isAndroid) {
      androidDeviceInfo = await deviceinfo.androidInfo;
    } else {
      iosDeviceInfo = await deviceinfo.iosInfo;
    }
    dio = Dio();
  }

  // coverage:ignore-end

  /// Device id
  String? get deviceId => GetPlatform.isAndroid
      ? androidDeviceInfo?.id
      : iosDeviceInfo?.identifierForVendor;

  /// Device make brand
  String? get deviceMake =>
      GetPlatform.isAndroid ? androidDeviceInfo?.brand : 'Apple';

  /// Device Model
  String? get deviceModel =>
      GetPlatform.isAndroid ? androidDeviceInfo?.model : iosDeviceInfo?.model;

  /// Device is a type of 1 for Android and 2 for iOS
  String get deviceTypeCode => GetPlatform.isAndroid ? '1' : '2';

  /// Device OS
  String get deviceOs => GetPlatform.isAndroid ? 'ANDROID' : 'IOS';

  /// API to get the IP of the user
  Future<String> getIp() async {
    var ip = '';
    if (await Utility.isNetworkAvailable()) {
      for (var interface in await NetworkInterface.list()) {
        for (var addr in interface.addresses) {
          ip = addr.address;
        }
      }
      return ip.isNotEmpty ? ip : '0.0.0.0';
    }
    return '0.0.0.0';
  }

  /// Login API call
  Future<ResponseModel> sendOtpApi({
    required String mobile,
    required String countryCode,
    required String fcmToken,
    bool isLoading = false,
  }) async {
    var data = {
      'mobile': mobile,
      'country_code': countryCode,
      'fcm_token': fcmToken,
      'country_wise_contact': {
        "number": mobile.isEmpty ? "" : "0${mobile}",
        "internationalNumber": "${countryCode} ${mobile}",
        "nationalNumber": "0${mobile}",
        "e164Number": countryCode + mobile,
        "countryCode": PhoneNumber.getISO2CodeByPrefix(countryCode),
        "dialCode": countryCode
      },
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.sendOtpApi,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(isDefaultAuthorizationKeyAdd: false),
    );
    return response;
  }

  /// verifyOtpApi API call
  Future<ResponseModel> verifyOtpApi({
    required String key,
    required String otp,
    required String mobile,
    bool isLoading = false,
  }) async {
    var data = {
      'key': key,
      'otp': otp,
      'mobile': mobile,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.verifyOtpApi,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(isDefaultAuthorizationKeyAdd: false),
    );
    return response;
  }

  /// uploadBrochure API call
  Future<ResponseModel> uploadBrochure({
    bool isLoading = false,
    required String filePath,
  }) async {
    var type = (lookupMimeType(filePath) ?? 'application/octet-stream').split('/');
    var response = await apiWrapper.makeRequest(
      EndPoints.uploadBrochure,
      Request.awsUpload,
      filePath,
      isLoading,
      Utility.commonHeader(),
      mediaType: mediaType.MediaType(type[0], type[1]),
    );
    return response;
  }

  /// Set Profile API call
  Future<ResponseModel> setProfile({
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
    var data = {
      'profileimage': profileimage,
      'fullname': fullname,
      'nickname': nickname,
      'email': email,
      'dob': dob,
      // 'hashtag': hashtag,
      'gender': gender,
      'aboutme': aboutme,
      'hobbies': hobbies,
      'latitude': latitude,
      'longitude': longitude,
      'interestedin': interestedin,
      'interestedagerangemin': interestedagerangemin,
      'interestedagerangemax': interestedagerangemax,
      'socialmedialinks': socialmedialinks,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.setProfile,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  /// Set Profile Pic API call
  Future<ResponseModel> setProfilePic({
    bool isLoading = false,
    required String filePath,
  }) async {
    var response = await apiWrapper.makeRequest(
      EndPoints.setProfilePic,
      Request.awsUpload,
      filePath,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  /// Get Profile API call
  Future<ResponseModel> getProfile({
    bool isLoading = false,
  }) async {
    var response = await apiWrapper.makeRequest(
      EndPoints.getProfile,
      Request.get,
      null,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  /// Get Business Categories API call
  Future<ResponseModel> getBusinessCategories({
    bool isLoading = false,
  }) async {
    var response = await apiWrapper.makeRequest(
      EndPoints.getBusinessCategories,
      Request.get,
      null,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> getProductCategory({
    bool isLoading = false,
    required int page,
    required int limit,
    required String search,
  }) async {
    var data = {
      "page": page,
      "limit": limit,
      "search": search,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.getProductCategory,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  /// Set Profile API call
  Future<ResponseModel> setBusinessProfile({
    bool isLoading = false,
    required String businessid,
    required String profileimage,
    required String name,
    required List<AddBusinessCategory> categories,
    required String about,
    required String mobile,
    required String mobileCountryCode,
    // required AddBusinessMobileCountryWiseContact mobileCountryWiseContact,
    required String wamobile,
    required String wamobileCountryCode,
    // required AddBusinessMobileCountryWiseContact wamobileCountryWiseContact,
    required String email,
    required String website,
    required List<AddBusinessCategory> interestedCategories,
    required List<String> brochures,
    required List<String> photos,
    required List<String> videos,
    required AddBusinessAddress address,
    required double latitude,
    required double longitude,
    required List<AddBusinessBusinesshour> businesshours,
    required List<Socialmedialink> socialmedialinks,
    required bool isBusinessCategories,
  }) async {
    var data = {
      'businessid': businessid,
      'profileimage': profileimage,
      'name': name,
      'categories': categories,
      'about': about,
      'mobile': mobile,
      'mobile_country_code': mobileCountryCode,
      'mobile_country_wise_contact': {
        "number": mobile.isEmpty ? "" : "0${mobile}",
        "internationalNumber": "${mobileCountryCode} ${mobile}",
        "nationalNumber": "0${mobile}",
        "e164Number": mobileCountryCode + mobile,
        "countryCode": PhoneNumber.getISO2CodeByPrefix(mobileCountryCode),
        "dialCode": mobileCountryCode
      },
      'wamobile': wamobile,
      'wamobile_country_code': wamobileCountryCode,
      'wamobile_country_wise_contact': {
        "number": wamobile.isEmpty ? "" : "0${wamobile}",
        "internationalNumber": "${wamobileCountryCode} ${wamobile}",
        "nationalNumber": "0${wamobile}",
        "e164Number": wamobileCountryCode + wamobile,
        "countryCode": PhoneNumber.getISO2CodeByPrefix(wamobileCountryCode),
        "dialCode": wamobileCountryCode
      },
      'email': email,
      'website': website,
      'interested_categories': interestedCategories,
      'brochures': brochures,
      'photos': photos,
      'videos': videos,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'businesshours': businesshours,
      'socialmedialinks': socialmedialinks,
      'is_interested_in_business_categories': isBusinessCategories
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.setBusinessProfile,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> addProduct({
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
    var data = {
      "categories": categories,
      "images": images,
      "videos": videos,
      "businessid": businessid,
      "productid": productid,
      "name": name,
      "image": image,
      "description": description,
      "price": price,
      "offer": offer,
      "offer_type": offerType,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.productSave,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> setProductPhoto({
    bool isLoading = false,
    required String filePath,
  }) async {
    var response = await apiWrapper.makeRequest(
      EndPoints.productPhotos,
      Request.awsUpload,
      filePath,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> uploadProductVideo({
    bool isLoading = false,
    required String filePath,
  }) async {
    var type = (lookupMimeType(filePath) ?? 'video/mp4').split('/');
    var response = await apiWrapper.makeRequest(
      EndPoints.productVideos,
      Request.awsUpload,
      filePath,
      isLoading,
      Utility.commonHeader(),
      mediaType: mediaType.MediaType(type[0], type[1]),
    );
    return response;
  }

  Future<ResponseModel> productList({
    bool isLoading = false,
    required String filePath,
  }) async {
    var type = (lookupMimeType(filePath) ?? 'video/mp4').split('/');
    var response = await apiWrapper.makeRequest(
      EndPoints.productVideos,
      Request.awsUpload,
      filePath,
      isLoading,
      Utility.commonHeader(),
      mediaType: mediaType.MediaType(type[0], type[1]),
    );
    return response;
  }

  Future<ResponseModel> getproductList({
    bool isLoading = false,
    required int page,
    required int limit,
    required String search,
    required String business,
    required List<String> parentcategory,
    required List<String> childcategory,
  }) async {
    var data = {
      "page": page,
      "limit": limit,
      "search": search,
      "business": business,
      "parentcategory": parentcategory,
      "childcategory": childcategory,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.productList,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> getOneProduct({
    bool isLoading = false,
    required String productid,
  }) async {
    var data = {
      "productid": productid,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.getOneProduct,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> removeProduct({
    bool isLoading = false,
    required String productid,
  }) async {
    var data = {
      "productid": productid,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.removeProduct,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> removeProductPhoto({
    bool isLoading = false,
    required String filekey,
  }) async {
    var data = {
      "filekey": filekey,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.removeProductPhoto,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> removeProductVideo({
    bool isLoading = false,
    required String filekey,
  }) async {
    var data = {
      "filekey": filekey,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.removeBusinessVideo,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  /// Get Profile Buisness API call
  Future<ResponseModel> setBusinessProfilePic({
    bool isLoading = false,
    required String filePath,
  }) async {
    var response = await apiWrapper.makeRequest(
      EndPoints.setBusinessProfilePic,
      Request.awsUpload,
      filePath,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  /// upload image API call
  Future<ResponseModel> uploadBusinessPhoto({
    bool isLoading = false,
    required String filePath,
  }) async {
    var response = await apiWrapper.makeRequest(
      EndPoints.uploadBusinessPhoto,
      Request.awsUpload,
      filePath,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  /// upload video API call
  Future<ResponseModel> uploadBusinessVideo({
    bool isLoading = false,
    required String filePath,
  }) async {
    var type = (lookupMimeType(filePath) ?? 'video/mp4').split('/');
    var response = await apiWrapper.makeRequest(
      EndPoints.uploadBusinessVideo,
      Request.awsUpload,
      filePath,
      isLoading,
      Utility.commonHeader(),
      mediaType: mediaType.MediaType(type[0], type[1]),
    );
    return response;
  }

  /// remove Business Brochure API call
  Future<ResponseModel> removeBrochure({
    bool isLoading = false,
    required String filekey,
  }) async {
    var data = {
      "filekey": filekey,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.removeBrochure,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  /// remove Business Photo API call
  Future<ResponseModel> removeBusinessPhoto({
    bool isLoading = false,
    required String filekey,
  }) async {
    var data = {
      "filekey": filekey,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.removeBusinessPhoto,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  /// remove Business Video API call
  Future<ResponseModel> removeBusinessVideo({
    bool isLoading = false,
    required String filekey,
  }) async {
    var data = {
      "filekey": filekey,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.removeBusinessVideo,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  /// Find Friends Location API call
  Future<ResponseModel> postFindFriendsLocation({
    bool isLoading = false,
    required double latitude,
    required double longitude,
  }) async {
    var data = {
      "latitude": latitude,
      "longitude": longitude,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postFindFriendsLocation,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  /// Find Friends List API call
  Future<ResponseModel> postFindFriendsList({
    bool isLoading = false,
    required int page,
    required int limit,
    required String search,
  }) async {
    var data = {
      "page": page,
      "limit": limit,
      "search": search,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postFindFriendsList,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  /// send NewF riend Request API call
  Future<ResponseModel> sendNewFriendRequest({
    bool isLoading = false,
    required String receiverid,
    required String message,
    required String product,
    required AuthorizedPermissions authorizedPermissions,
  }) async {
    var data = {
      "receiverid": receiverid,
      "message": message,
      "product": product,
      "authorized_permissions": authorizedPermissions.toJson()
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.sendNewFriendRequest,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  /// send NewF riend Request API call
  Future<ResponseModel> cancelSentRequest({
    bool isLoading = false,
    required String friendrequestid,
  }) async {
    var data = {
      "friendrequestid": friendrequestid,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.cancelSentRequest,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  /// sent Request List API call
  Future<ResponseModel> sentRequestList({
    bool isLoading = false,
    required int page,
    required int limit,
  }) async {
    var data = {
      "page": page,
      "limit": limit,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.sentRequestList,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  /// blocked User List API call
  Future<ResponseModel> blockedUserList({
    bool isLoading = false,
    required int page,
    required int limit,
  }) async {
    var data = {
      "page": page,
      "limit": limit,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.blockedUserList,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  /// received Rquest List API call
  Future<ResponseModel> receivedrRequestList({
    bool isLoading = false,
    required int page,
    required int limit,
  }) async {
    var data = {
      "page": page,
      "limit": limit,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.receivedrRequestList,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  /// respond Friends Request API call
  Future<ResponseModel> respondFriendsRequest({
    bool isLoading = false,
    required String friendrequestid,
    required String status,
    required AuthorizedPermissions authorizedPermissions,
  }) async {
    var data = {
      "friendrequestid": friendrequestid,
      "status": status,
      "authorized_permissions": authorizedPermissions.toJson()
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.respondFriendsRequest,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  /// update Friends Request API call
  Future<ResponseModel> updateFriendsRequest({
    bool isLoading = false,
    required String friendrequestid,
    required String status,
    required AuthorizedPermissions authorizedPermissions,
  }) async {
    var data = {
      "friendrequestid": friendrequestid,
      "status": status,
      "authorized_permissions": authorizedPermissions.toJson(),
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.updateFriendsRequest,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  /// Unblock a user — calls /friends/unblock which removes from userblocks collection
  Future<ResponseModel> unblockUser({
    bool isLoading = false,
    required String blockeduserid,
  }) async {
    var data = {
      "blockeduserid": blockeduserid,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.unblockUser,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  /// Get Business List API call
  Future<ResponseModel> getBusinessList({
    bool isLoading = false,
  }) async {
    var response = await apiWrapper.makeRequest(
      EndPoints.getBusinessList,
      Request.get,
      null,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  /// Get One Business API call
  Future<ResponseModel> getOneBusiness({
    bool isLoading = false,
    required String businessid,
  }) async {
    var data = {
      "businessid": businessid,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.getOneBusiness,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  /// remove Business API call
  Future<ResponseModel> removeBusiness({
    bool isLoading = false,
    required String businessid,
  }) async {
    var data = {
      "businessid": businessid,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.removeBusiness,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> myFriendsList({
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
    var data = {
      "page": page,
      "limit": limit,
      "search": search,
      "unread_messages": unreadMessages,
      "contact_friend": contactFriend,
      "fefield_friend": fefieldFriend,
      "receiver_friend": receiverFriend,
      "sender_friend": senderFriend,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.myFriendsList,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> createGroupApi({
    bool isLoading = false,
    required String groupid,
    required String profileimage,
    required String name,
    required String description,
    required List<String> members,
    required AuthorizedPermissions authorizedPermissions,
  }) async {
    var data = {
      "groupid": groupid,
      "profileimage": profileimage,
      "name": name,
      "description": description,
      "members": members,
      "authorized_permissions": authorizedPermissions.toJson(),
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.createGroupApi,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  /// Set Profile Pic API call
  Future<ResponseModel> uploadGroupProfile({
    bool isLoading = false,
    required String filePath,
  }) async {
    var response = await apiWrapper.makeRequest(
      EndPoints.uploadGroupProfile,
      Request.awsUpload,
      filePath,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> groupsChatList({
    bool isLoading = false,
    required int page,
    required int limit,
    required String search,
    required bool isunreadmessagefilteronoff,
  }) async {
    var data = {
      "page": page,
      "limit": limit,
      "search": search,
      "isunreadmessagefilteronoff": isunreadmessagefilteronoff
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.groupsChatList,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );

    print('Group Chat List Response Data: ${response.data}');
    return response;
  }

  Future<ResponseModel> postGroupListWithoutPaging({
    bool isLoading = false,
    required String search,
    required bool isunreadmessagefilteronoff,
  }) async {
    var data = {
      "search": search,
      "isunreadmessagefilteronoff": isunreadmessagefilteronoff
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postGroupListWithoutPaging,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  /// Get One Group API call
  Future<ResponseModel> getOneGroup({
    bool isLoading = false,
    required String groupid,
  }) async {
    var data = {
      "groupid": groupid,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.getOneGroup,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  /// groupSetManager API call
  Future<ResponseModel> groupSetManager({
    bool isLoading = false,
    required String groupid,
    required String userid,
  }) async {
    var data = {
      "groupid": groupid,
      "userid": userid,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.groupSetManager,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  /// groupUnSetManager API call
  Future<ResponseModel> groupUnSetManager({
    bool isLoading = false,
    required String groupid,
    required String userid,
  }) async {
    var data = {
      "groupid": groupid,
      "userid": userid,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.groupUnSetManager,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  /// leave Group API call
  Future<ResponseModel> leaveGroup({
    bool isLoading = false,
    required String groupid,
  }) async {
    var data = {
      "groupid": groupid,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.leaveGroup,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  /// add Member Group API call
  Future<ResponseModel> addMemberGroup({
    bool isLoading = false,
    required String groupid,
    required List<String> membersList,
  }) async {
    var data = {
      "groupid": groupid,
      "members": membersList,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.addMemberGroup,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  /// remove Member Group API call
  Future<ResponseModel> removeMemberGroup({
    bool isLoading = false,
    required String groupid,
    required List<String> membersList,
  }) async {
    var data = {
      "groupid": groupid,
      "members": membersList,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.removeMemberGroup,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  /// Group Set Permission API call
  Future<ResponseModel> groupSetPermission({
    bool isLoading = false,
    required String groupid,
    required AuthorizedPermissions authorizedPermissions,
  }) async {
    var data = {
      "groupid": groupid,
      "authorized_permissions": authorizedPermissions.toJson(),
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.groupSetPermission,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  /// removeGroupProfile API call
  Future<ResponseModel> removeGroupProfile({
    bool isLoading = false,
    required String filekey,
  }) async {
    var data = {
      "filekey": filekey,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.removeGroupProfile,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  // get One Friends API call
  Future<ResponseModel> getOneFriends({
    bool isLoading = false,
    required String userid,
  }) async {
    debugPrint(
        "[ANTIGRAVITY_DEBUG] ConnectHelper.getOneFriends called for userid: $userid");
    var data = {
      "userid": userid,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.getOneFriends,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    debugPrint(
        "[ANTIGRAVITY_DEBUG] ConnectHelper.getOneFriends response received: ${response != null}");
    return response;
  }

  Future<ResponseModel> getOneUserStatus({
    required String userid,
    bool isLoading = false,
  }) async {
    var data = {
      "userid": userid,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.getUserStatus,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  // get Chat Lists API call
  Future<ResponseModel> getChatLists({
    bool isLoading = false,
    required String userid,
    required String search,
    required int page,
    required int limit,
  }) async {
    var data = {
      "userid": userid,
      "page": page,
      "limit": limit,
      "search": search,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.getChatLists,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  // create Polls API call
  Future<ResponseModel> createPolls({
    bool isLoading = false,
    required String pollid,
    required String polltitle,
    required List<String> optionsList,
    required bool allowmultipleans,
  }) async {
    var data = {
      "pollid": pollid,
      "polltitle": polltitle,
      "options": optionsList,
      "allowmultipleans": allowmultipleans,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.createPolls,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  // get one Polls API call
  Future<ResponseModel> getOnePoll({
    bool isLoading = false,
    required String pollid,
  }) async {
    var data = {
      "pollid": pollid,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.getOnePoll,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  // Send Message API call
  Future<ResponseModel> sendMessage({
    required String receiverid,
    String? message,
    String? product,
    String? latitude,
    String? longitude,
    String? pollid,
    String? context,
    List<String>? usersList,
    PhoneContact? phonecontactData,
    bool isLoading = false,
    List<ImageFormData>? mediaFileList,
  }) async {
    var data = phonecontactData != null
        ? {
            'receiverid': receiverid,
            "phonecontact": phonecontactData,
          }
        : usersList?.isNotEmpty ?? false
            ? {
                'receiverid': receiverid,
                'users': usersList ?? [],
              }
            : <String, String>{
                'receiverid': receiverid,
                if (message?.isNotEmpty ?? false) 'message': message ?? "",
                if (product?.isNotEmpty ?? false) 'product': product ?? "",
                if (latitude?.isNotEmpty ?? false) 'latitude': latitude ?? "",
                if (longitude?.isNotEmpty ?? false)
                  'longitude': longitude ?? "",
                if (pollid?.isNotEmpty ?? false) 'pollid': pollid ?? "",
                if (context?.isNotEmpty ?? false) 'context': context ?? "",
              };
    var response = await apiWrapper.makeRequest(
      EndPoints.sendMessage,
      (usersList?.isNotEmpty ?? false) || phonecontactData != null
          ? Request.post
          : Request.postWithFormData,
      data,
      isLoading,
      Utility.commonHeader(),
      mediaFileList: mediaFileList,
    );
    return response;
  }

  Future<ResponseModel> myFriendsWithoutPaginationList({
    bool isLoading = false,
    required String search,
    required bool unreadMessages,
    required bool contactFriend,
    required bool fefieldFriend,
    required bool receiverFriend,
    required bool senderFriend,
  }) async {
    var data = {
      "search": search,
      "unread_messages": unreadMessages,
      "contact_friend": contactFriend,
      "fefield_friend": fefieldFriend,
      "receiver_friend": receiverFriend,
      "sender_friend": senderFriend,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.myFriendsWithoutPaginationList,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  // post Delivered Message API call
  Future<ResponseModel> postDeliveredMessage({
    bool isLoading = false,
    required String messageid,
  }) async {
    var data = {
      "messageid": messageid,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postDeliveredMessage,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  // post Seen Message API call
  Future<ResponseModel> postSeenMessage({
    bool isLoading = false,
    required String messageid,
  }) async {
    var data = {
      "messageid": messageid,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postSeenMessage,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  // Send Group Message API call
  Future<ResponseModel> sendGroupMessage({
    required String receiverid,
    String? message,
    String? product,
    String? latitude,
    String? longitude,
    String? pollid,
    String? context,
    List<String>? usersList,
    PhoneContact? phonecontactData,
    bool isLoading = false,
    List<ImageFormData>? mediaFileList,
  }) async {
    var data = phonecontactData != null
        ? {
            'receiverid': receiverid,
            "phonecontact": phonecontactData,
          }
        : usersList?.isNotEmpty ?? false
            ? {
                'receiverid': receiverid,
                'users': usersList ?? [],
              }
            : <String, String>{
                'receiverid': receiverid,
                if (message?.isNotEmpty ?? false) 'message': message ?? "",
                if (product?.isNotEmpty ?? false) 'product': product ?? "",
                if (latitude?.isNotEmpty ?? false) 'latitude': latitude ?? "",
                if (longitude?.isNotEmpty ?? false)
                  'longitude': longitude ?? "",
                if (pollid?.isNotEmpty ?? false) 'pollid': pollid ?? "",
                if (context?.isNotEmpty ?? false) 'context': context ?? "",
              };
    var response = await apiWrapper.makeRequest(
      EndPoints.sendGroupMessage,
      (usersList?.isNotEmpty ?? false) || phonecontactData != null
          ? Request.post
          : Request.postWithFormData,
      data,
      isLoading,
      Utility.commonHeader(),
      mediaFileList: mediaFileList,
    );
    return response;
  }

  // Post Chat Send Bulk Message API call
  Future<ResponseModel> postChatSendBulkMessage({
    required String receiverid,
    String? message,
    String? context,
    List<ImageFormData>? mediaFileList,
    bool isLoading = false,
  }) async {
    var data = {
      'receiverid': receiverid,
      if (message?.isNotEmpty ?? false) 'message': message ?? "",
      if (context?.isNotEmpty ?? false) 'context': context ?? "",
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postChatSendBulkMessage,
      Request.postWithFormData,
      data,
      isLoading,
      Utility.commonHeader(),
      mediaFileList: mediaFileList,
    );
    return response;
  }

  // Post Chat Send Bulk Message API call
  Future<ResponseModel> postGroupChatSendBulkMessage({
    required String receiverid,
    String? message,
    String? context,
    List<ImageFormData>? mediaFileList,
    bool isLoading = false,
  }) async {
    var data = {
      'receiverid': receiverid,
      if (message?.isNotEmpty ?? false) 'message': message ?? "",
      if (context?.isNotEmpty ?? false) 'context': context ?? "",
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postGroupChatSendBulkMessage,
      Request.postWithFormData,
      data,
      isLoading,
      Utility.commonHeader(),
      mediaFileList: mediaFileList,
    );
    return response;
  }

  // Get Group Chat Lists API call
  Future<ResponseModel> getGroupChatLists({
    bool isLoading = false,
    required String groupid,
    required String search,
    required int page,
    required int limit,
  }) async {
    var data = {
      "groupid": groupid,
      "page": page,
      "limit": limit,
      "search": search,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.getGroupChatLists,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  // post Delivered Message API call
  Future<ResponseModel> postGroupDeliveredMessage({
    bool isLoading = false,
    required String messageid,
  }) async {
    var data = {
      "messageid": messageid,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postGroupDeliveredMessage,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  // post Seen Message API call
  Future<ResponseModel> postGroupSeenMessage({
    bool isLoading = false,
    required String messageid,
  }) async {
    var data = {
      "messageid": messageid,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postGroupSeenMessage,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  // post friends products API call
  Future<ResponseModel> postfriendsproducts({
    bool isLoading = false,
    required String search,
    required String userid,
    required String business,
    required List<String> parentcategory,
    required List<String> childcategory,
  }) async {
    var data = {
      "search": search,
      "userid": userid,
      "business": business,
      "parentcategory": parentcategory,
      "childcategory": childcategory,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postfriendsproducts,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  // post Chat Delete Message API call
  Future<ResponseModel> postChatDeleteMessage({
    bool isLoading = false,
    required String messageid,
    required String deletefor,
  }) async {
    var data = {
      "messageid": messageid,
      "deletefor": deletefor,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postChatDeleteMessage,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  // post Chat Message Edit API call
  Future<ResponseModel> postChatMessageEdit({
    bool isLoading = false,
    required String messageid,
    required String message,
  }) async {
    var data = {
      "messageid": messageid,
      "message": message,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postChatMessageEdit,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  // post Chat Bookmark Remove API call
  Future<ResponseModel> postChatBookmarkAndRemove({
    bool isLoading = false,
    required String messageid,
  }) async {
    var data = {
      "messageid": messageid,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postChatBookmarkRemove,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  // post Chat Favorite Remove API call
  Future<ResponseModel> postChatFavoriteAndRemove({
    bool isLoading = false,
    required String messageid,
  }) async {
    var data = {
      "messageid": messageid,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postChatFavoriteRemove,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  // post Chat Message Reaction API call
  Future<ResponseModel> postChatMessageReaction({
    bool isLoading = false,
    required String messageid,
    required String reaction,
  }) async {
    var data = {
      "messageid": messageid,
      "reaction": reaction,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postChatMessageReaction,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  // post Chat Message UnReaction API call
  Future<ResponseModel> postChatMessageUnReaction({
    bool isLoading = false,
    required String messageid,
  }) async {
    var data = {
      "messageid": messageid,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postChatMessageUnReaction,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  // postChatGroupDeleteMessage API call
  Future<ResponseModel> postChatGroupDeleteMessage({
    bool isLoading = false,
    required String messageid,
    required String deletefor,
  }) async {
    var data = {
      "messageid": messageid,
      "deletefor": deletefor,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postChatGroupDeleteMessage,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  // postChatGroupMessageEdit API call
  Future<ResponseModel> postChatGroupMessageEdit({
    bool isLoading = false,
    required String messageid,
    required String message,
  }) async {
    var data = {
      "messageid": messageid,
      "message": message,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postChatGroupMessageEdit,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  // postChatGroupBookmarkRemove API call
  Future<ResponseModel> postChatGroupBookmarkRemove({
    bool isLoading = false,
    required String messageid,
  }) async {
    var data = {
      "messageid": messageid,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postChatGroupBookmarkRemove,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  // postChatGroupFavoriteRemove API call
  Future<ResponseModel> postChatGroupFavoriteRemove({
    bool isLoading = false,
    required String messageid,
  }) async {
    var data = {
      "messageid": messageid,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postChatGroupFavoriteRemove,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  // postChatGroupMessageReaction API call
  Future<ResponseModel> postChatGroupMessageReaction({
    bool isLoading = false,
    required String messageid,
    required String reaction,
  }) async {
    var data = {
      "messageid": messageid,
      "reaction": reaction,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postChatGroupMessageReaction,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  // postChatGroupMessageUnReaction API call
  Future<ResponseModel> postChatGroupMessageUnReaction({
    bool isLoading = false,
    required String messageid,
  }) async {
    var data = {
      "messageid": messageid,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postChatGroupMessageUnReaction,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  // post Chat Pin UnPin API call
  Future<ResponseModel> postChatPinUnPin({
    bool isLoading = false,
    required String userid,
    required bool isPinned,
  }) async {
    var data = {
      "userid": userid,
      "isPinned": isPinned,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postChatPinUnPin,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  // post Chat Pin UnPin API call

  Future<ResponseModel> postGroupChatPinUnPin({
    bool isLoading = false,
    required String groupid,
    required bool isPinned,
  }) async {
    var data = {
      "groupid": groupid,
      "isPinned": isPinned,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postChatGroupPinUnPin,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  // post Chat Pin UnPin API call
  Future<ResponseModel> postChatForward({
    bool isLoading = false,
    required String messageid,
    required List<String> forwardto,
  }) async {
    var data = {
      "messageid": messageid,
      "forwardto": forwardto,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postChatForward,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  // post call initiate api
  Future<ResponseModel> postCallInitaite({
    bool isLoading = false,
    required dynamic receiverId,
    required bool isVideoCall,
    required bool isAudioCall,
    required bool isGroupCall,
  }) async {
    var data = {
      "receiverid": receiverId,
      "isvideocall": isVideoCall,
      "isaudiocall": isAudioCall,
      "isgroupcall": isGroupCall,
      "callingfrom": 'mobile',
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postCallInitaite,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  // post call initiate api
  Future<ResponseModel> postCallHistory({
    bool isLoading = false,
    required int page,
    required int limit,
    required String calltype,
  }) async {
    var data = {
      "page": page,
      "limit": limit,
      "calltype": calltype,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postCallHistory,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  // post Chat Leave Call api
  Future<ResponseModel> postChatLeaveCall({
    bool isLoading = false,
    required String callid,
  }) async {
    var data = {
      "callid": callid,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postChatLeaveCall,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  // post Chat Missed call api
  Future<ResponseModel> postChatMissedCall({
    bool isLoading = false,
    required String callid,
  }) async {
    var data = {
      "callid": callid,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postChatMissedCall,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  // post Chat Missed call api
  Future<ResponseModel> postChatJoinCall({
    bool isLoading = false,
    required String callid,
  }) async {
    var data = {
      "callid": callid,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postChatJoinCall,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  // post Chat Missed call api
  Future<ResponseModel> postHistoryByUser({
    bool isLoading = false,
    required String userid,
  }) async {
    var data = {
      "userid": userid,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postHistoryByUser,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  // postHistoryByGroup
  Future<ResponseModel> postHistoryByGroup({
    bool isLoading = false,
    required String groupid,
  }) async {
    var data = {
      "groupid": groupid,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postHistoryByGroup,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  // postHistoryByCall
  Future<ResponseModel> postHistoryByCall({
    bool isLoading = false,
    required String callid,
  }) async {
    var data = {
      "callid": callid,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postHistoryByCall,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  // postKickMember
  Future<ResponseModel> postKickMember({
    bool isLoading = false,
    required String callid,
    required String memberid,
  }) async {
    var data = {
      "callid": callid,
      "memberid": memberid,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postKickMember,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  // post List Broadcast
  Future<ResponseModel> postListBroadcast({
    bool isLoading = false,
    required int page,
    required int limit,
    required String search,
  }) async {
    var data = {
      "page": page,
      "limit": limit,
      "search": search,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postListBroadcast,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  // get One Broadcast
  Future<ResponseModel> getOneBroadcast({
    bool isLoading = false,
    required String broadcastid,
  }) async {
    var data = {
      "broadcastid": broadcastid,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.getOneBroadcast,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  // postAddBroadcast
  Future<ResponseModel> postAddBroadcast({
    bool isLoading = false,
    required String broadcastid,
    required String broadcasttitle,
    required List<String> membersList,
  }) async {
    var data = {
      "broadcastid": broadcastid,
      "broadcasttitle": broadcasttitle,
      "members": membersList,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postAddBroadcast,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  // postPinUnPinBroadcast
  Future<ResponseModel> postPinUnPinBroadcast({
    bool isLoading = false,
    required String broadcastid,
  }) async {
    var data = {
      "broadcastid": broadcastid,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postPinUnPinBroadcast,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  // postDeleteBroadcast
  Future<ResponseModel> postDeleteBroadcast({
    bool isLoading = false,
    required String broadcastid,
  }) async {
    var data = {
      "broadcastid": broadcastid,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postDeleteBroadcast,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  // postChatListBroadcast
  Future<ResponseModel> postChatListBroadcast({
    bool isLoading = false,
    required String broadcastid,
    required int page,
    required int limit,
  }) async {
    var data = {
      "broadcastid": broadcastid,
      "page": page,
      "limit": limit,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postChatListBroadcast,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  // Send Message API call
  Future<ResponseModel> postSendMessageBroadcast({
    required String broadcastid,
    String? message,
    String? product,
    String? latitude,
    String? longitude,
    String? pollid,
    String? context,
    List<String>? usersList,
    bool isLoading = false,
    List<ImageFormData>? mediaFileList,
  }) async {
    var data = usersList?.isNotEmpty ?? false
        ? {
            'broadcastid': broadcastid,
            'users': usersList ?? [],
          }
        : <String, String>{
            'broadcastid': broadcastid,
            if (message?.isNotEmpty ?? false) 'message': message ?? "",
            if (product?.isNotEmpty ?? false) 'product': product ?? "",
            if (latitude?.isNotEmpty ?? false) 'latitude': latitude ?? "",
            if (longitude?.isNotEmpty ?? false) 'longitude': longitude ?? "",
            if (pollid?.isNotEmpty ?? false) 'pollid': pollid ?? "",
            if (context?.isNotEmpty ?? false) 'context': context ?? "",
          };
    var response = await apiWrapper.makeRequest(
      EndPoints.postSendMessageBroadcast,
      usersList?.isNotEmpty ?? false ? Request.post : Request.postWithFormData,
      data,
      isLoading,
      Utility.commonHeader(),
      mediaFileList: mediaFileList,
    );
    return response;
  }

  // Post Chat Send Bulk Message API call
  Future<ResponseModel> postSendMultiMediaBroadcast({
    required String broadcastid,
    String? message,
    String? context,
    List<ImageFormData>? mediaFileList,
    bool isLoading = false,
  }) async {
    var data = {
      'broadcastid': broadcastid,
      if (message?.isNotEmpty ?? false) 'message': message ?? "",
      if (context?.isNotEmpty ?? false) 'context': context ?? "",
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postSendMultiMediaBroadcast,
      Request.postWithFormData,
      data,
      isLoading,
      Utility.commonHeader(),
      mediaFileList: mediaFileList,
    );
    return response;
  }

  // post Send Fcm Api API call
  Future<ResponseModel> postSendFcmApi({
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
    final title = "Incoming call";
    final body =
        "${userName.toString().trim().isEmpty ? "Someone" : userName.toString().trim()} is calling";

    final payloadData = {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "callid": callid.toString(),
      "privilegeExpiredTs": "1713765152",
      "title": title,
      "body": body,
      "fromusername": userName.toString(),
      "isgroupcall": isgroupcall.toString(),
      "isvideocall": isvideocall.toString(),
      "agoratoken": agoratoken.toString(),
      "type": type.toString(),
      "banner": banner.toString(),
      "fromid": fromid.toString(),
      "toid": toid.toString(),
      "agorachannelName": agorachannelName.toString(),
      "isaudiocall": isaudiocall.toString(),
      "role": "1",
    };

    var data = {
      "message": {
        "token": registrationToken,
        "data": payloadData,
        "apns": {
          "headers": {
            "apns-push-type": "background",
            "apns-priority": "10",
          },
          "payload": {
            "aps": {"content-available": 1}
          }
        },
        "android": {
          "priority": "high",
          "ttl": "30s",
        }
      }
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postSendFcmApi,
      Request.postApiWithoutBaseURL,
      data,
      isLoading,
      {
        'Content-Type': 'application/json',
        'Authorization': "Bearer $authToken",
        'authorization': "Bearer $authToken",
      },
    );
    return response;
  }

  Future<ResponseModel> postOnlineOffline({
    required bool isonline,
    bool isLoading = false,
  }) async {
    var data = {
      'isonline': isonline,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postOnlineOffline,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postPhotoVideo({
    required String userid,
    required int page,
    required int limit,
    bool isLoading = false,
  }) async {
    var data = {
      "userid": userid,
      "page": page,
      "limit": limit,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postPhotoVideo,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postAudios({
    required String userid,
    required int page,
    required int limit,
    bool isLoading = false,
  }) async {
    var data = {
      "userid": userid,
      "page": page,
      "limit": limit,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postAudios,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postDocs({
    required String userid,
    required int page,
    required int limit,
    bool isLoading = false,
  }) async {
    var data = {
      "userid": userid,
      "page": page,
      "limit": limit,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postDocs,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postLinks({
    required String userid,
    required int page,
    required int limit,
    bool isLoading = false,
  }) async {
    var data = {
      "userid": userid,
      "page": page,
      "limit": limit,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postLinks,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> listFavoriteMessage({
    required String userid,
    required int page,
    required int limit,
    bool isLoading = false,
  }) async {
    var data = {
      "userid": userid,
      "page": page,
      "limit": limit,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.listFavoriteMessage,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> listGroupFavoriteMessage({
    required String groupid,
    required int page,
    required int limit,
    bool isLoading = false,
  }) async {
    var data = {
      "groupid": groupid,
      "page": page,
      "limit": limit,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.listGroupFavoriteMessage,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> listChatBookmarkMessage({
    required int page,
    required int limit,
    bool isLoading = false,
  }) async {
    var data = {
      "page": page,
      "limit": limit,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.listChatBookmarkMessage,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> listGroupBookmarkMessage({
    required int page,
    required int limit,
    bool isLoading = false,
  }) async {
    var data = {
      "page": page,
      "limit": limit,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.listGroupBookmarkMessage,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postPollVote({
    required String pollid,
    required String optionid,
    bool isLoading = false,
  }) async {
    var data = {
      "pollid": pollid,
      "optionid": optionid,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postPollVote,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postSyncContacts({
    required List<Map<String, dynamic>> contactLists,
    bool isLoading = false,
  }) async {
    var data = {
      "contactlist": contactLists,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postSyncContacts,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postBrodcastDeleteMeg({
    required String messageid,
    bool isLoading = false,
  }) async {
    var data = {
      "messageid": messageid,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postBrodcastDeleteMeg,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postBrodcastFavorite({
    required String messageid,
    bool isLoading = false,
  }) async {
    var data = {
      "messageid": messageid,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postBrodcastFavorite,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postDeleteCall({
    required String callid,
    bool isLoading = false,
  }) async {
    var data = {
      "callid": callid,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postDeleteCall,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postLogout({
    bool isLoading = false,
  }) async {
    var data = {};
    var response = await apiWrapper.makeRequest(
      EndPoints.postLogout,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postSaveMetting({
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
    var data = {
      'meetingid': meetingId,
      'title': title,
      'description': description,
      "meetingstartdate": meetingstartdate,
      "meetingstarttime": meetingstarttime,
      "meetingenddate": meetingenddate,
      "meetingendtime": meetingendtime,
      'members': memberList,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postSaveMetting,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postListFavoriteMessages({
    bool isLoading = false,
    required String broadcastid,
    required int page,
    required int limit,
  }) async {
    var data = {
      "broadcastid": broadcastid,
      "page": page,
      "limit": limit,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postListFavoriteMessages,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postBookmarksList({
    bool isLoading = false,
    required int page,
    required int limit,
  }) async {
    var data = {
      "page": page,
      "limit": limit,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postBookmarksList,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postBrodcastPhoto({
    bool isLoading = false,
    required String broadcastid,
    required int page,
    required int limit,
  }) async {
    var data = {
      "broadcastid": broadcastid,
      "page": page,
      "limit": limit,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postBrodcastPhoto,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postBrodcastAudio({
    bool isLoading = false,
    required String broadcastid,
    required int page,
    required int limit,
  }) async {
    var data = {
      "broadcastid": broadcastid,
      "page": page,
      "limit": limit,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postBrodcastAudio,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postBrodcastDoc({
    bool isLoading = false,
    required String broadcastid,
    required int page,
    required int limit,
  }) async {
    var data = {
      "broadcastid": broadcastid,
      "page": page,
      "limit": limit,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postBrodcastDoc,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postBrodcastLink({
    bool isLoading = false,
    required String broadcastid,
    required int page,
    required int limit,
  }) async {
    var data = {
      "broadcastid": broadcastid,
      "page": page,
      "limit": limit,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postBrodcastLink,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postBrodcastMemberRemove({
    bool isLoading = false,
    required String broadcastid,
    required String memberid,
  }) async {
    var data = {
      "broadcastid": broadcastid,
      "memberid": memberid,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postBrodcastMemberRemove,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postMeetingGetOne({
    bool isLoading = false,
    required String meetingid,
  }) async {
    var data = {
      "meetingid": meetingid,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postMeetingGetOne,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postMeetingHostingList({
    bool isLoading = false,
    required int page,
    required int limit,
    required String search,
  }) async {
    var data = {
      "page": page,
      "limit": limit,
      "search": search,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postMeetingHostingList,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postMeetingJoinList({
    bool isLoading = false,
    required int page,
    required int limit,
    required String search,
  }) async {
    var data = {
      "page": page,
      "limit": limit,
      "search": search,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postMeetingJoinList,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postMeetingPastList({
    bool isLoading = false,
    required int page,
    required int limit,
    required String search,
  }) async {
    var data = {
      "page": page,
      "limit": limit,
      "search": search,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postMeetingPastList,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postHostMeetingStart({
    bool isLoading = false,
    required String meetingid,
  }) async {
    var data = {
      "meetingid": meetingid,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postHostMeetingStart,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postMeetingJoin({
    bool isLoading = false,
    required String meetingid,
  }) async {
    var data = {
      "meetingid": meetingid,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postMeetingJoin,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postMeetingLeave({
    bool isLoading = false,
    required String meetingid,
  }) async {
    var data = {
      "meetingid": meetingid,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postMeetingLeave,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postOutgoingCallAddMember({
    bool isLoading = false,
    required String userid,
    required String meetingid,
  }) async {
    var data = {
      "userid": userid,
      "meetingid": meetingid,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postOutgoingCallAddMember,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postGroupPhoto({
    bool isLoading = false,
    required String groupid,
    required int page,
    required int limit,
  }) async {
    var data = {
      "groupid": groupid,
      "page": page,
      "limit": limit,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postGroupPhoto,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postGroupAudio({
    bool isLoading = false,
    required String groupid,
    required int page,
    required int limit,
  }) async {
    var data = {
      "groupid": groupid,
      "page": page,
      "limit": limit,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postGroupAudio,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postGroupDoc({
    bool isLoading = false,
    required String groupid,
    required int page,
    required int limit,
  }) async {
    var data = {
      "groupid": groupid,
      "page": page,
      "limit": limit,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postGroupDoc,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postGroupLink({
    bool isLoading = false,
    required String groupid,
    required int page,
    required int limit,
  }) async {
    var data = {
      "groupid": groupid,
      "page": page,
      "limit": limit,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postGroupLink,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postChatHide({
    bool isLoading = false,
    bool isLock = false,
    required List<String> friendrequestids,
  }) async {
    var data = {
      "friendrequestids": friendrequestids,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postChatHide,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(isMultipalToken: true, isLock: false),
    );
    return response;
  }

  Future<ResponseModel> postGroupChatHide({
    bool isLoading = false,
    bool isLock = false,
    required List<String> groupids,
  }) async {
    var data = {
      "groupids": groupids,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postGroupChatHide,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(isMultipalToken: true, isLock: false),
    );
    return response;
  }

  Future<ResponseModel> postCreatePinLock({
    bool isLoading = false,
    required String pin,
  }) async {
    var data = {
      "pin": pin,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postCreatePinLock,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postVerifyPinLock({
    bool isLoading = false,
    required String pin,
  }) async {
    var data = {
      "pin": pin,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postVerifyPinLock,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postChangePinLock({
    bool isLoading = false,
    required String oldpin,
    required String newpin,
  }) async {
    var data = {
      "oldpin": oldpin,
      "newpin": newpin,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postChangePinLock,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postForgotPinLock({
    bool isLoading = false,
  }) async {
    var data = {};
    var response = await apiWrapper.makeRequest(
      EndPoints.postForgotPinLock,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(isMultipalToken: true, isLock: true),
    );
    return response;
  }

  Future<ResponseModel> postDisableAccount({
    bool isLoading = false,
  }) async {
    var data = {};
    var response = await apiWrapper.makeRequest(
      EndPoints.postDisableAccount,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postDeleteAccount({
    bool isLoading = false,
  }) async {
    var data = {};
    var response = await apiWrapper.makeRequest(
      EndPoints.deleteAccountApi,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postNotificationStatusforChat({
    bool isLoading = false,
  }) async {
    var data = {};
    var response = await apiWrapper.makeRequest(
      EndPoints.postNotificationStatusforChat,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postNotificationStatusforGroup({
    bool isLoading = false,
  }) async {
    var data = {};
    var response = await apiWrapper.makeRequest(
      EndPoints.postNotificationStatusforGroup,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postRecoveryEmail({
    bool isLoading = false,
    required String email,
  }) async {
    var data = {
      "email": email,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postRecoveryEmail,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postStorageInfo({
    bool isLoading = false,
  }) async {
    var data = {};
    var response = await apiWrapper.makeRequest(
      EndPoints.postStorageInfo,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postChatLock({
    bool isLoading = false,
    required List<String> friendrequestids,
  }) async {
    var data = {
      "friendrequestids": friendrequestids,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postChatLock,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(isMultipalToken: true, isLock: true),
    );
    return response;
  }

  Future<ResponseModel> postGroupChatLock({
    bool isLoading = false,
    bool isLock = false,
    required List<String> groupids,
  }) async {
    var data = {
      "groupids": groupids,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postGroupChatLock,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(isMultipalToken: true, isLock: true),
    );
    return response;
  }

  Future<ResponseModel> postChatLockFriends({
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
    var data = {
      "page": page,
      "limit": limit,
      "search": search,
      "unread_messages": unreadMessages,
      "contact_friend": contactFriend,
      "fefield_friend": fefieldFriend,
      "receiver_friend": receiverFriend,
      "sender_friend": senderFriend,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postChatLockFriends,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(isMultipalToken: true, isLock: true),
    );
    return response;
  }

  Future<ResponseModel> postGroupChatLockList({
    bool isLoading = false,
    required int page,
    required int limit,
    required String search,
    required bool isunreadmessagefilteronoff,
  }) async {
    var data = {
      "page": page,
      "limit": limit,
      "search": search,
      "isunreadmessagefilteronoff": isunreadmessagefilteronoff
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postGroupChatLockList,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(isMultipalToken: true, isLock: true),
    );
    return response;
  }

  Future<ResponseModel> postUnLockChat({
    bool isLoading = false,
    bool isLock = false,
    required List<String> friendrequestids,
  }) async {
    var data = {
      "friendrequestids": friendrequestids,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postUnLockChat,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postUnLockGroup({
    bool isLoading = false,
    bool isLock = false,
    required List<String> groupids,
  }) async {
    var data = {
      "groupids": groupids,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postUnLockGroup,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postCreatePinHide({
    bool isLoading = false,
    required String pin,
  }) async {
    var data = {
      "pin": pin,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postCreatePinHide,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postVerifyPinHide({
    bool isLoading = false,
    required String pin,
  }) async {
    var data = {
      "pin": pin,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postVerifyPinHide,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postChangePinHide({
    bool isLoading = false,
    required String oldpin,
    required String newpin,
  }) async {
    var data = {
      "oldpin": oldpin,
      "newpin": newpin,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postChangePinHide,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postForgotPinHide({
    bool isLoading = false,
  }) async {
    var data = {};
    var response = await apiWrapper.makeRequest(
      EndPoints.postForgotPinHide,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(isMultipalToken: true, isLock: false),
    );
    return response;
  }

  Future<ResponseModel> postChatHideFriends({
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
    var data = {
      "page": page,
      "limit": limit,
      "search": search,
      "unread_messages": unreadMessages,
      "contact_friend": contactFriend,
      "fefield_friend": fefieldFriend,
      "receiver_friend": receiverFriend,
      "sender_friend": senderFriend,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postChatHideFriends,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(isMultipalToken: true, isLock: false),
    );
    return response;
  }

  Future<ResponseModel> postGroupChatHideList({
    bool isLoading = false,
    required int page,
    required int limit,
    required String search,
    required bool isunreadmessagefilteronoff,
  }) async {
    var data = {
      "page": page,
      "limit": limit,
      "search": search,
      "isunreadmessagefilteronoff": isunreadmessagefilteronoff
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postGroupChatHideList,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(isMultipalToken: true, isLock: false),
    );
    return response;
  }

  Future<ResponseModel> postSaveSubUser({
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
    var data = {
      "subuserid": subuserid,
      "fullname": fullname,
      "username": username,
      "email": email,
      "mobile": mobile,
      "country_code": country_code,
      'country_wise_contact': {
        "number": mobile.isEmpty ? "" : "0${mobile}",
        "internationalNumber": "${country_code} ${mobile}",
        "nationalNumber": "0${mobile}",
        "e164Number": country_code + mobile,
        "countryCode": PhoneNumber.getISO2CodeByPrefix(country_code),
        "dialCode": country_code
      },
      "password": password,
      "chats": chats,
      "groups": groups,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postSaveSubUser,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postSubUserList({
    bool isLoading = false,
    required int page,
    required int limit,
    required String search,
  }) async {
    var data = {
      "page": page,
      "limit": limit,
      "search": search,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postSubUserList,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postChangePassword({
    bool isLoading = false,
    required String subuserid,
    required String password,
  }) async {
    var data = {
      "subuserid": subuserid,
      "password": password,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postChangePassword,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postUpdateSubUser({
    bool isLoading = false,
    required String subuserid,
  }) async {
    var data = {
      "subuserid": subuserid,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postUpdateSubUser,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postClearChats({
    bool isLoading = false,
  }) async {
    var data = {};
    var response = await apiWrapper.makeRequest(
      EndPoints.postClearChats,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postReadReceiptsstatus({
    bool isLoading = false,
  }) async {
    var data = {};
    var response = await apiWrapper.makeRequest(
      EndPoints.postReadReceiptsstatus,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postLastSeenOnlineOfflineStatus({
    bool isLoading = false,
  }) async {
    var data = {};
    var response = await apiWrapper.makeRequest(
      EndPoints.postLastSeenOnlineOfflineStatus,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postChatLockVerifyOtp({
    bool isLoading = false,
    required int otp,
    required int pin,
  }) async {
    var data = {
      "otp": otp,
      "pin": pin,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postChatLockVerifyOtp,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postChatHideVerifyOtp({
    bool isLoading = false,
    required int otp,
    required int pin,
  }) async {
    var data = {
      "otp": otp,
      "pin": pin,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postChatHideVerifyOtp,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postChangeNumber({
    bool isLoading = false,
    required String oldmobile,
    required String oldcountry_code,
    required String newmobile,
    required String newcountry_code,
  }) async {
    var data = {
      "oldmobile": oldmobile,
      "oldcountry_code": oldcountry_code,
      "newmobile": newmobile,
      "newcountry_code": newcountry_code,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postChangeNumber,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postChangeNumberVerify({
    bool isLoading = false,
    required String key,
    required String otp,
    required String mobile,
  }) async {
    var data = {
      "key": key,
      "otp": otp,
      "mobile": mobile,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postChangeNumberVerify,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postClearIndividualChats({
    bool isLoading = false,
    required String userid,
  }) async {
    var data = {
      'userid': userid,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postClearIndividualChats,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postClearGroupChats({
    bool isLoading = false,
    required String groupid,
  }) async {
    var data = {
      'groupid': groupid,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postClearGroupChats,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postArchiveChat({
    bool isLoading = false,
    required List<String> friendrequestids,
  }) async {
    var data = {
      'friendrequestids': friendrequestids,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postArchiveChat,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postArchiveGroupChat({
    bool isLoading = false,
    required List<String> groupids,
  }) async {
    var data = {
      'groupids': groupids,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postArchiveGroupChat,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postArchiveChatList({
    bool isLoading = false,
    required String search,
    required bool unreadMessages,
    required bool contactFriend,
    required bool fefieldFriend,
    required bool receiverFriend,
    required bool senderFriend,
  }) async {
    var data = {
      "search": search,
      "unread_messages": unreadMessages,
      "contact_friend": contactFriend,
      "fefield_friend": fefieldFriend,
      "receiver_friend": receiverFriend,
      "sender_friend": senderFriend,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postArchiveChatList,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postArchiveGroupChatList({
    bool isLoading = false,
    required String search,
    required bool isunreadmessagefilteronoff,
  }) async {
    var data = {
      "search": search,
      "isunreadmessagefilteronoff": isunreadmessagefilteronoff
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postArchiveGroupChatList,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postArchiveChatRemove({
    bool isLoading = false,
    required List<String> friendrequestids,
  }) async {
    var data = {
      'friendrequestids': friendrequestids,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postArchiveChatRemove,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postArchiveGroupChatRemove({
    bool isLoading = false,
    required List<String> groupids,
  }) async {
    var data = {
      'groupids': groupids,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postArchiveGroupChatRemove,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postReadChat({
    bool isLoading = false,
    required List<String> friendrequestids,
  }) async {
    var data = {
      'friendrequestids': friendrequestids,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postReadChat,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postUnReadChat({
    bool isLoading = false,
    required List<String> friendrequestids,
  }) async {
    var data = {
      'friendrequestids': friendrequestids,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postUnReadChat,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postReadGroupChat({
    bool isLoading = false,
    required List<String> groupids,
  }) async {
    var data = {
      'groupids': groupids,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postReadGroupChat,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postUnReadGroupChat({
    bool isLoading = false,
    required List<String> groupids,
  }) async {
    var data = {
      'groupids': groupids,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postUnReadGroupChat,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postSubUserLogin({
    bool isLoading = false,
    required String username,
    required String password,
    required String fcmToken,
  }) async {
    var data = {
      'username': username,
      'password': password,
      'fcm_token': fcmToken,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postSubUserLogin,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postNotificationList({
    bool isLoading = false,
    required int page,
    required int limit,
  }) async {
    var data = {
      'page': page,
      'limit': limit,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postNotificationList,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postDeleteNotification({
    bool isLoading = false,
    String? notificationId,
  }) async {
    final data = notificationId == null || notificationId.isEmpty
        ? {}
        : {
            'notificationid': notificationId,
          };
    var response = await apiWrapper.makeRequest(
      EndPoints.postDeleteNotification,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postFriendProductGetOne({
    bool isLoading = false,
    required String productid,
  }) async {
    var data = {
      'productid': productid,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postFriendProductGetOne,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postUnFriend({
    bool isLoading = false,
    required String friendrequestid,
  }) async {
    var data = {
      'friendrequestid': friendrequestid,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postUnFriend,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postIndiviualBookmark({
    bool isLoading = false,
    required String userid,
    required int page,
    required int limit,
  }) async {
    var data = {
      'userid': userid,
      'page': page,
      'limit': limit,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postIndiviualBookmark,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postMoveHideToLock({
    bool isLoading = false,
    required List<String> friendrequestids,
  }) async {
    var data = {
      'friendrequestids': friendrequestids,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postMoveHideToLock,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postMoveHideToLockGroup({
    bool isLoading = false,
    required List<String> groupids,
  }) async {
    var data = {
      'groupids': groupids,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postMoveHideToLockGroup,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postChatReport({
    bool isLoading = false,
    required String reportid,
    required String userid,
    required String reason,
  }) async {
    var data = {
      'reportid': reportid,
      'userid': userid,
      'reason': reason,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postChatReport,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postChatReportList({
    bool isLoading = false,
    required int page,
    required int limit,
  }) async {
    var data = {
      'page': page,
      'limit': limit,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postChatReportList,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postChatReportGetOne({
    bool isLoading = false,
    required String reportid,
  }) async {
    var data = {
      'reportid': reportid,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postChatReportGetOne,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postGroupChatReport({
    bool isLoading = false,
    required String reportid,
    required String groupid,
    required String reason,
  }) async {
    var data = {
      'reportid': reportid,
      'groupid': groupid,
      'reason': reason,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postGroupChatReport,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postGroupChatReportList({
    bool isLoading = false,
    required int page,
    required int limit,
  }) async {
    var data = {
      'page': page,
      'limit': limit,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postGroupChatReportList,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postGroupChatReportGetOne({
    bool isLoading = false,
    required String reportid,
  }) async {
    var data = {
      'reportid': reportid,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postGroupChatReportGetOne,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> postMeetingCancle({
    bool isLoading = false,
    required String meetingid,
  }) async {
    var data = {
      'meetingid': meetingid,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.postMeetingCancle,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }

  Future<ResponseModel> updateFcmToken({
    bool isLoading = false,
    required String fcmToken,
  }) async {
    var data = {
      'fcm_token': fcmToken,
    };
    var response = await apiWrapper.makeRequest(
      EndPoints.updateFcmToken,
      Request.post,
      data,
      isLoading,
      Utility.commonHeader(),
    );
    return response;
  }
}
