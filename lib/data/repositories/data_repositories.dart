import 'package:flutter/foundation.dart';
import 'package:chatnest/domain/domain.dart';

import '../helpers/connect_helper.dart';

/// Repositories (retrieve data, heavy processing etc..)
class DataRepository extends DomainRepository {
  /// [connectHelper] : A connection helper which will connect to the
  /// remote to get the data.
  DataRepository(this.connectHelper);

  final ConnectHelper connectHelper;

  @override
  void clearData(dynamic key) {
    throw UnimplementedError();
  }

  /// Delete the box
  @override
  void deleteBox() {
    throw UnimplementedError();
  }

  /// returns stored string value
  @override
  String getStringValue(String key) {
    throw UnimplementedError();
  }

  /// returns stored string value
  @override
  int getIntValue(String key) {
    throw UnimplementedError();
  }

  /// store the data
  @override
  void saveValue(dynamic key, dynamic value) {
    throw UnimplementedError();
  }

  /// return bool value
  @override
  bool getBoolValue(String key) => throw UnimplementedError();

  /// Get data from secure storage
  @override
  Future<String> getSecuredValue(String key) async {
    throw UnimplementedError();
  }

  /// Save data in secure storage
  @override
  void saveValueSecurely(String key, String value) {
    throw UnimplementedError();
  }

  /// Delete data from secure storage
  @override
  void deleteSecuredValue(String key) {
    throw UnimplementedError();
  }

  /// Delete all data from secure storage
  @override
  void deleteAllSecuredValues() {
    throw UnimplementedError();
  }

  /// API to get the IP of the user
  @override
  Future<String> getIp() async => await connectHelper.getIp();

  Future<ResponseModel> sendOtpApi({
    required String mobile,
    required String countryCode,
    required String fcmToken,
    bool isLoading = false,
  }) async =>
      connectHelper.sendOtpApi(
        mobile: mobile,
        countryCode: countryCode,
        fcmToken: fcmToken,
        isLoading: isLoading,
      );

  Future<ResponseModel> verifyOtpApi({
    required String key,
    required String otp,
    required String mobile,
    bool isLoading = false,
  }) async =>
      connectHelper.verifyOtpApi(
        mobile: mobile,
        key: key,
        otp: otp,
        isLoading: isLoading,
      );

