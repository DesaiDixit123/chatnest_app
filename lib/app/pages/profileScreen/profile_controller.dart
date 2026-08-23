import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:chatnest/data/data.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:http/http.dart' as http;

class ProfileController extends GetxController
    with GetSingleTickerProviderStateMixin {
  ProfileController(this.profilePresenter);

  final ProfilePresenter profilePresenter;

  late TabController profileTabController;

  @override
  void onInit() async {
    super.onInit();
    profileTabController = TabController(vsync: this, length: 2);
    profileTabController.addListener(update);
  }

  ///------------------------- Create profile Screen -----------------------///

  final GlobalKey<FormState> createprofileFormKey = GlobalKey<FormState>();
  final Set<Marker> markers = Set();
  GoogleMapController? mapcontroller;
  LatLng? profileLatLag;
  DateTime selectedDate = DateTime.now();
  TextEditingController firestNameController = TextEditingController(),
      nickNameController = TextEditingController(),
      emailController = TextEditingController(),
      hashtagcontroller = TextEditingController(),
      timecontroller = TextEditingController(),
      aboutmeController = TextEditingController(),
      genderController = TextEditingController();
  List<ProfileDetail> personalProfileView = [];
  List<ProfileDetail> businessProfileView = [];

  String? selectGender = 'Male';

  var genderList = [
    'Male',
    'Female',
    'Transgender',
  ];
  static const CameraPosition cameraPosition = CameraPosition(
    target: LatLng(1.35, 103.8),
    zoom: 12.0,
  );
  RangeValues values = RangeValues(18.0, 70);

  int interestedindex = 1;
  double startValue = 18;
  double endValue = 30;

  String? validname(String value) {
    if (value.isEmpty) {
      return "please_enter_first_name".tr;
    }
    return null;
  }

  String? validnickname(String value) {
    if (value.isEmpty) {
      return "please_enter_nick_name".tr;
    }
    return null;
  }

  String? validEmail(String value) {
    if (value.isEmpty) {
      return "please_enter_emailId".tr;
    } else if (!Utility.emailValidator(value)) {
      return "please_enter_valid_emailId".tr;
    }
    return null;
  }

  String? validdateofbirth(String value) {
    if (value.isEmpty) {
      return "please_enter_dob".tr;
    }
    return null;
  }

  String? validaboutme(String value) {
    if (value.isEmpty) {
      return "please_enter_about".tr;
    }
    return null;
  }

  int currentStep = 1;
  int index = 0;

  List<Socialmedialink> addItemList = [];

  List<Socialmedialink> socialMediaList = [
    Socialmedialink(
      icon: AssetConstants.facebookimage,
      size: Dimens.fourty,
      platform: "Facebook",
      url: "",
      hintText: 'Enter Facebook Link',
      textEditingController: TextEditingController(),
    ),
    Socialmedialink(
      icon: AssetConstants.instagramimage,
      size: Dimens.fourty,
      platform: "Instagram",
      url: "",
      hintText: 'Enter Instagram Link',
      textEditingController: TextEditingController(),
    ),
    Socialmedialink(
      icon: AssetConstants.ximage,
      size: Dimens.fourty,
      platform: "X",
      url: "",
      hintText: 'Enter X Link',
      textEditingController: TextEditingController(),
    ),
    Socialmedialink(
      icon: AssetConstants.printrestimage,
      size: Dimens.fourty,
      platform: "Pinterest",
      url: "",
      hintText: 'Enter Pinterest Link',
      textEditingController: TextEditingController(),
    ),
    Socialmedialink(
      icon: AssetConstants.linkedinimage,
      size: Dimens.fourty,
      platform: "Linkedin",
      url: "",
      hintText: 'Enter Linkedin Link',
      textEditingController: TextEditingController(),
    ),
    Socialmedialink(
      icon: AssetConstants.youtubeimage,
      size: Dimens.fourty,
      platform: "Youtube",
      url: "",
      hintText: 'Enter Youtube Link',
      textEditingController: TextEditingController(),
    ),
  ];

  void onMapCreate(GoogleMapController controller) {
    mapcontroller = controller;
  }

  final pickerProfile = ImagePicker();
  List<String> hobbiesList = [];
  File? imageFile;
  var profileImage;
  LatLng? latLog = const LatLng(21.170240, 72.831062);

  Future setProfilePic() async {
    final pickedFile =
        await pickerProfile.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (Utility.getImageSizeMB(pickedFile.path) <= 16) {
        imageFile = File(pickedFile.path);
        profileImage = await profilePresenter.setProfilePic(
            filePath: imageFile?.path ?? "");
      } else {
        Utility.errorMessage("max_16_mb_img".tr);
      }
    }
    update();
  }

  Future<bool> setProfile({
    bool isLoading = true,
  }) async {
    nickNameController.text = firestNameController.text;
    var respons = await profilePresenter.setProfile(
      isLoading: true,
      profileimage: profileImage ?? "",
      fullname: firestNameController.text,
      nickname: nickNameController.text,
      email: emailController.text,
      dob: timecontroller.text,
      hashtag: hashtagcontroller.text,
      gender: selectGender ?? "Male",
      aboutme: aboutmeController.text,
      hobbies: hobbiesList,
      latitude: profileLatLag!.latitude,
      longitude: profileLatLag!.longitude,
      interestedin: interestedindex == 1
          ? "Male"
          : interestedindex == 2
              ? "Female"
              : "transgender",
      interestedagerangemin: startValue == 0.0 ? 18 : startValue.toInt(),
      interestedagerangemax: endValue == 0.0 ? 70 : endValue.toInt(),
      socialmedialinks: socialMediaList
          .map((e) => Socialmedialink(platform: e.platform, url: e.url))
          .toList(),
    );
    if (respons?.statusCode == 200) {
      Get.find<HomeScreenController>().getProfile();
      return true;
    } else {
      Utility.errorMessage(jsonDecode(respons?.data ?? "")["Message"]);
      return false;
    }
  }

  ProfileData? profileData = ProfileData();
  String locationText = "";

  Future<void> getProfile({
    bool isLoading = false,
  }) async {
    var response = await profilePresenter.getProfile(
      isLoading: isLoading,
    );
    hobbiesList.clear();
    if (response != null) {
      profileData = response.data!;
      profileImage = response.data?.profileimage ?? "";
      firestNameController.text = response.data?.fullname ?? "";
      nickNameController.text = response.data?.nickname ?? "";
      emailController.text = response.data?.email ?? "";
      timecontroller.text = response.data?.dob ?? "";
      // hashtagcontroller.text = response.data?.hashtag ?? "";
      selectGender =
          response.data!.gender!.isEmpty ? "Male" : response.data?.gender;
      aboutmeController.text = response.data?.aboutme ?? "";
      hobbiesList.addAll(response.data?.hobbies ?? []);
      latLog = LatLng(response.data?.location?.coordinates[1] ?? 21.170240,
          response.data?.location?.coordinates[0] ?? 72.831062);
      profileLatLag = LatLng(
          response.data?.location?.coordinates[1] ?? 21.170240,
          response.data?.location?.coordinates[0] ?? 72.831062);
      interestedindex = response.data?.interestedin == "Male"
          ? 1
          : response.data?.interestedin == "Female"
              ? 2
              : 3;
      startValue = response.data?.interestedagerangemin?.toDouble() ?? 18.0;
      endValue = response.data?.interestedagerangemax?.toDouble() ?? 30.0;
      for (var data in response.data?.socialmedialinks ?? <Socialmedialink>[]) {
        int index = socialMediaList
            .indexWhere((element) => element.platform == data.platform);
        if (!index.isNegative) {
          socialMediaList[index].url = data.url;
          socialMediaList[index].textEditingController?.text = data.url;
        }
      }

      locationText = await getLocation(response.data!.location!.coordinates[1],
          response.data!.location!.coordinates[0]);

      update();
    }
  }

  // Future<String> getLocation(double lat, double log) async {
  //   var response = await http.get(Uri.parse(
  //       "https://maps.googleapis.com/maps/api/geocode/json?latlng=${lat},${log}&key=${ApiWrapper.placeApiCall}"));
  //   var responseModel;
  //   if (response.statusCode == 200) {
  //     responseModel = addressModelFromJson(response.body);
  //   }
  //   return responseModel.results?[0].formattedAddress ?? "";
  // }

  Future<String> getLocation(double lat, double log) async {
    var response = await http.get(Uri.parse(
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${lat},${log}&key=${ApiWrapper.placeApiCall}"));

    if (response.statusCode == 200) {
      var responseModel = addressModelFromJson(response.body);

      if (responseModel.results != null && responseModel.results!.isNotEmpty) {
        return responseModel.results![0].formattedAddress ?? "";
      } else {
        // Handle no results found
        return "No address found for the provided location.";
      }
    } else {
      // Handle HTTP errors
      return "Failed to fetch location. Status: ${response.statusCode}";
    }
  }

  ///------------------------------ business profile ------------------------------///

  TextEditingController businessNameController = TextEditingController(),
      aboutController = TextEditingController(),
      mobileWsController = TextEditingController(),
      emailIdController = TextEditingController(),
      mobileNumController = TextEditingController(),
      flatNoController = TextEditingController(),
      streetController = TextEditingController(),
      areaNameController = TextEditingController(),
      cityController = TextEditingController(),
      stateController = TextEditingController(),
      businessweblink = TextEditingController(),
      pincodeController = TextEditingController();

  bool isIntrestBusiness = false;

  bool isbusinesshour = false;

  int currentBusStep = 1;

  List<DropdownItemModel> selectedBusinessCategory = [];
  List<DropdownItemModel> selectedIntrestedBusinessCategory = [];

  var dailcode = '+91';
  var dailWSCode = '+91';
  bool isValid = true;
  bool isValidForBusinessWAMobile = true;

  List<String> imageBrochureList = [];
  final picker = ImagePicker();

  Future<void> selectBrochure() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png', 'jpeg'],
      allowMultiple: true,
    );

    if (result != null) {
      if (result.files.first.path!.split(".").last == 'pdf') {
        if (Utility.getImageSizeMB(result.files.first.path ?? "") <= 100) {
          if (imageBrochureList.length < 5) {
            var filePath = await profilePresenter.uploadBrochure(
              filePath: result.files.first.path ?? "",
              isLoading: true,
            );
            imageBrochureList.add(
              filePath ?? '',
            );
            update();
          } else {
            Utility.snacBar('max_5_brochure'.tr, ColorsValue.maincolor1);
          }
        } else {
          Utility.errorMessage("max_100_mb_doc".tr);
        }
      } else {
        if (Utility.getImageSizeMB(result.files.first.path ?? "") <= 16) {
          if (imageBrochureList.length < 5) {
            var filePath = await profilePresenter.uploadBrochure(
              filePath: result.files.first.path ?? "",
              isLoading: true,
            );
            imageBrochureList.add(
              filePath ?? '',
            );
            update();
          } else {
            Utility.snacBar('max_5_brochure'.tr, ColorsValue.maincolor1);
          }
        } else {
          Utility.errorMessage("max_16_mb_img".tr);
        }
      }
      // if (imageBrochureList.length < 5) {
      //   var filePath = await profilePresenter.uploadBrochure(
      //     filePath: result.files.first.path ?? "",
      //     isLoading: true,
      //   );
      //   imageBrochureList.add(
      //     filePath ?? '',
      //   );
      //   update();
      // } else {
      //   Utility.snacBar('max_5_brochure'.tr, ColorsValue.maincolor1);
      // }
    }
    update();
  }

  Future<void> removeBrochure(String imageBrochure, int index) async {
    var response = await profilePresenter.removeBrochure(
      filekey: imageBrochure,
      isLoading: true,
    );
    if (response != null) {
      imageBrochureList.removeAt(index);
    }
    update();
  }

  // final imageFileList = <XFile>[];
  List<String> photosList = [];
  List<String> imageAddList = [];

  Future<void> selectPhotos() async {
    final List<XFile> selectedImages =
        await picker.pickMultiImage(imageQuality: 5);

    if (selectedImages.isNotEmpty) {
      for (var images in selectedImages) {
        if (Utility.getImageSizeMB(images.path) <= 16) {
          if (photosList.length < 5) {
            var filePath = await profilePresenter.uploadBusinessPhoto(
              filePath: images.path,
              isLoading: true,
            );
            photosList.add(
              filePath ?? '',
            );
            update();
          } else {
            Utility.snacBar(
                'Maximum 5 Photos Upload'.tr, ColorsValue.maincolor1);
          }
        } else {
          Utility.errorMessage("max_16_mb_img".tr);
        }
      }
    }
    update();
  }

  Future<void> removePhoto(String imageBrochure, int index) async {
    var response = await profilePresenter.removeBusinessPhoto(
      filekey: imageBrochure,
      isLoading: true,
    );
    if (response != null) {
      photosList.removeAt(index);
    }
    update();
  }

  final videoFileList = <XFile>[];
  List<String> videoList = [];

  Future<void> selectVideos() async {
    var selectedVideo = await picker.pickVideo(source: ImageSource.gallery);

    if (selectedVideo != null) {
      if (Utility.getImageSizeMB(selectedVideo.path) <= 56) {
        if (videoList.length < 3) {
          var filePath = await profilePresenter.uploadBusinessVideo(
            filePath: selectedVideo.path,
            isLoading: false,
          );
          videoList.add(
            filePath ?? '',
          );
          update();
        } else {
          Utility.errorMessage("max_3_videos".tr);
        }
      } else {
        Utility.errorMessage("max_56_mb_vid".tr);
      }
    }
    update();
  }

  Future<void> removeVideos(String imageBrochure, int index) async {
    var response = await profilePresenter.removeBusinessVideo(
      filekey: imageBrochure,
      isLoading: true,
    );
    if (response != null) {
      videoList.removeAt(index);
      videoFileList.removeAt(index);
    }
    update();
  }

  String? enterbusiness(String value) {
    if (value.isEmpty) {
      return "enter_business_name".tr;
    }
    return null;
  }

  String? businessMobile(String value) {
    if (value.isEmpty) {
      return "enteryournumber".tr;
    } else if (!isValid) {
      return "enter_valid_phone_number".tr;
    }
    return null;
  }

  String? businessWAMobile(String value) {
    if (value.isEmpty) {
      return null;
    } else if (!isValidForBusinessWAMobile) {
      return "enter_valid_phone_number".tr;
    }
    return null;
  }

  String? businessEmail(String value) {
    if (value.isEmpty) {
      return "enter_business_emailId".tr;
    } else if (!Utility.emailValidator(value)) {
      return "enter_valid_business_emailId".tr;
    }
    return null;
  }

  String? businessWeblink(String value) {
    String pattern =
        r'(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?';
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return 'enter_url'.tr;
    } else if (!regExp.hasMatch(value)) {
      return 'enter_valid_url'.tr;
    }
    return null;
  }

  String? entercityname(String value) {
    if (value.isEmpty) {
      return 'enter_city'.tr;
    }
    return null;
  }

  String? enterstate(String value) {
    if (value.isEmpty) {
      return 'enter_state'.tr;
    }
    return null;
  }

  String? enterpincode(String value) {
    if (value.isEmpty) {
      return 'enter_pincode'.tr;
    }
    return null;
  }

  List<CategoriesData> catagoriesList = [];

  Future<void> getBusinessCategories({
    bool isLoading = true,
  }) async {
    var response = await profilePresenter.getBusinessCategories(
      isLoading: isLoading,
    );
    if (response != null) {
      catagoriesList.clear();
      catagoriesList.addAll(response.data ?? []);
      update();
    } else {
      print("No response from API");
      Utility.errorMessage(response?.message ?? "");
    }
  }

  File? imageBusinessFile;
  String businessProfilePic = '';

  Future setBusinessProfilePic() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (Utility.getImageSizeMB(pickedFile.path) <= 16) {
        imageBusinessFile = File(pickedFile.path);
        businessProfilePic = await profilePresenter.setBusinessProfilePic(
              filePath: imageBusinessFile?.path ?? "",
              isLoading: true,
            ) ??
            '';
      } else {
        Utility.errorMessage("max_16_mb_img".tr);
      }
    }
    update();
  }

  int indexBusiness = 0;

  List<Socialmedialink> businessSocialMediaLink = [
    Socialmedialink(
      icon: AssetConstants.facebookimage,
      size: Dimens.fourty,
      platform: "Facebook",
      url: "",
      hintText: 'Enter Facebook Link',
      textEditingController: TextEditingController(),
    ),
    Socialmedialink(
      icon: AssetConstants.instagramimage,
      size: Dimens.fourty,
      platform: "Instagram",
      url: "",
      hintText: 'Enter Instagram Link',
      textEditingController: TextEditingController(),
    ),
    Socialmedialink(
      icon: AssetConstants.ximage,
      size: Dimens.fourty,
      platform: "X",
      url: "",
      hintText: 'Enter X Link',
      textEditingController: TextEditingController(),
    ),
    Socialmedialink(
      icon: AssetConstants.printrestimage,
      size: Dimens.fourty,
      platform: "Pinterest",
      url: "",
      hintText: 'Enter Pinterest Link',
      textEditingController: TextEditingController(),
    ),
    Socialmedialink(
      icon: AssetConstants.linkedinimage,
      size: Dimens.fourty,
      platform: "Linkedin",
      url: "",
      hintText: 'Enter Linkedin Link',
      textEditingController: TextEditingController(),
    ),
    Socialmedialink(
      icon: AssetConstants.youtubeimage,
      size: Dimens.fourty,
      platform: "Youtube",
      url: "",
      hintText: 'Enter Youtube Link',
      textEditingController: TextEditingController(),
    ),
  ];

  LatLng? businessProfileLatLag;
  String? editBusinessId;

  Future<void> setBusinessProfile({
    bool isLoading = true,
  }) async {
    var _selectedBusinessCategory = <AddBusinessCategory>[];
    var _selectedIntrestedBusinessCategory = <AddBusinessCategory>[];
    for (var catagories in selectedBusinessCategory) {
      var index = _selectedBusinessCategory.indexWhere(
          (element) => element.parentCategory == catagories.mainCatagoriesId);
      if (index.isNegative) {
        _selectedBusinessCategory.add(AddBusinessCategory(
            parentCategory: catagories.mainCatagoriesId ?? '',
            childCategories: [catagories.id ?? '']));
      } else {
        _selectedBusinessCategory[index]
            .childCategories
            .add(catagories.id ?? '');
      }
    }
    for (var catagories in selectedIntrestedBusinessCategory) {
      var index = _selectedIntrestedBusinessCategory.indexWhere(
          (element) => element.parentCategory == catagories.mainCatagoriesId);
      if (index.isNegative) {
        _selectedIntrestedBusinessCategory.add(AddBusinessCategory(
            parentCategory: catagories.mainCatagoriesId ?? '',
            childCategories: [catagories.id ?? '']));
      } else {
        _selectedIntrestedBusinessCategory[index]
            .childCategories
            .add(catagories.id ?? '');
      }
    }
    var response = await profilePresenter.setBusinessProfile(
      businessid: editBusinessId ?? '',
      profileimage: businessProfilePic,
      name: businessNameController.text,
      categories: _selectedBusinessCategory,
      about: aboutController.text,
      mobile: mobileNumController.text,
      mobileCountryCode: dailcode,
      wamobile: mobileWsController.text,
      wamobileCountryCode: dailWSCode,
      email: emailIdController.text,
      website: businessweblink.text,
      interestedCategories:
          isIntrestBusiness ? _selectedIntrestedBusinessCategory : [],
      brochures: imageBrochureList,
      photos: photosList,
      videos: videoList,
      address: AddBusinessAddress(
        flatno: flatNoController.text,
        street: streetController.text,
        area: areaNameController.text,
        city: cityController.text,
        state: stateController.text,
        pincode: pincodeController.text,
      ),
      latitude: businessProfileLatLag!.latitude,
      longitude: businessProfileLatLag!.longitude,
      businesshours: businessHoursList,
      socialmedialinks: businessSocialMediaLink
          .map((e) => Socialmedialink(platform: e.platform, url: e.url))
          .toList(),
      isBusinessCategories: isIntrestBusiness,
      isLoading: true,
    );
    if (response!.statusCode == 200) {
      Get.offNamed(Routes.userProfileScreen);
    } else {
      var res = jsonDecode(response.data);
      Utility.errorMessage(res['Message']);
    }
  }

  ///-------------------------------- change business Houre  -----------------------------///
  GlobalKey<FormState> businessprofileFormKey = GlobalKey<FormState>();

  int timeIndex = 0;
  TimeOfDay? startTimeOfDay;
  TimeOfDay? endTimeOfDay;

  bool isHourAdd = false;
  List<AddBusinessBusinesshour> businessHoursList = [
    AddBusinessBusinesshour(
      day: 'Sunday',
      open: false,
      time: [
        AddBusinessTime(
          starttime: "HH:MM A",
          endtime: "HH:MM A",
        ),
      ],
    ),
    AddBusinessBusinesshour(
      day: 'Monday',
      open: false,
      time: [
        AddBusinessTime(
          starttime: "HH:MM A",
          endtime: "HH:MM A",
        ),
      ],
    ),
    AddBusinessBusinesshour(
      day: 'Tuesday',
      open: false,
      time: [
        AddBusinessTime(
          starttime: "HH:MM A",
          endtime: "HH:MM A",
        ),
      ],
    ),
    AddBusinessBusinesshour(
      day: 'Wednesday',
      open: false,
      time: [
        AddBusinessTime(
          starttime: "HH:MM A",
          endtime: "HH:MM A",
        ),
      ],
    ),
    AddBusinessBusinesshour(
      day: 'Thursday',
      open: false,
      time: [
        AddBusinessTime(
          starttime: "HH:MM A",
          endtime: "HH:MM A",
        ),
      ],
    ),
    AddBusinessBusinesshour(
      day: 'Friday',
      open: false,
      time: [
        AddBusinessTime(
          starttime: "HH:MM A",
          endtime: "HH:MM A",
        ),
      ],
    ),
    AddBusinessBusinesshour(
      day: 'Saturday',
      open: false,
      time: [
        AddBusinessTime(
          starttime: "HH:MM A",
          endtime: "HH:MM A",
        ),
      ],
    ),
  ];

  ///======================================= LocationScreen =========================================///

  LatLng? locationLatlag;
  final Set<Marker> locationMarker = Set();
  Completer<GoogleMapController> controllerMap = Completer();

  void onMapCreated(GoogleMapController controller) {
    if (!controllerMap.isCompleted) {
      controllerMap.complete(controller);
    }
    moveToLocation(profileLatLag ?? const LatLng(21.170240, 72.831062));
  }

  void moveToLocation(LatLng latLng) {
    this.controllerMap.future.then((controller) {
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
        markerId: MarkerId("mark"),
        position: latLng,
      ),
    );
    update();
  }

  Future<String> getPlacemarks(double lat, double long) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);

      var address = '';

      if (placemarks.isNotEmpty) {
        // Concatenate non-null components of the address
        var streets = placemarks.reversed
            .map((placemark) => placemark.street)
            .where((street) => street != null);

        // Filter out unwanted parts
        streets = streets.where((street) =>
            street!.toLowerCase() !=
            placemarks.reversed.last.locality!
                .toLowerCase()); // Remove city names
        streets = streets
            .where((street) => !street!.contains('+')); // Remove street codes

        address += streets.join(', ');

        address += ', ${placemarks.reversed.last.subLocality ?? ''}';
        address += ', ${placemarks.reversed.last.locality ?? ''}';
        address += ', ${placemarks.reversed.last.subAdministrativeArea ?? ''}';
        address += ', ${placemarks.reversed.last.administrativeArea ?? ''}';
        address += ', ${placemarks.reversed.last.postalCode ?? ''}';
        address += ', ${placemarks.reversed.last.country ?? ''}';

        streetController.text = placemarks.reversed.last.street.toString();
        cityController.text = placemarks.reversed.last.locality.toString();
        stateController.text =
            placemarks.reversed.last.administrativeArea.toString();
        pincodeController.text = placemarks.reversed.last.postalCode.toString();
        update();
      }

      print("Your Address for ($lat, $long) is: $address");

      return address;
    } catch (e) {
      print("Error getting placemarks: $e");
      return "No Address";
    }
  }

  /// ------------------------------------ ProfileScreen ------------------------------------///

  bool applock = false;

  ///------------------------------ Business Product ------------------------------///
  String? chooseBusinessName;
  String? proId;
  final GlobalKey<FormState> businessProductFormKey = GlobalKey<FormState>();
  List<String> droupDownItem = [
    'business',
    'type',
  ];

  showdeletdilog(argument) async {
    return Get.dialog(
      Padding(
        padding: Dimens.edgeInsetsTop20,
        child: Material(
          color: ColorsValue.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    padding: Dimens.edgeInsets25_30_25_30,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: SvgPicture.asset(
                                AssetConstants.cancleicon,
                              )),
                        ),
                        Container(
                          height: Dimens.twoHundred,
                          width: Dimens.twoHundred,
                          child: Image.asset(AssetConstants.deletproductimage),
                        ),
                        Text(
                          "delete_product".tr,
                          style: Styles.black70020,
                        ),
                        Text(
                          "areyou_sure_delet_product".tr,
                          style: Styles.greyColor888840014,
                        ),
                        Dimens.boxHeight18,
                        CustomBottomButton(
                          firstbtnText: "cancle".tr.toUpperCase(),
                          secondbtnTxt: "delete".tr.toUpperCase(),
                          firstStyle: Styles.greyColor888850014,
                          secondStyle: Styles.white50014,
                          bordercolor: ColorsValue.greyColor8888,
                          firstOnPressed: () {
                            Get.back();
                          },
                          secondOnPressed: () {
                            removeProduct(argument);
                          },
                        )
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
  }

  Future<bool> imagePermissionCheack(BuildContext context) async {
    return Utility.cameraPermissionCheack(context);
  }

  ///---------------------------- add Product ---------------------///

  TextEditingController productNameController = TextEditingController(),
      productDiscriptionController = TextEditingController(),
      productOfferController = TextEditingController(),
      productSearchController = TextEditingController(),
      productPriceController = TextEditingController();
  final pickerProductimage = ImagePicker();
  String? businessId;
  String? mainProductImage;
  List<DropdownItemModel> selectProductcategory = [];
  List<DropdownItemModel> selectFilterProductcategory = [];

  final productimageList = <XFile>[];
  List<String> productPhotoList = [];

  String offerType = 'amount';

  Future<void> selectProductPhotos() async {
    final List<XFile> selectedImages = await picker.pickMultiImage(
      imageQuality: 5,
    );

    if (selectedImages.isNotEmpty) {
      for (var images in selectedImages) {
        if (Utility.getImageSizeMB(images.path) <= 16) {
          if (productPhotoList.length < 5) {
            var filePath = await profilePresenter.setProductPhoto(
              isLoading: true,
              filePath: images.path,
            );
            productPhotoList.add(
              filePath ?? '',
            );
            update();
          } else {
            Utility.snacBar(
                'Maximum 5 Image Upload'.tr, ColorsValue.maincolor1);
          }
        } else {
          Utility.errorMessage("max_16_mb_img".tr);
        }
      }
    }
    update();
  }

  final productVideoFileList = <XFile>[];
  List<String> productVideoList = [];

  Future<void> selectProductVideos() async {
    var selectedVideo = await picker.pickVideo(source: ImageSource.gallery);

    if (selectedVideo != null) {
      if (Utility.getImageSizeMB(selectedVideo.path) <= 56) {
        if (productVideoList.length < 2) {
          var filePath = await profilePresenter.uploadProductVideo(
            isLoading: true,
            filePath: selectedVideo.path,
          );
          productVideoList.add(
            filePath ?? '',
          );
          update();
        } else {
          Utility.snacBar('Maximum 2 Videos Upload'.tr, ColorsValue.maincolor1);
        }
      } else {
        Utility.errorMessage("max_56_mb_vid".tr);
      }
    }
    update();
  }

  String? mainInageProduct = "";

  Future setMainImageProduct() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (Utility.getImageSizeMB(pickedFile.path) <= 16) {
        var imageMainFile = File(pickedFile.path);
        mainInageProduct = await profilePresenter.setProductPhoto(
                isLoading: true, filePath: imageMainFile.path) ??
            '';
      } else {
        Utility.errorMessage("max_16_mb_img".tr);
      }
    }
    update();
  }

  String? businessIds = "";

  Future<void> addProduct({
    bool isLoading = true,
    required String productId,
  }) async {
    var _selectedProductCategory = <AddBusinessCategory>[];
    for (var catagories in selectProductcategory) {
      var index = _selectedProductCategory.indexWhere(
          (element) => element.parentCategory == catagories.mainCatagoriesId);
      if (index.isNegative) {
        _selectedProductCategory.add(AddBusinessCategory(
            parentCategory: catagories.mainCatagoriesId ?? '',
            childCategories: [catagories.id ?? '']));
      } else {
        _selectedProductCategory[index]
            .childCategories
            .add(catagories.id ?? '');
      }
    }
    var response = await profilePresenter.addProduct(
      isLoading: true,
      businessid: businessIds ?? "",
      productid: productId,
      name: productNameController.text.trim(),
      image: mainInageProduct ?? "",
      categories: _selectedProductCategory,
      description: productDiscriptionController.text.trim(),
      price: int.tryParse(productPriceController.text.trim()) ?? 0,
      offer: int.tryParse(productOfferController.text.trim()) ?? 0,
      offerType: offerType,
      images: productPhotoList,
      videos: productVideoList,
    );
    if (response != null) {
      if (productId.isNotEmpty) {
        Get.back();
        Get.back();
        productPagingController.refresh();
      } else {
        Get.back();
        productPagingController.refresh();
      }
    } else {
      Utility.errorMessage('failed_to_save_product'.tr);
    }
    update();
  }

  void clearAddProductValues() {
    productNameController.clear();
    productDiscriptionController.clear();
    productPriceController.clear();
    productOfferController.clear();
    productPhotoList.clear();
    productVideoList.clear();
    selectProductcategory.clear();
    mainInageProduct = "";
  }

  PagingController<int, GetProductListDoc> productPagingController =
      PagingController(firstPageKey: 1);

  List<GetProductListDoc> productDetail = [];
  int limit = 10;

  Future<void> getproductList(int pageKey) async {
    var _selectedProductCategory = <AddBusinessCategory>[];
    for (var catagories in selectFilterProductcategory) {
      var index = _selectedProductCategory.indexWhere(
          (element) => element.parentCategory == catagories.mainCatagoriesId);
      if (index.isNegative) {
        _selectedProductCategory.add(AddBusinessCategory(
            parentCategory: catagories.mainCatagoriesId ?? '',
            childCategories: [catagories.id ?? '']));
      } else {
        _selectedProductCategory[index]
            .childCategories
            .add(catagories.id ?? '');
      }
    }
    var response = await profilePresenter.getproductList(
      page: pageKey,
      limit: limit,
      search: productSearchController.text,
      business: businessIds ?? "",
      parentcategory:
          _selectedProductCategory.map((e) => e.parentCategory).toList(),
      childcategory: [],
      isLoading: true,
    );
    if (response == null) {
      print(null);
    } else {
      if (pageKey == 1) {
        productDetail.clear();
      }
      productDetail = response.data.docs;

      final isLastPage = productDetail.length < limit;
      if (isLastPage) {
        productPagingController.appendLastPage(productDetail);
      } else {
        var nextPageKey = pageKey + 1;
        productPagingController.appendPage(productDetail, nextPageKey);
      }
      update();
    }
  }

  GetOneProductData? oneProductDetail;
  List<String> imageList = [];
  List<String> videosList = [];
  List<String> allVideoList = [];

  Future<void> getOneProduct(String productid, bool isEdit) async {
    var response = await profilePresenter.getOneProduct(
      isLoading: true,
      productid: productid,
    );
    imageList.clear();
    videosList.clear();
    allVideoList.clear();
    oneProductDetail = null;
    if (response != null) {
      oneProductDetail = response.data!;
      for (var item in response.data?.images ?? []) {
        imageList.add(item);
      }
      for (var item in response.data?.videos ?? []) {
        videosList.add(item);
      }
      allVideoList.add(response.data!.image ?? "");
      allVideoList.addAll(imageList + videosList);
      if (isEdit) {
        productNameController.text = response.data?.name ?? '';
        mainInageProduct = response.data?.image ?? '';
        productDiscriptionController.text = response.data?.description ?? '';
        productPriceController.text = response.data?.price.toString() ?? "";
        productOfferController.text = response.data?.offer.toString() ?? '';
        productPhotoList = response.data?.images ?? [];
        productVideoList = response.data?.videos ?? [];
        offerType = response.data?.offerType ?? 'amount';
        selectProductcategory.clear();
        for (var parentCategory
            in response.data?.categories ?? <GetParentChildCatagoryModel>[]) {
          for (var childCatagories in parentCategory.childCategories) {
            selectProductcategory.add(DropdownItemModel(
                mainCatagoriesName: parentCategory.parentCategory.name ?? "",
                mainCatagoriesId: parentCategory.parentCategory.id,
                name: childCatagories.name ?? "",
                id: childCatagories.id));
          }
        }
      }
      update();
    }
  }

  Future<void> removeProduct(String productid) async {
    var response = await profilePresenter.removeProduct(
      productid: productid,
      isLoading: true,
    );
    if (response != null) {
      productPagingController.refresh();
    }
    update();
  }

  Future<void> removeProductPhoto(String imageBrochure, int index) async {
    var response = await profilePresenter.removeProductPhoto(
      filekey: imageBrochure,
      isLoading: true,
    );
    if (response != null) {
      productPhotoList.removeAt(index);
    }
    update();
  }

  Future<void> removeProductVideos(String videoBrochure, int index) async {
    var response = await profilePresenter.removeProductVideo(
      filekey: videoBrochure,
      isLoading: true,
    );
    if (response != null) {
      productVideoList.removeAt(index);
    }
    update();
  }

  List<ProductCategoryDatum> productCatagoriesList = [];

  ProductCategoryDatum productcategory = ProductCategoryDatum();

  Future<void> getProductCategory({
    bool isLoading = true,
    int page = 1,
    int limit = 100,
    String search = "",
  }) async {
    var response = await profilePresenter.getProductCategory(
      isLoading: isLoading,
      page: page,
      limit: limit,
      search: search,
    );
    if (response != null) {
      productCatagoriesList.clear();
      productCatagoriesList.addAll(response.data); //catagoriesList
      update();
    }
  }

  bool isLocation = false;

  /// ============================================= BusinessInfoScreen ============================================= ///

  List<GetBusinessDatum> businessList = [];

  int businessIndex = 0;

  Future<void> getBusinessList({
    bool isLoading = false,
  }) async {
    var response = await profilePresenter.getBusinessList(
      isLoading: isLoading,
    );
    businessList.clear();
    if (response != null) {
      if (response.data.isNotEmpty) {
        businessList.addAll(response.data);
        Get.find<Repository>()
            .saveValue(LocalKeys.productId, businessList[businessIndex].id);
        await getOneBusiness(businessList[businessIndex].id ?? "", false);
      }
    }
    update();
  }

  bool isCategory = false;

  GetOneBusinessData getOneBusinessData = GetOneBusinessData();

  String locationBusinessText = "";
  LatLng? businessLatlag;

  Future<void> getOneBusiness(String id, bool isEdit) async {
    var response = await profilePresenter.getOneBusiness(
      isLoading: false,
      businessid: id,
    );
    imageBrochureList.clear();
    photosList.clear();
    imageAddList.clear();
    videoList.clear();
    if (response != null) {
      getOneBusinessData = response.data;
      if (response.data.location != null) {
        locationBusinessText = await getLocation(
            response.data.location!.coordinates[1],
            response.data.location!.coordinates[0]);

        businessLatlag = LatLng(response.data.location!.coordinates[1],
            response.data.location!.coordinates[0]);
      }
      if (isEdit) {
        businessProfilePic = response.data.profileimage ?? "";
        businessNameController.text = response.data.name ?? "";
        aboutController.text = response.data.about ?? "";
        mobileNumController.text = response.data.mobile ?? "";
        dailcode = response.data.mobileCountryCode ?? "";
        dailWSCode = response.data.wamobileCountryCode ?? "";
        emailIdController.text = response.data.email ?? "";
        businessweblink.text = response.data.website ?? "";
        imageBrochureList.addAll(response.data.brochures ?? []);
        photosList.addAll(response.data.photos ?? []);
        imageAddList.addAll(response.data.photos ?? []);
        response.data.videos!.map((e) {
          return e.isNotEmpty ? videoList.add(e) : [];
        }).toList();
        flatNoController.text = response.data.address?.flatno ?? "";
        streetController.text = response.data.address?.street ?? "";
        areaNameController.text = response.data.address?.area ?? "";
        cityController.text = response.data.address?.city ?? "";
        stateController.text = response.data.address?.state ?? "";
        pincodeController.text = response.data.address?.pincode ?? "";
        businessProfileLatLag = LatLng(
            response.data.location?.coordinates[1] ?? 0.0,
            response.data.location?.coordinates[0] ?? 0.0);

        businessHoursList = response.data.businesshours ?? [];

        for (var data
            in response.data.socialmedialinks ?? <Socialmedialink>[]) {
          var index = businessSocialMediaLink
              .indexWhere((element) => element.platform == data.platform);
          if (!index.isNegative) {
            businessSocialMediaLink[index].url = data.url;
            businessSocialMediaLink[index].textEditingController =
                TextEditingController(text: data.url);
          } else {
            businessSocialMediaLink[index].url = '';
            businessSocialMediaLink[index].textEditingController =
                TextEditingController();
          }
        }
        selectedBusinessCategory.clear();
        for (var parentCategory
            in response.data.categories ?? <GetParentChildCatagoryModel>[]) {
          for (var childCatagories in parentCategory.childCategories) {
            selectedBusinessCategory.add(DropdownItemModel(
                mainCatagoriesName: parentCategory.parentCategory.name ?? "",
                mainCatagoriesId: parentCategory.parentCategory.id,
                name: childCatagories.name ?? "",
                id: childCatagories.id));
          }
        }

        selectedIntrestedBusinessCategory.clear();
        for (var parentCategory in response.data.interestedCategories ??
            <GetParentChildCatagoryModel>[]) {
          for (var childCatagories in parentCategory.childCategories) {
            selectedIntrestedBusinessCategory.add(DropdownItemModel(
                mainCatagoriesName: parentCategory.parentCategory.name ?? "",
                mainCatagoriesId: parentCategory.parentCategory.id,
                name: childCatagories.name ?? "",
                id: childCatagories.id));
          }
        }
      }
      update();
    }
  }

  void clearBusinessProfileValues() {
    isIntrestBusiness = false;
    businessProfilePic = '';
    businessNameController.clear();
    mobileWsController.clear();
    aboutController.clear();
    mobileNumController.clear();
    dailcode = '+91';
    dailWSCode = '+91';
    isValid = true;
    isValidForBusinessWAMobile = true;
    emailIdController.clear();
    businessweblink.clear();
    imageBrochureList.clear();
    photosList.clear();
    videoList.clear();
    flatNoController.clear();
    streetController.clear();
    areaNameController.clear();
    cityController.clear();
    stateController.clear();
    pincodeController.clear();
    businessProfileLatLag = const LatLng(21.170240, 72.831062);
    businessHoursList = [
      AddBusinessBusinesshour(
        day: 'Sunday',
        open: false,
        time: [
          AddBusinessTime(
            starttime: "HH:MM A",
            endtime: "HH:MM A",
          ),
        ],
      ),
      AddBusinessBusinesshour(
        day: 'Monday',
        open: false,
        time: [
          AddBusinessTime(
            starttime: "HH:MM A",
            endtime: "HH:MM A",
          ),
        ],
      ),
      AddBusinessBusinesshour(
        day: 'Tuesday',
        open: false,
        time: [
          AddBusinessTime(
            starttime: "HH:MM A",
            endtime: "HH:MM A",
          ),
        ],
      ),
      AddBusinessBusinesshour(
        day: 'Wednesday',
        open: false,
        time: [
          AddBusinessTime(
            starttime: "HH:MM A",
            endtime: "HH:MM A",
          ),
        ],
      ),
      AddBusinessBusinesshour(
        day: 'Thursday',
        open: false,
        time: [
          AddBusinessTime(
            starttime: "HH:MM A",
            endtime: "HH:MM A",
          ),
        ],
      ),
      AddBusinessBusinesshour(
        day: 'Friday',
        open: false,
        time: [
          AddBusinessTime(
            starttime: "HH:MM A",
            endtime: "HH:MM A",
          ),
        ],
      ),
      AddBusinessBusinesshour(
        day: 'Saturday',
        open: false,
        time: [
          AddBusinessTime(
            starttime: "HH:MM A",
            endtime: "HH:MM A",
          ),
        ],
      ),
    ];
    businessSocialMediaLink = [
      Socialmedialink(
        icon: AssetConstants.facebookimage,
        size: Dimens.fourty,
        platform: "Facebook",
        url: "",
        hintText: 'Enter Facebook Link',
        textEditingController: TextEditingController(),
      ),
      Socialmedialink(
        icon: AssetConstants.instagramimage,
        size: Dimens.fourty,
        platform: "Instagram",
        url: "",
        hintText: 'Enter Instagram Link',
        textEditingController: TextEditingController(),
      ),
      Socialmedialink(
        icon: AssetConstants.ximage,
        size: Dimens.fourty,
        platform: "X",
        url: "",
        hintText: 'Enter X Link',
        textEditingController: TextEditingController(),
      ),
      Socialmedialink(
        icon: AssetConstants.printrestimage,
        size: Dimens.fourty,
        platform: "Pinterest",
        url: "",
        hintText: 'Enter Pinterest Link',
        textEditingController: TextEditingController(),
      ),
      Socialmedialink(
        icon: AssetConstants.linkedinimage,
        size: Dimens.fourty,
        platform: "Linkedin",
        url: "",
        hintText: 'Enter Linkedin Link',
        textEditingController: TextEditingController(),
      ),
      Socialmedialink(
        icon: AssetConstants.youtubeimage,
        size: Dimens.fourty,
        platform: "Youtube",
        url: "",
        hintText: 'Enter Youtube Link',
        textEditingController: TextEditingController(),
      ),
    ];
    selectedBusinessCategory.clear();
    selectedIntrestedBusinessCategory.clear();
    update();
  }

  Future<void> removeBusiness(String id) async {
    var response = await profilePresenter.removeBusiness(
      isLoading: true,
      businessid: id,
    );
    if (response != null) {
      businessIndex = 0;
      await getBusinessList();
    }
    update();
  }
}

class ModelData {
  String? hello;
  double? count;

  ModelData({this.hello, this.count});
}

var list = [
  ModelData(
    hello: "Fdsfdsf",
    count: 50.2,
  ),
  ModelData(
    hello: "dsad",
    count: 25.8,
  ),
  ModelData(
    hello: "Fdsfdasddsf",
    count: 20.2,
  ),
  ModelData(
    hello: "Fdsfddsadsasf",
    count: 50.2,
  ),
];
