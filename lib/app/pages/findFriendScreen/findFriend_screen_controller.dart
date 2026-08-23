import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_map_markers/custom_map_markers.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/data/helpers/api_wrapper.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_cluster_manager_2/google_maps_cluster_manager_2.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'
    hide ClusterManager, Cluster;
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class FindFriendController extends GetxController {
  FindFriendController(this.findFriendPresenter);

  final FindFriendPresenter findFriendPresenter;

  @override
  void onInit() {
    getCurrentPosition();
    pagingController.addPageRequestListener((pageKey) async {
      await postFindFriendsList(pageKey, "");
    });
    clusterManager = _initClusterManager();
    super.onInit();
  }

  List<MarkerData> customMarkers = [];
  TextEditingController findfriendController = TextEditingController();
  TextEditingController findfriendhistoryController = TextEditingController();
  GlobalKey<FormState> sendRequestKey = GlobalKey<FormState>();
  TextEditingController messageController = TextEditingController();
  FocusNode messageFocusNode = FocusNode();

  requestDialog(FindFirendsDatum data) async {
    return Get.dialog(SentRequestDialog(
      formKey: sendRequestKey,
      title: data.nickname,
      textEditingController: messageController,
      onTap: () {
        if (sendRequestKey.currentState!.validate()) {
          Get.back();
          sendNewFriendRequest(data.id, messageController.text);
        }
      },
    ));
  }

  permissionDialog(FindFirendsDatum data) async {
    return Get.dialog(
      StatefulBuilder(builder: (context, setState) {
        return Padding(
          padding: Dimens.edgeInsetsTop20,
          child: SingleChildScrollView(
            child: Material(
              color: ColorsValue.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: Dimens.edgeInsets20_0_20_0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: ColorsValue.white,
                        borderRadius: BorderRadius.circular(Dimens.five),
                      ),
                      child: Padding(
                        padding: Dimens.edgeInsets20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'access_permission'.tr,
                                  style: Styles.black70016,
                                ),
                                SizedBox(
                                  height: Dimens.fifteen,
                                  width: Dimens.fifteen,
                                  child: InkWell(
                                    onTap: () {
                                      Get.back();
                                    },
                                    child: SvgPicture.asset(
                                      AssetConstants.cancleicon,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Dimens.boxHeight10,
                            ListTile(
                              contentPadding: Dimens.edgeInsets0,
                              title: Text(
                                'fullname'.tr,
                                style: Styles.black50014,
                              ),
                              leading:
                                  SvgPicture.asset(AssetConstants.fullnameicon),
                              trailing: Transform.scale(
                                scale: 0.8,
                                child: CupertinoSwitch(
                                  value:
                                      authorizedPermissions.fullname ?? false,
                                  activeColor: ColorsValue.maincolor1,
                                  onChanged: (value) {
                                    authorizedPermissions.fullname = value;
                                    setState(() {});
                                  },
                                ),
                              ),
                            ),
                            ListTile(
                              contentPadding: Dimens.edgeInsets0,
                              title: Text(
                                'phone_number'.tr,
                                style: Styles.black50014,
                              ),
                              leading:
                                  SvgPicture.asset(AssetConstants.callicon),
                              trailing: Transform.scale(
                                scale: 0.8,
                                child: CupertinoSwitch(
                                  value: authorizedPermissions.mobile ?? false,
                                  activeColor: ColorsValue.maincolor1,
                                  onChanged: (value) {
                                    authorizedPermissions.mobile = value;
                                    setState(() {});
                                  },
                                ),
                              ),
                            ),
                            ListTile(
                              contentPadding: Dimens.edgeInsets0,
                              title: Text(
                                'email'.tr,
                                style: Styles.black50014,
                              ),
                              leading: SvgPicture.asset(AssetConstants.smsicon),
                              trailing: Transform.scale(
                                scale: 0.8,
                                child: CupertinoSwitch(
                                  value: authorizedPermissions.email ?? false,
                                  activeColor: ColorsValue.maincolor1,
                                  onChanged: (value) {
                                    authorizedPermissions.email = value;
                                    setState(() {});
                                  },
                                ),
                              ),
                            ),
                            ListTile(
                              contentPadding: Dimens.edgeInsets0,
                              title: Text(
                                'date_of_birth'.tr,
                                style: Styles.black50014,
                              ),
                              leading: SvgPicture.asset(AssetConstants.dobicon),
                              trailing: Transform.scale(
                                scale: 0.8,
                                child: CupertinoSwitch(
                                  value: authorizedPermissions.dob ?? false,
                                  activeColor: ColorsValue.maincolor1,
                                  onChanged: (value) {
                                    authorizedPermissions.dob = value;
                                    setState(() {});
                                  },
                                ),
                              ),
                            ),
                            ListTile(
                              contentPadding: Dimens.edgeInsets0,
                              title: Text(
                                'gender'.tr,
                                style: Styles.black50014,
                              ),
                              leading:
                                  SvgPicture.asset(AssetConstants.gendericon),
                              trailing: Transform.scale(
                                scale: 0.8,
                                child: CupertinoSwitch(
                                  value: authorizedPermissions.gender ?? false,
                                  activeColor: ColorsValue.maincolor1,
                                  onChanged: (value) {
                                    authorizedPermissions.gender = value;
                                    setState(() {});
                                  },
                                ),
                              ),
                            ),
                            ListTile(
                              contentPadding: Dimens.edgeInsets0,
                              title: Text(
                                'social_media'.tr,
                                style: Styles.black50014,
                              ),
                              leading: SvgPicture.asset(
                                  AssetConstants.socialmediaicon),
                              trailing: Transform.scale(
                                scale: 0.8,
                                child: CupertinoSwitch(
                                  value: authorizedPermissions.socialmedia ??
                                      false,
                                  activeColor: ColorsValue.maincolor1,
                                  onChanged: (value) {
                                    authorizedPermissions.socialmedia = value;
                                    setState(() {});
                                  },
                                ),
                              ),
                            ),
                            ListTile(
                              contentPadding: Dimens.edgeInsets0,
                              title: Text(
                                'video_call'.tr,
                                style: Styles.black50014,
                              ),
                              leading:
                                  SvgPicture.asset(AssetConstants.videoIcon),
                              trailing: Transform.scale(
                                scale: 0.8,
                                child: CupertinoSwitch(
                                  value:
                                      authorizedPermissions.videocall ?? false,
                                  activeColor: ColorsValue.maincolor1,
                                  onChanged: (value) {
                                    authorizedPermissions.videocall = value;
                                    setState(() {});
                                  },
                                ),
                              ),
                            ),
                            ListTile(
                              contentPadding: Dimens.edgeInsets0,
                              title: Text(
                                'audio_call'.tr,
                                style: Styles.black50014,
                              ),
                              leading:
                                  SvgPicture.asset(AssetConstants.callicon),
                              trailing: Transform.scale(
                                scale: 0.8,
                                child: CupertinoSwitch(
                                  value:
                                      authorizedPermissions.audiocall ?? false,
                                  activeColor: ColorsValue.maincolor1,
                                  onChanged: (value) {
                                    authorizedPermissions.audiocall = value;
                                    setState(() {});
                                  },
                                ),
                              ),
                            ),
                            ListTile(
                              contentPadding: Dimens.edgeInsets0,
                              title: Text(
                                'mute_notification'.tr,
                                style: Styles.black50014,
                              ),
                              leading:
                                  SvgPicture.asset(AssetConstants.ic_mute_noti),
                              trailing: Transform.scale(
                                scale: 0.8,
                                child: CupertinoSwitch(
                                  value: authorizedPermissions.ismute ?? false,
                                  activeColor: ColorsValue.maincolor1,
                                  onChanged: (value) {
                                    authorizedPermissions.ismute = value;
                                    setState(() {});
                                  },
                                ),
                              ),
                            ),
                            Dimens.boxHeight10,
                            CustomButton(
                              height: Dimens.fourty,
                              text: "send_request".tr.toUpperCase(),
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Future<void> postFindFriendsLocation({
    bool isLoading = true,
  }) async {
    var response = await findFriendPresenter.postFindFriendsLocation(
      latitude: selectedLocationLatLag?.latitude ?? 21.17024,
      longitude: selectedLocationLatLag?.longitude ?? 72.831062,
    );
    placeList.clear();
    imageList.clear();
    if (response != null) {
      findfriendController.clear();
      for (var data in response.data) {
        placeList.add(
          PlaceModel(
              name: data.fullname,
              latLng: LatLng(
                  data.location.coordinates[1], data.location.coordinates[0]),
              type: 1,
              id: Random().nextInt(1) + 1,
              findFirendsDatum: data),
        );
        imageList.add(data.profileimage);
      }
    }
    update();
  }

  Future<void> sendNewFriendRequest(String receiverid, String message) async {
    var response = await findFriendPresenter.sendNewFriendRequest(
      receiverid: receiverid,
      message: message,
      product: "",
      authorizedPermissions: authorizedPermissions,
    );
    if (response != null) {
      messageController.clear();
      pagingController.refresh();
      Utility.snacBar(response.message ?? "", ColorsValue.appColor);
    } else {
      messageController.clear();
      pagingController.refresh();
      // Utility.errorMessage(response?.message ?? "");
    }
    update();
  }

  Future<void> respondFriendsRequest(String friendrequestid, status) async {
    var response = await findFriendPresenter.respondFriendsRequest(
      friendrequestid: friendrequestid,
      status: status,
      authorizedPermissions: AuthorizedPermissions(
        fullname: authorizedPermissions.fullname,
        mobile: authorizedPermissions.mobile,
        email: authorizedPermissions.email,
        dob: authorizedPermissions.dob,
        gender: authorizedPermissions.gender,
        socialmedia: authorizedPermissions.socialmedia,
        videocall: authorizedPermissions.videocall,
        audiocall: authorizedPermissions.audiocall,
        ismute: authorizedPermissions.ismute,
      ),
      isLoading: true,
    );
    if (response!.statusCode == 200) {
      pagingController.refresh();
    }
    update();
  }

  /// ----------------------- request history Screen ---------------------------///

  bool sendrequastcheakbox = false;
  bool fffildFriend = false;
  bool isalreadyPin = false;
  TextEditingController hidechatPincontroller = TextEditingController();
  GlobalKey<FormState> hidechatpinFormKey = GlobalKey<FormState>();

  String? validpin(String value) {
    if (value.isEmpty) {
      return "pleaseentertpin".tr;
    } else if (value.length != 4) {
      return "pleaseenterrightpin".tr;
    } else {
      return null;
    }
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

  Future<void> updateFriendsRequest(String friendrequestid, status) async {
    var response = await findFriendPresenter.updateFriendsRequest(
      friendrequestid: friendrequestid,
      status: status,
      authorizedPermissions: authorizedPermissions,
      isLoading: true,
    );
    if (response!.statusCode == 200) {
      pagingController.refresh();
    }
    update();
  }

  ///--------------------------- Request History Screen ----------------------------- ///

  PagingController<int, FindFirendsListDoc> pagingController =
      PagingController(firstPageKey: 1);

  List<FindFirendsListDoc> findFirendsListModel = [];
  List<PlaceModel> placeList = [];
  List<String> imageList = [];

  int limit = 10;

  Future<void> postFindFriendsList(int pageKey, search) async {
    var response = await findFriendPresenter.postFindFriendsList(
      page: pageKey,
      limit: limit,
      search: findfriendhistoryController.text,
      isLoading: false,
    );
    if (response != null) {
      if (pageKey == 1) {
        findFirendsListModel.clear();
      }
      findFirendsListModel = response.data.docs;

      final isLastPage = findFirendsListModel.length < limit;
      if (isLastPage) {
        pagingController.appendLastPage(findFirendsListModel);
      } else {
        var nextPageKey = pageKey + 1;
        pagingController.appendPage(findFirendsListModel, nextPageKey);
      }
      update();
    }
  }

  Future<void> cancelSentRequest(String friendrequestid) async {
    var response = await findFriendPresenter.cancelSentRequest(
      friendrequestid: friendrequestid,
      isLoading: true,
    );
    if (response!.statusCode == 200) {
      Utility.snacBar(
          "Friend request cancle successfully...", ColorsValue.maincolor1);
      pagingController.refresh();
    }
    update();
  }

  LatLng? selectedLocationLatLag;
  final Set<Marker> markers = {};
  final Completer<GoogleMapController> mapController = Completer();

  void onMapCreated(GoogleMapController controller) {
    if (!mapController.isCompleted) {
      mapController.complete(controller);
    }
  }

  Future<void> getCurrentPosition() async {
    // Location fetching is intentionally disabled.
    return;
    // await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
    //     .then((Position position) {
    //   currentPosition = position;
    //   selectedLocationLatLag =
    //       LatLng(currentPosition!.latitude, currentPosition!.longitude);
    //   moveToLocation(selectedLocationLatLag!);

    //   update();
    // }).catchError((e) {
    //   debugPrint(e);
    // });
  }

  void moveToLocation(LatLng latLng) {
    mapController.future.then((controller) {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: latLng,
            zoom: 15.0,
          ),
        ),
      );
    });
    setMarker(latLng);

    // getLocationData(
    //     lat: latLng.latitude, lng: latLng.longitude, isForNavigator: false);
  }

  void setMarker(LatLng latLng) {
    markers.clear();
    markers.add(
      Marker(
        markerId: const MarkerId("mark"),
        position: latLng,
      ),
    );
    update();
  }

  ////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////
  /// ------------------------------ Find Friends Screen ----------------------------- ///

  Set<Marker> mapMarkers = {};
  late Completer<GoogleMapController> googleMapController =
      Completer<GoogleMapController>();
  late ClusterManager clusterManager;
  late BitmapDescriptor customIcon;
  String url = "";

  late CameraPosition initialCameraPosition = CameraPosition(
    target: selectedLocationLatLag ?? const LatLng(21.170240, 72.831062),
    zoom: 5,
  );

  ClusterManager _initClusterManager() {
    return ClusterManager<PlaceModel>(
      placeList,
      _updateMarkers,
      markerBuilder: markerBuilder,
    );
  }

  void _updateMarkers(Set<Marker> markers) {
    mapMarkers = markers;
    update();
  }

  Future<Marker> Function(Cluster<PlaceModel>) get markerBuilder =>
      (cluster) async {
        return Marker(
          onTap: () {
            if (cluster.items.length == 1) {
              requestDialog(cluster.items.single.findFirendsDatum!);
            } else {
              Get.dialog(
                Padding(
                  padding: Dimens.edgeInsets20,
                  child: Center(
                    child: SingleChildScrollView(
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              Dimens.twenty,
                            ),
                          ),
                          child: Material(
                            color: ColorsValue.transparent,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Align(
                                  alignment: Alignment.topRight,
                                  child: InkWell(
                                    onTap: () {
                                      Get.back();
                                    },
                                    child: Padding(
                                      padding: Dimens.edgeInsets20_20_20_10,
                                      child: SvgPicture.asset(
                                        AssetConstants.cancleicon,
                                        colorFilter: const ColorFilter.mode(
                                          ColorsValue.maincolor1,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: cluster.items.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        Get.back();
                                        requestDialog(cluster.items
                                            .toList()[index]
                                            .findFirendsDatum!);
                                      },
                                      child: Padding(
                                        padding: Dimens.edgeInsets10,
                                        child: ListTile(
                                          contentPadding: Dimens.edgeInsets0,
                                          leading: Container(
                                            height: Dimens.fifty,
                                            width: Dimens.fifty,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                Dimens.hundred,
                                              ),
                                              color: ColorsValue.maincolor1,
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimens.hundred),
                                              child: CachedNetworkImage(
                                                imageUrl: ApiWrapper.imageUrl +
                                                    (cluster.items
                                                            .toList()[index]
                                                            .findFirendsDatum
                                                            ?.profileimage ??
                                                        ""),
                                                fit: BoxFit.cover,
                                                maxHeightDiskCache: 90,
                                                maxWidthDiskCache: 90,
                                                width: Dimens.fifty,
                                                height: Dimens.fifty,
                                                placeholder: (context, url) =>
                                                    Image.asset(
                                                  AssetConstants.usera,
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Image.asset(
                                                  AssetConstants.usera,
                                                ),
                                              ),
                                            ),
                                          ),
                                          title: Text(
                                            cluster.items
                                                    .toList()[index]
                                                    .findFirendsDatum
                                                    ?.fullname ??
                                                "",
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
          },
          markerId: MarkerId(cluster.isMultiple
              ? cluster.getId()
              : cluster.items.single.id.toString()),
          position: cluster.location,
          icon: cluster.isMultiple
              ? await getMarkerBitmap(
                  150,
                  150,
                  cluster.items.where((element) => element.type == 0).length,
                  cluster.items.where((element) => element.type == 1).length,
                  text: cluster.count.toString())
              : cluster.items.length == 1
                  ? cluster.items.single.findFirendsDatum?.profileimage
                              .isEmpty ??
                          false
                      ? await getAssetMarkerIcon(
                          'assets/images/ic_user_80.png', 180)
                      : await getMarkerIcon(
                          cluster.items.single.findFirendsDatum?.profileimage ??
                              "",
                          const Size(
                            200,
                            200,
                          ),
                        )
                  : await getAssetMarkerIcon(
                      'assets/images/ic_user_80.png', 50.0),
        );
      };

  Future<ui.Image> profile(img) async {
    File? markerImageFile;
    markerImageFile =
        await DefaultCacheManager().getSingleFile(ApiWrapper.imageUrl + img);

    final Uint8List markerImageBytes = await markerImageFile.readAsBytes();
    final Completer<ui.Image> completer = Completer();

    ui.decodeImageFromList(markerImageBytes, (ui.Image img) {
      return completer.complete(img);
    });

    return completer.future;
  }

  Future<BitmapDescriptor> getAssetMarkerIcon(
      String assetPath, double size) async {
    final ByteData byteData = await rootBundle.load(assetPath);
    final Uint8List imageData = byteData.buffer.asUint8List();
    final ui.Codec markerImageCodec =
        await instantiateImageCodec(imageData, targetWidth: size.toInt());
    final FrameInfo frameInfo = await markerImageCodec.getNextFrame();
    final ByteData? resizedByteData =
        await frameInfo.image.toByteData(format: ImageByteFormat.png);
    final Uint8List resizedImageData = resizedByteData!.buffer.asUint8List();
    return BitmapDescriptor.fromBytes(resizedImageData);
  }

  Future<BitmapDescriptor> getMarkerBitmap(
      int size, double size2, int typeZeroLength, int typeOneLength,
      {String? text}) async {
    if (kIsWeb) size = (size / 2).floor();

    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint1 = Paint()..color = const Color(0xFF4051B5);
    final Paint paint2 = Paint()..color = Colors.white;
    final Paint paint3 = Paint()..color = Colors.red;

    double degreesToRads(num deg) {
      return (deg * 3.14) / 180.0;
    }

    int total = typeZeroLength + typeOneLength;
    var totalRatio = 2.09439666667 * 3;
    double percentageOfLength = (typeZeroLength / total);
    var resultRatio = totalRatio * percentageOfLength;

    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, paint1);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 2.8, paint1);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 3.8, paint3);
    canvas.drawArc(const Offset(0, 0) & Size(size2, size2), degreesToRads(90.0),
        resultRatio, true, paint3);
    canvas.drawCircle(Offset(size / 2, size / 2), size / 3.2, paint2);
    if (text != null) {
      TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
      painter.text = TextSpan(
        text: text,
        style: TextStyle(
            fontSize: size / 3,
            color: Colors.black,
            fontWeight: FontWeight.normal),
      );
      painter.layout();
      painter.paint(
        canvas,
        Offset(size / 2 - painter.width / 2, size / 2 - painter.height / 2),
      );
    }
    final img = await pictureRecorder.endRecording().toImage(size, size);
    final data = await img.toByteData(format: ImageByteFormat.png) as ByteData;
    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }

  Future<BitmapDescriptor> getMarkerIcon(String imagePath, Size size) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    final Radius radius = Radius.circular(size.width / 2);

    final Paint tagPaint = Paint()..color = Colors.blue;
    const double tagWidth = 40.0;

    final Paint shadowPaint = Paint()..color = Colors.blue.withAlpha(100);
    const double shadowWidth = 15.0;

    final Paint borderPaint = Paint()..color = Colors.white;
    const double borderWidth = 3.0;

    const double imageOffset = shadowWidth + borderWidth;

    // Add tag circle
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(size.width, 0.0, tagWidth, tagWidth),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        tagPaint);

    // Oval for the image
    Rect oval = Rect.fromLTWH(imageOffset, imageOffset,
        size.width - (imageOffset * 2), size.height - (imageOffset * 2));

    // Add path for oval image
    canvas.clipPath(Path()..addOval(oval));

    // Add image
    ui.Image image = await profile(imagePath);
    paintImage(canvas: canvas, image: image, rect: oval, fit: BoxFit.cover);

    // Convert canvas to image
    final ui.Image markerAsImage = await pictureRecorder
        .endRecording()
        .toImage(size.width.toInt(), size.height.toInt());

    // Convert image to bytes
    final ByteData? byteData =
        await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List uint8List = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(uint8List);
  }
}

class PlaceModel with ClusterItem {
  int? id;
  int? type;
  String? name;
  final LatLng latLng;
  FindFirendsDatum? findFirendsDatum;

  PlaceModel(
      {required this.name,
      required this.latLng,
      required this.type,
      required this.findFirendsDatum,
      required this.id});
  @override
  LatLng get location => latLng;
}