  Future<ResponseModel> uploadBrochure({
    required String filePath,
    bool isLoading = false,
  }) async =>
      connectHelper.uploadBrochure(
        filePath: filePath,
        isLoading: isLoading,
      );

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
  }) async =>
      connectHelper.setProfile(
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

  Future<ResponseModel> setProfilePic({
    required String filePath,
    bool isLoading = false,
  }) async =>
      connectHelper.setProfilePic(
        filePath: filePath,
        isLoading: isLoading,
      );

  Future<ResponseModel> getProfile({
    bool isLoading = false,
  }) async =>
      connectHelper.getProfile(
        isLoading: isLoading,
      );

  Future<ResponseModel> getBusinessCategories({
    bool isLoading = false,
  }) async =>
      connectHelper.getBusinessCategories(
        isLoading: isLoading,
      );

  Future<ResponseModel> getProductCategory({
    bool isLoading = false,
    required int page,
    required int limit,
    required String search,
  }) async =>
      connectHelper.getProductCategory(
        isLoading: isLoading,
        page: page,
        limit: limit,
        search: search,
      );

  Future<ResponseModel> setBusinessProfile({
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
  }) async =>
      connectHelper.setBusinessProfile(
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
  }) async =>
      connectHelper.addProduct(
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

  Future<ResponseModel> setProductPhoto({
    required String filePath,
    bool isLoading = false,
  }) async =>
      connectHelper.setProductPhoto(
        filePath: filePath,
        isLoading: isLoading,
      );

  Future<ResponseModel> uploadProductVideo({
    required String filePath,
    bool isLoading = false,
  }) async =>
      connectHelper.uploadProductVideo(
        filePath: filePath,
        isLoading: isLoading,
      );

  Future<ResponseModel> getproductList({
    bool isLoading = false,
    required int page,
    required int limit,
    required String search,
    required String business,
    required List<String> parentcategory,
    required List<String> childcategory,
  }) async =>
      connectHelper.getproductList(
        isLoading: isLoading,
        page: page,
        limit: limit,
        search: search,
        business: business,
        childcategory: childcategory,
        parentcategory: parentcategory,
      );

  Future<ResponseModel> getOneProduct({
    bool isLoading = false,
    required String productid,
  }) async =>
      connectHelper.getOneProduct(
        isLoading: isLoading,
        productid: productid,
      );

  Future<ResponseModel> removeProduct({
    required String productid,
    bool isLoading = false,
  }) async =>
      connectHelper.removeProduct(
        productid: productid,
        isLoading: isLoading,
      );

  Future<ResponseModel> removeProductPhoto({
    required String filekey,
    bool isLoading = false,
  }) async =>
      connectHelper.removeProductPhoto(
        filekey: filekey,
        isLoading: isLoading,
      );

  Future<ResponseModel> removeProductVideo({
    required String filekey,
    bool isLoading = false,
  }) async =>
      connectHelper.removeProductVideo(
        filekey: filekey,
        isLoading: isLoading,
      );

  Future<ResponseModel> setBusinessProfilePic({
    required String filePath,
    bool isLoading = false,
  }) async =>
      connectHelper.setBusinessProfilePic(
        filePath: filePath,
        isLoading: isLoading,
      );

  Future<ResponseModel> uploadBusinessPhoto({
    required String filePath,
    bool isLoading = false,
  }) async =>
      connectHelper.uploadBusinessPhoto(
        filePath: filePath,
        isLoading: isLoading,
      );

  Future<ResponseModel> uploadBusinessVideo({
    required String filePath,
    bool isLoading = false,
  }) async =>
      connectHelper.uploadBusinessVideo(
        filePath: filePath,
        isLoading: isLoading,
      );

  Future<ResponseModel> removeBrochure({
    required String filekey,
    bool isLoading = false,
  }) async =>
      connectHelper.removeBrochure(
        filekey: filekey,
        isLoading: isLoading,
      );

  Future<ResponseModel> removeBusinessPhoto({
    required String filekey,
    bool isLoading = false,
  }) async =>
      connectHelper.removeBusinessPhoto(
        filekey: filekey,
        isLoading: isLoading,
      );

  Future<ResponseModel> removeBusinessVideo({
    required String filekey,
    bool isLoading = false,
  }) async =>
      connectHelper.removeBusinessVideo(
        filekey: filekey,
        isLoading: isLoading,
      );

  Future<ResponseModel> postFindFriendsLocation({
    bool isLoading = false,
    required double latitude,
    required double longitude,
  }) async =>
      connectHelper.postFindFriendsLocation(
        isLoading: isLoading,
        latitude: latitude,
        longitude: longitude,
      );

  Future<ResponseModel> postFindFriendsList({
    bool isLoading = false,
    required int page,
    required int limit,
    required String search,
  }) async =>
      connectHelper.postFindFriendsList(
        isLoading: isLoading,
        page: page,
        limit: limit,
        search: search,
      );

  Future<ResponseModel> sendNewFriendRequest({
    bool isLoading = false,
    required String receiverid,
    required String message,
    required String product,
    required AuthorizedPermissions authorizedPermissions,
  }) async =>
      connectHelper.sendNewFriendRequest(
          receiverid: receiverid,
          message: message,
          product: product,
          authorizedPermissions: authorizedPermissions,
          isLoading: isLoading);

  Future<ResponseModel> cancelSentRequest({
    bool isLoading = false,
    required String friendrequestid,
  }) async =>
      connectHelper.cancelSentRequest(
        friendrequestid: friendrequestid,
        isLoading: isLoading,
      );

  Future<ResponseModel> sentRequestList({
    bool isLoading = false,
    required int page,
    required int limit,
  }) async =>
      connectHelper.sentRequestList(
        isLoading: isLoading,
        page: page,
        limit: limit,
      );

  Future<ResponseModel> blockedUserList({
    bool isLoading = false,
    required int page,
    required int limit,
  }) async =>
      connectHelper.blockedUserList(
        isLoading: isLoading,
        page: page,
        limit: limit,
      );

  Future<ResponseModel> receivedrRequestList({
    bool isLoading = false,
    required int page,
    required int limit,
  }) async =>
      connectHelper.receivedrRequestList(
        isLoading: isLoading,
        page: page,
        limit: limit,
      );

  Future<ResponseModel> respondFriendsRequest({
    bool isLoading = false,
    required String friendrequestid,
    required String status,
    required AuthorizedPermissions authorizedPermissions,
  }) async =>
      connectHelper.respondFriendsRequest(
        friendrequestid: friendrequestid,
        status: status,
        authorizedPermissions: authorizedPermissions,
        isLoading: isLoading,
      );

  Future<ResponseModel> updateFriendsRequest({
    bool isLoading = false,
    required String friendrequestid,
    required String status,
    required AuthorizedPermissions authorizedPermissions,
  }) async =>
      connectHelper.updateFriendsRequest(
        friendrequestid: friendrequestid,
        status: status,
        authorizedPermissions: authorizedPermissions,
        isLoading: isLoading,
      );

  Future<ResponseModel> unblockUser({
    bool isLoading = false,
    required String blockeduserid,
  }) async =>
      connectHelper.unblockUser(
        blockeduserid: blockeduserid,
        isLoading: isLoading,
      );

  Future<ResponseModel> getBusinessList({
    bool isLoading = false,
  }) async =>
      connectHelper.getBusinessList(
        isLoading: isLoading,
      );

  Future<ResponseModel> getOneBusiness({
    bool isLoading = false,
    required String businessid,
  }) async =>
      connectHelper.getOneBusiness(
        businessid: businessid,
        isLoading: isLoading,
      );

  Future<ResponseModel> removeBusiness({
    bool isLoading = false,
    required String businessid,
  }) async =>
      connectHelper.removeBusiness(
        businessid: businessid,
        isLoading: isLoading,
      );

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
  }) async =>
      connectHelper.myFriendsList(
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

  Future<ResponseModel> createGroupApi({
    bool isLoading = false,
    required String groupid,
    required String profileimage,
    required String name,
    required String description,
    required List<String> members,
    required AuthorizedPermissions authorizedPermissions,
  }) async =>
      connectHelper.createGroupApi(
        isLoading: isLoading,
        groupid: groupid,
        profileimage: profileimage,
        name: name,
        description: description,
        members: members,
        authorizedPermissions: authorizedPermissions,
      );

  Future<ResponseModel> uploadGroupProfile({
    bool isLoading = false,
    required String filePath,
  }) async =>
      connectHelper.uploadGroupProfile(
        isLoading: isLoading,
        filePath: filePath,
      );

  Future<ResponseModel> groupsChatList({
    bool isLoading = false,
    required int page,
    required int limit,
    required String search,
    required bool isunreadmessagefilteronoff,
  }) async =>
      connectHelper.groupsChatList(
        page: page,
        limit: limit,
        search: search,
        isunreadmessagefilteronoff: isunreadmessagefilteronoff,
        isLoading: isLoading,
      );

  Future<ResponseModel> postGroupListWithoutPaging({
    bool isLoading = false,
    required String search,
    required bool isunreadmessagefilteronoff,
  }) async =>
      connectHelper.postGroupListWithoutPaging(
        search: search,
        isunreadmessagefilteronoff: isunreadmessagefilteronoff,
        isLoading: isLoading,
      );

  Future<ResponseModel> getOneGroup({
    bool isLoading = false,
    required String groupid,
  }) async =>
      connectHelper.getOneGroup(
        isLoading: isLoading,
        groupid: groupid,
      );

  Future<ResponseModel> groupSetManager({
    bool isLoading = false,
    required String groupid,
    required String userid,
  }) async =>
      connectHelper.groupSetManager(
        isLoading: isLoading,
        groupid: groupid,
        userid: userid,
      );

  Future<ResponseModel> groupUnSetManager({
    bool isLoading = false,
    required String groupid,
    required String userid,
  }) async =>
      connectHelper.groupUnSetManager(
        isLoading: isLoading,
        groupid: groupid,
        userid: userid,
      );

  Future<ResponseModel> leaveGroup({
    bool isLoading = false,
    required String groupid,
  }) async =>
      connectHelper.leaveGroup(
        isLoading: isLoading,
        groupid: groupid,
      );

  Future<ResponseModel> addMemberGroup({
    bool isLoading = false,
    required String groupid,
    required List<String> membersList,
  }) async =>
      connectHelper.addMemberGroup(
        isLoading: isLoading,
        groupid: groupid,
        membersList: membersList,
      );

  Future<ResponseModel> removeMemberGroup({
    bool isLoading = false,
    required String groupid,
    required List<String> membersList,
  }) async =>
      connectHelper.removeMemberGroup(
        isLoading: isLoading,
        groupid: groupid,
        membersList: membersList,
      );

  Future<ResponseModel> groupSetPermission({
    bool isLoading = false,
    required String groupid,
    required AuthorizedPermissions authorizedPermissions,
  }) async =>
      connectHelper.groupSetPermission(
        isLoading: isLoading,
        groupid: groupid,
        authorizedPermissions: authorizedPermissions,
      );

  Future<ResponseModel> removeGroupProfile({
    bool isLoading = false,
    required String filekey,
  }) async =>
      connectHelper.removeGroupProfile(
        isLoading: isLoading,
        filekey: filekey,
      );

  Future<ResponseModel> getOneFriends({
    bool isLoading = false,
    required String userid,
  }) async {
    debugPrint(
        "[ANTIGRAVITY_DEBUG] DataRepository.getOneFriends called for userid: $userid");
    var result = await connectHelper.getOneFriends(
      isLoading: isLoading,
      userid: userid,
    );
    debugPrint(
        "[ANTIGRAVITY_DEBUG] DataRepository.getOneFriends result: ${result != null}");
    return result;
  }

  Future<ResponseModel> getOneUserStatus({
    required String userid,
    bool isLoading = false,
  }) async =>
      connectHelper.getOneUserStatus(
        userid: userid,
        isLoading: isLoading,
      );

  Future<ResponseModel> getChatLists({
    bool isLoading = false,
    required String userid,
    required String search,
    required int page,
    required int limit,
  }) async =>
      connectHelper.getChatLists(
        isLoading: isLoading,
        userid: userid,
        page: page,
        search: search,
        limit: limit,
      );

  Future<ResponseModel> createPolls({
    bool isLoading = false,
    required String pollid,
    required String polltitle,
    required List<String> optionsList,
    required bool allowmultipleans,
  }) async =>
      connectHelper.createPolls(
        isLoading: isLoading,
        pollid: pollid,
        polltitle: polltitle,
        optionsList: optionsList,
        allowmultipleans: allowmultipleans,
      );

  Future<ResponseModel> getOnePoll({
    bool isLoading = false,
    required String pollid,
  }) async =>
      connectHelper.getOnePoll(
        isLoading: isLoading,
        pollid: pollid,
      );

  Future<ResponseModel> sendMessage({
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
  }) async =>
      connectHelper.sendMessage(
        isLoading: isLoading,
        receiverid: receiverid,
        message: message,
        product: product,
        latitude: latitude,
        longitude: longitude,
        usersList: usersList,
        pollid: pollid,
        context: context,
        mediaFileList: mediaFileList,
        phonecontactData: phonecontactData,
      );

  Future<ResponseModel> myFriendsWithoutPaginationList({
    required String search,
    required bool unreadMessages,
    required bool contactFriend,
    required bool fefieldFriend,
    required bool receiverFriend,
    required bool senderFriend,
    bool isLoading = false,
  }) async =>
      connectHelper.myFriendsWithoutPaginationList(
        isLoading: isLoading,
        search: search,
        unreadMessages: unreadMessages,
        contactFriend: contactFriend,
        fefieldFriend: fefieldFriend,
        receiverFriend: receiverFriend,
        senderFriend: senderFriend,
      );

  Future<ResponseModel> postDeliveredMessage({
    bool isLoading = false,
    required String messageid,
  }) async =>
      connectHelper.postDeliveredMessage(
        isLoading: isLoading,
        messageid: messageid,
      );

  Future<ResponseModel> postSeenMessage({
    bool isLoading = false,
    required String messageid,
  }) async =>
      connectHelper.postSeenMessage(
        isLoading: isLoading,
        messageid: messageid,
      );

  Future<ResponseModel> sendGroupMessage({
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
  }) async =>
      connectHelper.sendGroupMessage(
        isLoading: isLoading,
        receiverid: receiverid,
        message: message,
        product: product,
        latitude: latitude,
        longitude: longitude,
        usersList: usersList,
        pollid: pollid,
        context: context,
        phonecontactData: phonecontactData,
        mediaFileList: mediaFileList,
      );

  Future<ResponseModel> postChatSendBulkMessage({
    required String receiverid,
    String? message,
    String? context,
    List<ImageFormData>? mediaFileList,
    bool isLoading = false,
  }) async =>
      connectHelper.postChatSendBulkMessage(
        isLoading: isLoading,
        receiverid: receiverid,
        message: message,
        context: context,
        mediaFileList: mediaFileList,
      );

  Future<ResponseModel> postGroupChatSendBulkMessage({
    required String receiverid,
    String? message,
    String? context,
    List<ImageFormData>? mediaFileList,
    bool isLoading = false,
  }) async =>
      connectHelper.postGroupChatSendBulkMessage(
        isLoading: isLoading,
        receiverid: receiverid,
        message: message,
        context: context,
        mediaFileList: mediaFileList,
      );

  Future<ResponseModel> getGroupChatLists({
    bool isLoading = false,
    required String groupid,
    required String search,
    required int page,
    required int limit,
  }) async =>
      connectHelper.getGroupChatLists(
        isLoading: isLoading,
        groupid: groupid,
        page: page,
        limit: limit,
        search: search,
      );

  Future<ResponseModel> postGroupDeliveredMessage({
    bool isLoading = false,
    required String messageid,
  }) async =>
      connectHelper.postGroupDeliveredMessage(
        isLoading: isLoading,
        messageid: messageid,
      );

  Future<ResponseModel> postGroupSeenMessage({
    bool isLoading = false,
    required String messageid,
  }) async =>
      connectHelper.postGroupSeenMessage(
        isLoading: isLoading,
        messageid: messageid,
      );

  Future<ResponseModel> postfriendsproducts({
    bool isLoading = false,
    required String search,
    required String userid,
    required String business,
    required List<String> parentcategory,
    required List<String> childcategory,
  }) async =>
      connectHelper.postfriendsproducts(
        search: search,
        userid: userid,
        business: business,
        parentcategory: parentcategory,
        childcategory: childcategory,
        isLoading: isLoading,
      );

  Future<ResponseModel> postChatDeleteMessage({
    bool isLoading = false,
    required String messageid,
    required String deletefor,
  }) async =>
      connectHelper.postChatDeleteMessage(
        messageid: messageid,
        deletefor: deletefor,
        isLoading: isLoading,
      );

  Future<ResponseModel> postChatMessageEdit({
    bool isLoading = false,
    required String messageid,
    required String message,
  }) async =>
      connectHelper.postChatMessageEdit(
        messageid: messageid,
        message: message,
        isLoading: isLoading,
      );

  Future<ResponseModel> postChatBookmarkAndRemove({
    bool isLoading = false,
    required String messageid,
  }) async =>
      connectHelper.postChatBookmarkAndRemove(
        messageid: messageid,
        isLoading: isLoading,
      );

  Future<ResponseModel> postChatFavoriteAndRemove({
    bool isLoading = false,
    required String messageid,
  }) async =>
      connectHelper.postChatFavoriteAndRemove(
        messageid: messageid,
        isLoading: isLoading,
      );

  Future<ResponseModel> postChatMessageReaction({
    bool isLoading = false,
    required String messageid,
    required String reaction,
  }) async =>
      connectHelper.postChatMessageReaction(
        messageid: messageid,
        reaction: reaction,
        isLoading: isLoading,
      );

  Future<ResponseModel> postChatMessageUnReaction({
    bool isLoading = false,
    required String messageid,
  }) async =>
      connectHelper.postChatMessageUnReaction(
        messageid: messageid,
        isLoading: isLoading,
      );

  Future<ResponseModel> postChatGroupDeleteMessage({
    bool isLoading = false,
    required String messageid,
    required String deletefor,
  }) async =>
      connectHelper.postChatGroupDeleteMessage(
        messageid: messageid,
        deletefor: deletefor,
        isLoading: isLoading,
      );

  Future<ResponseModel> postChatGroupMessageEdit({
    bool isLoading = false,
    required String messageid,
    required String message,
  }) async =>
      connectHelper.postChatGroupMessageEdit(
        messageid: messageid,
        message: message,
        isLoading: isLoading,
      );

  Future<ResponseModel> postChatGroupBookmarkRemove({
    bool isLoading = false,
    required String messageid,
  }) async =>
      connectHelper.postChatGroupBookmarkRemove(
        messageid: messageid,
        isLoading: isLoading,
      );

  Future<ResponseModel> postChatGroupFavoriteRemove({
    bool isLoading = false,
    required String messageid,
  }) async =>
      connectHelper.postChatGroupFavoriteRemove(
        messageid: messageid,
        isLoading: isLoading,
      );

  Future<ResponseModel> postChatGroupMessageReaction({
    bool isLoading = false,
    required String messageid,
    required String reaction,
  }) async =>
      connectHelper.postChatGroupMessageReaction(
        messageid: messageid,
        reaction: reaction,
        isLoading: isLoading,
      );

  Future<ResponseModel> postChatGroupMessageUnReaction({
    bool isLoading = false,
    required String messageid,
  }) async =>
      connectHelper.postChatGroupMessageUnReaction(
        messageid: messageid,
        isLoading: isLoading,
      );

  Future<ResponseModel> postChatPinUnPin({
    bool isLoading = false,
    required String userid,
    required bool isPinned,
  }) async =>
      connectHelper.postChatPinUnPin(
        userid: userid,
        isPinned: isPinned,
        isLoading: isLoading,
      );

  Future<ResponseModel> postGroupChatPinUnPin({
    bool isLoading = false,
    required String groupid,
    required bool isPinned,
  }) async =>
      connectHelper.postGroupChatPinUnPin(
        groupid: groupid,
        isPinned: isPinned,
        isLoading: isLoading,
      );
  Future<ResponseModel> postChatForward({
    bool isLoading = false,
    required String messageid,
    required List<String> forwardto,
  }) async =>
      connectHelper.postChatForward(
        isLoading: isLoading,
        messageid: messageid,
        forwardto: forwardto,
      );

  // post call initiate api
  Future<ResponseModel> postCallInitaite({
    bool isLoading = false,
    required String receiverId,
    required bool isVideoCall,
    required bool isAudioCall,
    required bool isGroupCall,
  }) async =>
      connectHelper.postCallInitaite(
        isLoading: isLoading,
        isAudioCall: isAudioCall,
        isGroupCall: isGroupCall,
        isVideoCall: isVideoCall,
        receiverId: receiverId,
      );

  // post call initiate api
  Future<ResponseModel> postCallHistory({
    bool isLoading = false,
    required int page,
    required int limit,
    required String calltype,
  }) async =>
      connectHelper.postCallHistory(
        page: page,
        limit: limit,
        calltype: calltype,
        isLoading: isLoading,
      );

  Future<ResponseModel> postChatLeaveCall({
    bool isLoading = false,
    required String callid,
  }) async =>
      connectHelper.postChatLeaveCall(
        callid: callid,
        isLoading: isLoading,
      );

  Future<ResponseModel> postChatMissedCall({
    bool isLoading = false,
    required String callid,
  }) async =>
      connectHelper.postChatMissedCall(
        callid: callid,
        isLoading: isLoading,
      );

  Future<ResponseModel> postChatJoinCall({
    bool isLoading = false,
    required String callid,
  }) async =>
      connectHelper.postChatJoinCall(
        callid: callid,
        isLoading: isLoading,
      );

  Future<ResponseModel> postHistoryByUser({
    bool isLoading = false,
    required String userid,
  }) async =>
      connectHelper.postHistoryByUser(
        userid: userid,
        isLoading: isLoading,
      );

  Future<ResponseModel> postHistoryByGroup({
    bool isLoading = false,
    required String groupid,
  }) async =>
      connectHelper.postHistoryByGroup(
        groupid: groupid,
        isLoading: isLoading,
      );

  Future<ResponseModel> postListBroadcast({
    bool isLoading = false,
    required int page,
    required int limit,
    required String search,
  }) async =>
      connectHelper.postListBroadcast(
        page: page,
        limit: limit,
        search: search,
        isLoading: isLoading,
      );

  Future<ResponseModel> getOneBroadcast({
    bool isLoading = false,
    required String broadcastid,
  }) async =>
      connectHelper.getOneBroadcast(
        broadcastid: broadcastid,
        isLoading: isLoading,
      );

  Future<ResponseModel> postAddBroadcast({
    bool isLoading = false,
    required String broadcastid,
    required String broadcasttitle,
    required List<String> membersList,
  }) async =>
      connectHelper.postAddBroadcast(
        broadcastid: broadcastid,
        broadcasttitle: broadcasttitle,
        membersList: membersList,
        isLoading: isLoading,
      );

  Future<ResponseModel> postPinUnPinBroadcast({
    bool isLoading = false,
    required String broadcastid,
  }) async =>
      connectHelper.postPinUnPinBroadcast(
        broadcastid: broadcastid,
        isLoading: isLoading,
      );

  Future<ResponseModel> postDeleteBroadcast({
    bool isLoading = false,
    required String broadcastid,
  }) async =>
      connectHelper.postDeleteBroadcast(
        broadcastid: broadcastid,
        isLoading: isLoading,
      );

  Future<ResponseModel> postChatListBroadcast({
    bool isLoading = false,
    required int page,
    required int limit,
    required String broadcastid,
  }) async =>
      connectHelper.postChatListBroadcast(
        page: page,
        limit: limit,
        broadcastid: broadcastid,
        isLoading: isLoading,
      );

  Future<ResponseModel> postSendMessageBroadcast({
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
  }) async =>
      connectHelper.postSendMessageBroadcast(
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

  Future<ResponseModel> postSendMultiMediaBroadcast({
    required String broadcastid,
    String? message,
    String? context,
    List<ImageFormData>? mediaFileList,
    bool isLoading = false,
  }) async =>
      connectHelper.postSendMultiMediaBroadcast(
        broadcastid: broadcastid,
        message: message,
        context: context,
        mediaFileList: mediaFileList,
        isLoading: isLoading,
      );

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
  }) async =>
      connectHelper.postSendFcmApi(
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

  Future<ResponseModel> postOnlineOffline({
    bool isLoading = false,
    required bool isonline,
  }) async =>
      connectHelper.postOnlineOffline(
        isonline: isonline,
        isLoading: isLoading,
      );

  Future<ResponseModel> postPhotoVideo({
    required String userid,
    required int page,
    required int limit,
    bool isLoading = false,
  }) async =>
      connectHelper.postPhotoVideo(
        userid: userid,
        page: page,
        limit: limit,
        isLoading: isLoading,
      );

  Future<ResponseModel> postAudios({
    required String userid,
    required int page,
    required int limit,
    bool isLoading = false,
  }) async =>
      connectHelper.postAudios(
        userid: userid,
        page: page,
        limit: limit,
        isLoading: isLoading,
      );

  Future<ResponseModel> postDocs({
    required String userid,
    required int page,
    required int limit,
    bool isLoading = false,
  }) async =>
      connectHelper.postDocs(
        userid: userid,
        page: page,
        limit: limit,
        isLoading: isLoading,
      );

  Future<ResponseModel> postLinks({
    required String userid,
    required int page,
    required int limit,
    bool isLoading = false,
  }) async =>
      connectHelper.postLinks(
        userid: userid,
        page: page,
        limit: limit,
        isLoading: isLoading,
      );

  Future<ResponseModel> listFavoriteMessage({
    required String userid,
    required int page,
    required int limit,
    bool isLoading = false,
  }) async =>
      connectHelper.listFavoriteMessage(
        userid: userid,
        page: page,
        limit: limit,
        isLoading: isLoading,
      );

  Future<ResponseModel> listGroupFavoriteMessage({
    required String groupid,
    required int page,
    required int limit,
    bool isLoading = false,
  }) async =>
      connectHelper.listGroupFavoriteMessage(
        groupid: groupid,
        page: page,
        limit: limit,
        isLoading: isLoading,
      );

  Future<ResponseModel> listChatBookmarkMessage({
    required int page,
    required int limit,
    bool isLoading = false,
  }) async =>
      connectHelper.listChatBookmarkMessage(
        page: page,
        limit: limit,
        isLoading: isLoading,
      );

  Future<ResponseModel> listGroupBookmarkMessage({
    required int page,
    required int limit,
    bool isLoading = false,
  }) async =>
      connectHelper.listGroupBookmarkMessage(
        page: page,
        limit: limit,
        isLoading: isLoading,
      );

  Future<ResponseModel> postPollVote({
    required String pollid,
    required String optionid,
    bool isLoading = false,
  }) async =>
      connectHelper.postPollVote(
        pollid: pollid,
        optionid: optionid,
        isLoading: isLoading,
      );

  Future<ResponseModel> postSyncContacts({
    required List<Map<String, dynamic>> contactLists,
    bool isLoading = false,
  }) async {
    debugPrint('🔍 Repository: Calling connectHelper.postSyncContacts...');
    final response = await connectHelper.postSyncContacts(
      contactLists: contactLists,
      isLoading: isLoading,
    );
    debugPrint('🔍 Repository: Got response from connectHelper: $response');
    debugPrint('🔍 Repository: response.data = ${response.data}');
    return response;
  }

  Future<ResponseModel> postBrodcastDeleteMeg({
    required String messageid,
    bool isLoading = false,
  }) async =>
      connectHelper.postBrodcastDeleteMeg(
        messageid: messageid,
        isLoading: isLoading,
      );

  Future<ResponseModel> postBrodcastFavorite({
    required String messageid,
    bool isLoading = false,
  }) async =>
      connectHelper.postBrodcastFavorite(
        messageid: messageid,
        isLoading: isLoading,
      );

  Future<ResponseModel> postDeleteCall({
    required String callid,
    bool isLoading = false,
  }) async =>
      connectHelper.postDeleteCall(
        callid: callid,
        isLoading: isLoading,
      );

  Future<ResponseModel> postKickMember({
    required String callid,
    required String memberid,
    bool isLoading = false,
  }) async =>
      connectHelper.postKickMember(
        callid: callid,
        memberid: memberid,
        isLoading: isLoading,
      );

  Future<ResponseModel> postLogout({
    bool isLoading = false,
  }) async =>
      connectHelper.postLogout(
        isLoading: isLoading,
      );

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
  }) async =>
      connectHelper.postSaveMetting(
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

  Future<ResponseModel> postListFavoriteMessages({
    bool isLoading = false,
    required String broadcastid,
    required int page,
    required int limit,
  }) async =>
      connectHelper.postListFavoriteMessages(
        broadcastid: broadcastid,
        page: page,
        limit: limit,
        isLoading: isLoading,
      );

  Future<ResponseModel> postBookmarksList({
    bool isLoading = false,
    required int page,
    required int limit,
  }) async =>
      connectHelper.postBookmarksList(
        page: page,
        limit: limit,
        isLoading: isLoading,
      );

  Future<ResponseModel> postBrodcastPhoto({
    bool isLoading = false,
    required String broadcastid,
    required int page,
    required int limit,
  }) async =>
      connectHelper.postBrodcastPhoto(
        broadcastid: broadcastid,
        page: page,
        limit: limit,
        isLoading: isLoading,
      );

  Future<ResponseModel> postBrodcastAudio({
    bool isLoading = false,
    required String broadcastid,
    required int page,
    required int limit,
  }) async =>
      connectHelper.postBrodcastAudio(
        broadcastid: broadcastid,
        page: page,
        limit: limit,
        isLoading: isLoading,
      );

  Future<ResponseModel> postBrodcastDoc({
    bool isLoading = false,
    required String broadcastid,
    required int page,
    required int limit,
  }) async =>
      connectHelper.postBrodcastDoc(
        broadcastid: broadcastid,
        page: page,
        limit: limit,
        isLoading: isLoading,
      );

  Future<ResponseModel> postBrodcastLink({
    bool isLoading = false,
    required String broadcastid,
    required int page,
    required int limit,
  }) async =>
      connectHelper.postBrodcastLink(
        broadcastid: broadcastid,
        page: page,
        limit: limit,
        isLoading: isLoading,
      );

  Future<ResponseModel> postBrodcastMemberRemove({
    bool isLoading = false,
    required String broadcastid,
    required String memberid,
  }) async =>
      connectHelper.postBrodcastMemberRemove(
        broadcastid: broadcastid,
        memberid: memberid,
        isLoading: isLoading,
      );

  Future<ResponseModel> postMeetingGetOne({
    bool isLoading = false,
    required String meetingid,
  }) async =>
      connectHelper.postMeetingGetOne(
        meetingid: meetingid,
        isLoading: isLoading,
      );

  Future<ResponseModel> postMeetingHostingList({
    bool isLoading = false,
    required int page,
    required int limit,
    required String search,
  }) async =>
      connectHelper.postMeetingHostingList(
        page: page,
        limit: limit,
        search: search,
        isLoading: isLoading,
      );

  Future<ResponseModel> postMeetingJoinList({
    bool isLoading = false,
    required int page,
    required int limit,
    required String search,
  }) async =>
      connectHelper.postMeetingJoinList(
        page: page,
        limit: limit,
        search: search,
        isLoading: isLoading,
      );

  Future<ResponseModel> postMeetingPastList({
    bool isLoading = false,
    required int page,
    required int limit,
    required String search,
  }) async =>
      connectHelper.postMeetingPastList(
        page: page,
        limit: limit,
        search: search,
        isLoading: isLoading,
      );

  Future<ResponseModel> postHostMeetingStart({
    bool isLoading = false,
    required String meetingid,
  }) async =>
      connectHelper.postHostMeetingStart(
        meetingid: meetingid,
        isLoading: isLoading,
      );

  Future<ResponseModel> postMeetingJoin({
    bool isLoading = false,
    required String meetingid,
  }) async =>
      connectHelper.postMeetingJoin(
        meetingid: meetingid,
        isLoading: isLoading,
      );

  Future<ResponseModel> postMeetingLeave({
    bool isLoading = false,
    required String meetingid,
  }) async =>
      connectHelper.postMeetingLeave(
        meetingid: meetingid,
        isLoading: isLoading,
      );

  Future<ResponseModel> postOutgoingCallAddMember({
    bool isLoading = false,
    required String userid,
    required String meetingid,
  }) async =>
      connectHelper.postOutgoingCallAddMember(
        userid: userid,
        meetingid: meetingid,
        isLoading: isLoading,
      );

  Future<ResponseModel> postGroupPhoto({
    bool isLoading = false,
    required String groupid,
    required int page,
    required int limit,
  }) async =>
      connectHelper.postGroupPhoto(
        groupid: groupid,
        page: page,
        limit: limit,
        isLoading: isLoading,
      );

  Future<ResponseModel> postGroupAudio({
    bool isLoading = false,
    required String groupid,
    required int page,
    required int limit,
  }) async =>
      connectHelper.postGroupAudio(
        groupid: groupid,
        page: page,
        limit: limit,
        isLoading: isLoading,
      );

  Future<ResponseModel> postGroupDoc({
    bool isLoading = false,
    required String groupid,
    required int page,
    required int limit,
  }) async =>
      connectHelper.postGroupDoc(
        groupid: groupid,
        page: page,
        limit: limit,
        isLoading: isLoading,
      );

  Future<ResponseModel> postGroupLink({
    bool isLoading = false,
    required String groupid,
    required int page,
    required int limit,
  }) async =>
      connectHelper.postGroupLink(
        groupid: groupid,
        page: page,
        limit: limit,
        isLoading: isLoading,
      );

  Future<ResponseModel> postChatHide({
    bool isLoading = false,
    required List<String> friendrequestids,
  }) async =>
      connectHelper.postChatHide(
        friendrequestids: friendrequestids,
        isLoading: isLoading,
      );

  Future<ResponseModel> postGroupChatHide({
    bool isLoading = false,
    required List<String> groupids,
  }) async =>
      connectHelper.postGroupChatHide(
        groupids: groupids,
        isLoading: isLoading,
      );

  Future<ResponseModel> postChatLock({
    bool isLoading = false,
    required List<String> friendrequestids,
  }) async =>
      connectHelper.postChatLock(
        friendrequestids: friendrequestids,
        isLoading: isLoading,
      );

  Future<ResponseModel> postGroupChatLock({
    bool isLoading = false,
    required List<String> groupids,
  }) async =>
      connectHelper.postGroupChatLock(
        groupids: groupids,
        isLoading: isLoading,
      );

  Future<ResponseModel> postCreatePinLock({
    bool isLoading = false,
    required String pin,
  }) async =>
      connectHelper.postCreatePinLock(
        pin: pin,
        isLoading: isLoading,
      );

  Future<ResponseModel> postVerifyPinLock({
    bool isLoading = false,
    required String pin,
  }) async =>
      connectHelper.postVerifyPinLock(
        pin: pin,
        isLoading: isLoading,
      );

  Future<ResponseModel> postChangePinLock({
    bool isLoading = false,
    required String oldpin,
    required String newpin,
  }) async =>
      connectHelper.postChangePinLock(
        oldpin: oldpin,
        newpin: newpin,
        isLoading: isLoading,
      );

  Future<ResponseModel> postForgotPinLock({
    bool isLoading = false,
  }) async =>
      connectHelper.postForgotPinLock(
        isLoading: isLoading,
      );

  @override
  Future<ResponseModel> postDisableAccount({
    bool isLoading = false,
  }) async =>
      connectHelper.postDisableAccount(
        isLoading: isLoading,
      );

  @override
  Future<ResponseModel> postDeleteAccount({
    bool isLoading = false,
  }) async =>
      connectHelper.postDeleteAccount(
        isLoading: isLoading,
      );

  Future<ResponseModel> postNotificationStatusforChat({
    bool isLoading = false,
  }) async =>
      connectHelper.postNotificationStatusforChat(
        isLoading: isLoading,
      );

  Future<ResponseModel> postNotificationStatusforGroup({
    bool isLoading = false,
  }) async =>
      connectHelper.postNotificationStatusforGroup(
        isLoading: isLoading,
      );

  Future<ResponseModel> postRecoveryEmail({
    bool isLoading = false,
    required String email,
  }) async =>
      connectHelper.postRecoveryEmail(
        isLoading: isLoading,
        email: email,
      );

  Future<ResponseModel> postStorageInfo({
    bool isLoading = false,
  }) async =>
      connectHelper.postStorageInfo(
        isLoading: isLoading,
      );

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
  }) async =>
      connectHelper.postChatLockFriends(
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

  Future<ResponseModel> postGroupChatLockList({
    bool isLoading = false,
    required int page,
    required int limit,
    required String search,
    required bool isunreadmessagefilteronoff,
  }) async =>
      connectHelper.postGroupChatLockList(
        page: page,
        limit: limit,
        search: search,
        isunreadmessagefilteronoff: isunreadmessagefilteronoff,
        isLoading: isLoading,
      );

  Future<ResponseModel> postUnLockChat({
    bool isLoading = false,
    required List<String> friendrequestids,
  }) async =>
      connectHelper.postUnLockChat(
        friendrequestids: friendrequestids,
        isLoading: isLoading,
      );

  Future<ResponseModel> postUnLockGroup({
    bool isLoading = false,
    required List<String> groupids,
  }) async =>
      connectHelper.postUnLockGroup(
        groupids: groupids,
        isLoading: isLoading,
      );

  Future<ResponseModel> postCreatePinHide({
    bool isLoading = false,
    required String pin,
  }) async =>
      connectHelper.postCreatePinHide(
        pin: pin,
        isLoading: isLoading,
      );

  Future<ResponseModel> postVerifyPinHide({
    bool isLoading = false,
    required String pin,
  }) async =>
      connectHelper.postVerifyPinHide(
        pin: pin,
        isLoading: isLoading,
      );

  Future<ResponseModel> postChangePinHide({
    bool isLoading = false,
    required String oldpin,
    required String newpin,
  }) async =>
      connectHelper.postChangePinHide(
        oldpin: oldpin,
        newpin: newpin,
        isLoading: isLoading,
      );

  Future<ResponseModel> postForgotPinHide({
    bool isLoading = false,
  }) async =>
      connectHelper.postForgotPinHide(
        isLoading: isLoading,
      );

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
  }) async =>
      connectHelper.postChatHideFriends(
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

  Future<ResponseModel> postGroupChatHideList({
    bool isLoading = false,
    required int page,
    required int limit,
    required String search,
    required bool isunreadmessagefilteronoff,
  }) async =>
      connectHelper.postGroupChatHideList(
        page: page,
        limit: limit,
        search: search,
        isunreadmessagefilteronoff: isunreadmessagefilteronoff,
        isLoading: isLoading,
      );

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
  }) async =>
      connectHelper.postSaveSubUser(
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

  Future<ResponseModel> postSubUserList({
    bool isLoading = false,
    required int page,
    required int limit,
    required String search,
  }) async =>
      connectHelper.postSubUserList(
        page: page,
        limit: limit,
        search: search,
        isLoading: isLoading,
      );

  Future<ResponseModel> postChangePassword({
    bool isLoading = false,
    required String subuserid,
    required String password,
  }) async =>
      connectHelper.postChangePassword(
        subuserid: subuserid,
        password: password,
        isLoading: isLoading,
      );

  Future<ResponseModel> postUpdateSubUser({
    bool isLoading = false,
    required String subuserid,
  }) async =>
      connectHelper.postUpdateSubUser(
        subuserid: subuserid,
        isLoading: isLoading,
      );

  Future<ResponseModel> postClearChats({
    bool isLoading = false,
  }) async =>
      connectHelper.postClearChats(
        isLoading: isLoading,
      );

  Future<ResponseModel> postReadReceiptsstatus({
    bool isLoading = false,
  }) async =>
      connectHelper.postReadReceiptsstatus(
        isLoading: isLoading,
      );

  Future<ResponseModel> postLastSeenOnlineOfflineStatus({
    bool isLoading = false,
  }) async =>
      connectHelper.postLastSeenOnlineOfflineStatus(
        isLoading: isLoading,
      );

  Future<ResponseModel> postChatLockVerifyOtp({
    bool isLoading = false,
    required int otp,
    required int pin,
  }) async =>
      connectHelper.postChatLockVerifyOtp(
        otp: otp,
        pin: pin,
        isLoading: isLoading,
      );

  Future<ResponseModel> postChatHideVerifyOtp({
    bool isLoading = false,
    required int otp,
    required int pin,
  }) async =>
      connectHelper.postChatHideVerifyOtp(
        otp: otp,
        pin: pin,
        isLoading: isLoading,
      );

  Future<ResponseModel> postChangeNumber({
    bool isLoading = false,
    required String oldmobile,
    required String oldcountry_code,
    required String newmobile,
    required String newcountry_code,
  }) async =>
      connectHelper.postChangeNumber(
        oldmobile: oldmobile,
        oldcountry_code: oldcountry_code,
        newmobile: newmobile,
        newcountry_code: newcountry_code,
        isLoading: isLoading,
      );

  Future<ResponseModel> postChangeNumberVerify({
    bool isLoading = false,
    required String key,
    required String otp,
    required String mobile,
  }) async =>
      connectHelper.postChangeNumberVerify(
        key: key,
        otp: otp,
        mobile: mobile,
        isLoading: isLoading,
      );

  Future<ResponseModel> postClearIndividualChats({
    bool isLoading = false,
    required String userid,
  }) async =>
      connectHelper.postClearIndividualChats(
        userid: userid,
        isLoading: isLoading,
      );
  Future<ResponseModel> postClearGroupChats({
    bool isLoading = false,
    required String groupid,
  }) async =>
      connectHelper.postClearGroupChats(
        groupid: groupid,
        isLoading: isLoading,
      );

  Future<ResponseModel> postArchiveChat({
    bool isLoading = false,
    required List<String> friendrequestids,
  }) async =>
      connectHelper.postArchiveChat(
        friendrequestids: friendrequestids,
        isLoading: isLoading,
      );

  Future<ResponseModel> postArchiveGroupChat({
    bool isLoading = false,
    required List<String> groupids,
  }) async =>
      connectHelper.postArchiveGroupChat(
        groupids: groupids,
        isLoading: isLoading,
      );

  Future<ResponseModel> postArchiveChatList({
    bool isLoading = false,
    required String search,
    required bool unreadMessages,
    required bool contactFriend,
    required bool fefieldFriend,
    required bool receiverFriend,
    required bool senderFriend,
  }) async =>
      connectHelper.postArchiveChatList(
        search: search,
        unreadMessages: unreadMessages,
        contactFriend: contactFriend,
        fefieldFriend: fefieldFriend,
        receiverFriend: receiverFriend,
        senderFriend: senderFriend,
        isLoading: isLoading,
      );

  Future<ResponseModel> postArchiveGroupChatList({
    bool isLoading = false,
    required String search,
    required bool isunreadmessagefilteronoff,
  }) async =>
      connectHelper.postArchiveGroupChatList(
        search: search,
        isunreadmessagefilteronoff: isunreadmessagefilteronoff,
        isLoading: isLoading,
      );

  Future<ResponseModel> postArchiveChatRemove({
    bool isLoading = false,
    required List<String> friendrequestids,
  }) async =>
      connectHelper.postArchiveChatRemove(
        friendrequestids: friendrequestids,
        isLoading: isLoading,
      );

  Future<ResponseModel> postArchiveGroupChatRemove({
    bool isLoading = false,
    required List<String> groupids,
  }) async =>
      connectHelper.postArchiveGroupChatRemove(
        groupids: groupids,
        isLoading: isLoading,
      );

  Future<ResponseModel> postReadChat({
    bool isLoading = false,
    required List<String> friendrequestids,
  }) async =>
      connectHelper.postReadChat(
        friendrequestids: friendrequestids,
        isLoading: isLoading,
      );

  Future<ResponseModel> postUnReadChat({
    bool isLoading = false,
    required List<String> friendrequestids,
  }) async =>
      connectHelper.postUnReadChat(
        friendrequestids: friendrequestids,
        isLoading: isLoading,
      );

  Future<ResponseModel> postReadGroupChat({
    bool isLoading = false,
    required List<String> groupids,
  }) async =>
      connectHelper.postReadGroupChat(
        groupids: groupids,
        isLoading: isLoading,
      );

  Future<ResponseModel> postUnReadGroupChat({
    bool isLoading = false,
    required List<String> groupids,
  }) async =>
      connectHelper.postUnReadGroupChat(
        groupids: groupids,
        isLoading: isLoading,
      );

  Future<ResponseModel> postSubUserLogin({
    bool isLoading = false,
    required String username,
    required String password,
    required String fcmToken,
  }) async =>
      connectHelper.postSubUserLogin(
        username: username,
        password: password,
        fcmToken: fcmToken,
        isLoading: isLoading,
      );

  Future<ResponseModel> postNotificationList({
    bool isLoading = false,
    required int page,
    required int limit,
  }) async =>
      connectHelper.postNotificationList(
        page: page,
        limit: limit,
        isLoading: isLoading,
      );

  Future<ResponseModel> postDeleteNotification({
    bool isLoading = false,
    String? notificationId,
  }) async =>
      connectHelper.postDeleteNotification(
        notificationId: notificationId,
        isLoading: isLoading,
      );

  Future<ResponseModel> postFriendProductGetOne({
    bool isLoading = false,
    required String productid,
  }) async =>
      connectHelper.postFriendProductGetOne(
        productid: productid,
        isLoading: isLoading,
      );

  Future<ResponseModel> postUnFriend({
    bool isLoading = false,
    required String friendrequestid,
  }) async =>
      connectHelper.postUnFriend(
        friendrequestid: friendrequestid,
        isLoading: isLoading,
      );

  Future<ResponseModel> postIndiviualBookmark({
    bool isLoading = false,
    required String userid,
    required int page,
    required int limit,
  }) async =>
      connectHelper.postIndiviualBookmark(
        userid: userid,
        page: page,
        limit: limit,
        isLoading: isLoading,
      );

  Future<ResponseModel> postMoveHideToLock({
    bool isLoading = false,
    required List<String> friendrequestids,
  }) async =>
      connectHelper.postMoveHideToLock(
        friendrequestids: friendrequestids,
        isLoading: isLoading,
      );

  Future<ResponseModel> postMoveHideToLockGroup({
    bool isLoading = false,
    required List<String> groupids,
  }) async =>
      connectHelper.postMoveHideToLockGroup(
        groupids: groupids,
        isLoading: isLoading,
      );

  Future<ResponseModel> postChatReport({
    bool isLoading = false,
    required String reportid,
    required String userid,
    required String reason,
  }) async =>
      connectHelper.postChatReport(
        reportid: reportid,
        userid: userid,
        reason: reason,
        isLoading: isLoading,
      );

  Future<ResponseModel> postChatReportList({
    bool isLoading = false,
    required int page,
    required int limit,
  }) async =>
      connectHelper.postChatReportList(
        page: page,
        limit: limit,
        isLoading: isLoading,
      );

  Future<ResponseModel> postChatReportGetOne({
    bool isLoading = false,
    required String reportid,
  }) async =>
      connectHelper.postChatReportGetOne(
        reportid: reportid,
        isLoading: isLoading,
      );

  Future<ResponseModel> postGroupChatReport({
    bool isLoading = false,
    required String reportid,
    required String groupid,
    required String reason,
  }) async =>
      connectHelper.postGroupChatReport(
        reportid: reportid,
        groupid: groupid,
        reason: reason,
        isLoading: isLoading,
      );

  Future<ResponseModel> postGroupChatReportList({
    bool isLoading = false,
    required int page,
    required int limit,
  }) async =>
      connectHelper.postGroupChatReportList(
        page: page,
        limit: limit,
        isLoading: isLoading,
      );

  Future<ResponseModel> postGroupChatReportGetOne({
    bool isLoading = false,
    required String reportid,
  }) async =>
      connectHelper.postGroupChatReportGetOne(
        reportid: reportid,
        isLoading: isLoading,
      );

  Future<ResponseModel> postMeetingCancle({
    bool isLoading = false,
    required String meetingid,
  }) async =>
      connectHelper.postMeetingCancle(
        meetingid: meetingid,
        isLoading: isLoading,
      );

  Future<ResponseModel> updateFcmToken({
    bool isLoading = false,
    required String fcmToken,
  }) async =>
      connectHelper.updateFcmToken(
        fcmToken: fcmToken,
        isLoading: isLoading,
      );
}
