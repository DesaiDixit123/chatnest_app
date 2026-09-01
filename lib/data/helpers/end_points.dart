class EndPoints {
  static String sendOtpApi = 'register/sendotp';
  static String verifyOtpApi = 'register/verifyotp';

  static String setProfile = 'profile';
  static String setProfilePic = 'profile/profilepic';
  static String updateFcmToken = 'profile/fcmtoken';
  static String getProfile = 'profile';
  static String setBusinessProfile = 'business';
  static String setBusinessProfilePic = 'business/setprofilepic';
  static String uploadBrochure = 'business/brochure';
  static String uploadBusinessPhoto = 'business/photo';
  static String uploadBusinessVideo = 'business/video';
  static String removeBrochure = 'business/removebrochure';
  static String removeBusinessPhoto = 'business/removephoto';
  static String removeBusinessVideo = 'business/removevideo';
  static String getBusinessCategories = 'businesscategories';

  static String postFindFriendsLocation = "friends/map";
  static String postFindFriendsList = "friends/find";
  static String sendNewFriendRequest = "friends/sendrequest";
  static String cancelSentRequest = "friends/cancelrequest";
  static String sentRequestList = "friends/sentrequest";
  static String blockedUserList = "friends/blockedlist";
  static String receivedrRequestList = "friends/receivedrequest";
  static String respondFriendsRequest = "friends/respondrequest";
  static String updateFriendsRequest = "friends/updaterequest";
  static String unblockUser = "friends/unblock";

  static String getBusinessList = "business";
  static String getOneBusiness = "business/getone";
  static String removeBusiness = "business/remove";
  static String productSave = "products/save";
  static String productPhotos = "products/photo";
  static String productVideos = "products/video";
  static String productList = "products";
  static String getOneProduct = "products/getone";
  static String removeProduct = "products/remove";
  static String removeProductPhoto = "products/removephoto";
  static String myFriendsList = "friends/myfriends";
  static String getProductCategory =
      "category/list-user-side-without-pagination";
  static String createGroupApi = "groups/save";
  static String uploadGroupProfile = "groups/profile";
  static String removeGroupProfile = "groups/removeprofile";
  static String groupsChatList = "groups";

  static String getOneGroup = "groups/getone";
  static String groupSetManager = "groups/setmanager";
  static String groupUnSetManager = "groups/unsetmanager";
  static String leaveGroup = "groups/exit";
  static String addMemberGroup = "groups/addmembers";
  static String removeMemberGroup = "groups/removemembers";
  static String groupSetPermission = "groups/setpermission";

  static String sendMessage = "chats/send";
  static String myFriendsWithoutPaginationList = "friends/myfriendslist";
  static String getChatLists = "chats";
  static String getOneFriends = "friends/getone";
  static String postDeliveredMessage = "chats/delivered";
  static String postSeenMessage = "chats/seen";

  static String createPolls = "poll/save";
  static String getOnePoll = "poll/getone";

  static String sendGroupMessage = "groupchats/send";
  static String getGroupChatLists = "groupchats";
  static String postGroupDeliveredMessage = "groupchats/delivered";
  static String postGroupSeenMessage = "groupchats/seen";
  static String postfriendsproducts = "products/friendsproductsall";

  static String postChatDeleteMessage = "chats/remove";
  static String postChatMessageEdit = "chats/edit";
  static String postChatBookmarkRemove = "chats/bookmark";
  static String postChatFavoriteRemove = "chats/favorite";
  static String postChatMessageReaction = "chats/reaction";
  static String postChatMessageUnReaction = "chats/unreaction";
  static String postChatPinUnPin = "chats/pinn";
  static String postChatSendBulkMessage = "chats/sendbulk";
  static String postChatForward = "forward";
  static String postGroupChatPinUnPin = "groups/pinn";
  static String postCallInitaite = "call/initiate";
  static String postCallHistory = "call/history";

  static String postChatGroupDeleteMessage = "groupchats/remove";
  static String postChatGroupMessageEdit = "groupchats/edit";
  static String postChatGroupBookmarkRemove = "groupchats/bookmark";
  static String postChatGroupFavoriteRemove = "groupchats/favorite";
  static String postChatGroupMessageReaction = "groupchats/reaction";
  static String postChatGroupMessageUnReaction = "groupchats/unreaction";
  static String postGroupChatSendBulkMessage = "groupchats/sendbulk";
  static String postChatGroupPinUnPin = "groups/pinn";
  static String postChatLeaveGroup = "groups/exit";

  static String postChatLeaveCall = "call/leavecall";
  static String postChatMissedCall = "call/missedcall";
  static String postChatJoinCall = "call/joincall";
  static String postHistoryByUser = "call/historybyuser";
  static String postHistoryByGroup = "call/historybygroup";
  static String postHistoryByCall = "call/historybycall";
  static String postKickMember = "call/kickmember";

  static String postListBroadcast = "broadcast";
  static String getOneBroadcast = "broadcast/getone";
  static String postAddBroadcast = "broadcast/save";
  static String postPinUnPinBroadcast = "broadcast/pinnunpinn";
  static String postDeleteBroadcast = "broadcast/delete";
  static String postChatListBroadcast = "broadcast/chat";
  static String postSendMessageBroadcast = "broadcast/send";
  static String postSendMultiMediaBroadcast = "broadcast/sendbulk";

  static String postSendFcmApi =
      "https://fcm.googleapis.com/v1/projects/co-chat-36393/messages:send";

  static String postOnlineOffline = "onlineoffline";

  static String postPhotoVideo = "chats/photovideos";
  static String postAudios = "chats/audios";
  static String postDocs = "chats/docs";
  static String postLinks = "chats/links";

  static String listFavoriteMessage = "chats/listfavorite";
  static String listGroupFavoriteMessage = "groupchats/listfavorite";
  static String listChatBookmarkMessage = "bookmarks/individualchat";
  static String listGroupBookmarkMessage = "bookmarks/individualchat";

  static String postPollVote = "poll/vote";
  static String postSyncContacts = "synccontacts";

  static String postBrodcastDeleteMeg = "broadcast/deletemessage";
  static String postBrodcastFavorite = "broadcast/favoritemessage";

  static String postDeleteCall = "call/deletecall";

  static String postLogout = "signout";

  static String postSaveMetting = "meeting";

  static String postListFavoriteMessages = "broadcast/listfavoritemessages";

  static String postBookmarksList = "bookmarks/list";
  static String postBrodcastPhoto = "broadcast/photovideos";
  static String postBrodcastAudio = "broadcast/audios";
  static String postBrodcastDoc = "broadcast/docs";
  static String postBrodcastLink = "broadcast/links";

  static String postBrodcastMemberRemove = "broadcast/removemember";
  static String postMeetingGetOne = "meeting/getone";
  static String postMeetingHostingList = "meeting/iamhosting";
  static String postMeetingJoinList = "meeting/iammember";
  static String postMeetingPastList = "meeting/past";
  static String postHostMeetingStart = "meeting/host";
  static String postMeetingJoin = "meeting/join";
  static String postMeetingLeave = "meeting/leave";
  static String postOutgoingCallAddMember = "meeting/addusertocall";

  static String postGroupPhoto = "groupchats/photovideos";
  static String postGroupAudio = "groupchats/audios";
  static String postGroupDoc = "groupchats/docs";
  static String postGroupLink = "groupchats/links";

  static String postUnLockChat = "friends/switchtonormalchat";
  static String postUnLockGroup = "groups/switchtonormalgroupchat";

  static String postChatHide = "chathide/hidechats";
  static String postGroupChatHide = "chathide/hidegroups";

  static String postChatLock = "chatlock/lockchats";
  static String postGroupChatLock = "chatlock/lockgroups";

  static String postCreatePinLock = "chatlock/createpin";
  static String postVerifyPinLock = "chatlock/verifypin";
  static String postChangePinLock = "chatlock/changepin";
  static String postForgotPinLock = "chatlock/forgetpin";
  static String postChatLockFriends = "chatlock/friends";
  static String postGroupChatLockList = "chatlock/groups";

  static String postCreatePinHide = "chathide/createpin";
  static String postVerifyPinHide = "chathide/verifypin";
  static String postChangePinHide = "chathide/changepin";
  static String postForgotPinHide = "chathide/forgetpin";
  static String postChatHideFriends = "chathide/friends";
  static String postGroupChatHideList = "chathide/groups";

  static String postDisableAccount = "settings/disableaccount";
  static String deleteAccountApi = "profile/delete";
  static String postNotificationStatusforChat =
      "settings/notificationstatusforchat";
  static String postNotificationStatusforGroup =
      "settings/notificationstatusforgroup";
  static String postRecoveryEmail = "settings/recoveryemail";
  static String postStorageInfo = "settings/storageinfo";

  static String postSaveSubUser = "settings/savesubuser";
  static String postChangePassword = "settings/changepasssubuser";
  static String postSubUserList = "settings/subuser";
  static String postUpdateSubUser = "settings/onoffsubuser";

  static String postClearChats = "settings/clearchats";
  static String postReadReceiptsstatus = "settings/readreceiptsstatus";
  static String postLastSeenOnlineOfflineStatus =
      "settings/lastseenonlineofflinestatus";

  static String postChatLockVerifyOtp = "chatlock/verifyotpsetpin";
  static String postChatHideVerifyOtp = "chathide/verifyotpsetpin";

  static String postChangeNumber = "register/changenumber";
  static String postChangeNumberVerify = "register/verifyotpfornewnumber";

  static String postClearIndividualChats = "chats/clear";
  static String postClearGroupChats = "groupchats/clear";

  static String postArchiveChat = "archive/archivechats";
  static String postArchiveGroupChat = "archive/archivegroups";
  static String postArchiveChatList = "archive/listfriends";
  static String postArchiveGroupChatList = "archive/listgroups";

  static String postArchiveChatRemove = "archive/removechats";
  static String postArchiveGroupChatRemove = "archive/removegroups";

  static String postReadChat = "markas/readchats";
  static String postUnReadChat = "markas/unreadchats";

  static String postReadGroupChat = "markas/readgroups";
  static String postUnReadGroupChat = "markas/unreadgroups";

  // Subuser login
  static String postSubUserLogin = "register/loginsubuser";
  static String postNotificationList = "usernotifications";
  static String postDeleteNotification = "usernotifications/delete";

  static String postFriendProductGetOne = "products/friendsproductgetone";

  // New Api Addded
  static String postUnFriend = "friends/unfriend";
  static String postIndiviualBookmark = "chats/listbookmark";
  static String postMoveHideToLock = "friends/movehidetolock";
  static String postMoveHideToLockGroup = "groups/movehidetolock";

  static String postChatReport = "friends/report";
  static String postChatReportList = "friends/reportlist";
  static String postChatReportGetOne = "friends/getreport";

  static String postGroupChatReport = "groups/report";
  static String postGroupChatReportList = "groups/reportlist";
  static String postGroupChatReportGetOne = "groups/getreport";

  static String postMeetingCancle = "meeting/cancel";
  static String postGroupListWithoutPaging = "groups/list";
  static String getUserStatus = 'status/getuserstatus';
}
