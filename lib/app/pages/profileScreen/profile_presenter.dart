import 'package:chatnest/domain/domain.dart';

class ProfilePresenter {
  ProfilePresenter(this.profileUseCases);

  final ProfileUseCases profileUseCases;

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
  }) async =>
      await profileUseCases.setProfile(
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

  Future<String?> setProfilePic({
    bool isLoading = false,
    required String filePath,
  }) async =>
      await profileUseCases.setProfilePic(
        isLoading: isLoading,
        filePath: filePath,
      );

  Future<String?> uploadBrochure({
    bool isLoading = false,
    required String filePath,
  }) async =>
      await profileUseCases.uploadBrochure(
        isLoading: isLoading,
        filePath: filePath,
      );

  Future<GetProfileModel?> getProfile({
    bool isLoading = false,
  }) async =>
      await profileUseCases.getProfile(
        isLoading: isLoading,
      );

  Future<GetBusinessCategoriesModel?> getBusinessCategories({
    bool isLoading = false,
  }) async =>
      await profileUseCases.getBusinessCategories(
        isLoading: isLoading,
      );

  Future<ProductCategoryModel?> getProductCategory({
    bool isLoading = false,
    required int page,
    required int limit,
    required String search,
  }) async =>
      await profileUseCases.getProductCategory(
        isLoading: isLoading,
        page: page,
        limit: limit,
        search: search,
      );

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
    required List<AddBusinessBusinesshour> businesshours,
    required List<Socialmedialink> socialmedialinks,
    required bool isBusinessCategories,
  }) async =>
      await profileUseCases.setBusinessProfile(
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

  Future<SaveProductModel?> addProduct({
    bool isLoading = false,
    required List<AddBusinessCategory> categories,
    required List<String> images,
    required List<String> videos,
    required String businessid,
    required String productid,
    required String name,
    required String description,
    required String image,
    required int price,
    required int offer,
    required String offerType,
  }) async =>
      await profileUseCases.addProduct(
        isLoading: isLoading,
        categories: categories,
        images: images,
        image: image,
        videos: videos,
        businessid: businessid,
        productid: productid,
        name: name,
        description: description,
        price: price,
        offer: offer,
        offerType: offerType,
      );

  Future<String?> setProductPhoto({
    bool isLoading = false,
    required String filePath,
  }) async =>
      await profileUseCases.setProductPhoto(
        isLoading: isLoading,
        filePath: filePath,
      );

  Future<String?> removeProductVideo({
    bool isLoading = false,
    required String filekey,
  }) async =>
      await profileUseCases.removeProductVideo(
        isLoading: isLoading,
        filekey: filekey,
      );

  Future<String?> uploadProductVideo({
    bool isLoading = false,
    required String filePath,
  }) async =>
      await profileUseCases.uploadProductVideo(
        isLoading: isLoading,
        filePath: filePath,
      );

  Future<GetProductListModel?> getproductList({
    bool isLoading = false,
    required int page,
    required int limit,
    required String search,
    required String business,
    required List<String> parentcategory,
    required List<String> childcategory,
  }) async =>
      await profileUseCases.getproductList(
        isLoading: isLoading,
        page: page,
        limit: limit,
        search: search,
        business: business,
        childcategory: childcategory,
        parentcategory: parentcategory,
      );

  Future<GetOneProductModel?> getOneProduct({
    bool isLoading = false,
    required String productid,
  }) async =>
      await profileUseCases.getOneProduct(
        isLoading: isLoading,
        productid: productid,
      );

  Future<String?> removeProduct({
    bool isLoading = false,
    required String productid,
  }) async =>
      await profileUseCases.removeProduct(
        isLoading: isLoading,
        productid: productid,
      );

  Future<String?> setBusinessProfilePic({
    bool isLoading = false,
    required String filePath,
  }) async =>
      await profileUseCases.setBusinessProfilePic(
        isLoading: isLoading,
        filePath: filePath,
      );

  Future<String?> uploadBusinessPhoto({
    bool isLoading = false,
    required String filePath,
  }) async =>
      await profileUseCases.uploadBusinessPhoto(
        isLoading: isLoading,
        filePath: filePath,
      );

  Future<String?> uploadBusinessVideo({
    bool isLoading = false,
    required String filePath,
  }) async =>
      await profileUseCases.uploadBusinessVideo(
        isLoading: isLoading,
        filePath: filePath,
      );

  Future<String?> removeBrochure({
    bool isLoading = false,
    required String filekey,
  }) async =>
      await profileUseCases.removeBrochure(
        isLoading: isLoading,
        filekey: filekey,
      );

  Future<String?> removeBusinessPhoto({
    bool isLoading = false,
    required String filekey,
  }) async =>
      await profileUseCases.removeBusinessPhoto(
        isLoading: isLoading,
        filekey: filekey,
      );

  Future<String?> removeBusinessVideo({
    bool isLoading = false,
    required String filekey,
  }) async =>
      await profileUseCases.removeBusinessVideo(
        isLoading: isLoading,
        filekey: filekey,
      );

  Future<GetBusinessListModel?> getBusinessList({
    bool isLoading = false,
  }) async =>
      await profileUseCases.getBusinessList(
        isLoading: isLoading,
      );

  Future<GetOneBusinessModel?> getOneBusiness({
    bool isLoading = false,
    required String businessid,
  }) async =>
      await profileUseCases.getOneBusiness(
        isLoading: isLoading,
        businessid: businessid,
      );

  Future<ResponseModel?> removeBusiness({
    bool isLoading = false,
    required String businessid,
  }) async =>
      await profileUseCases.removeBusiness(
        isLoading: isLoading,
        businessid: businessid,
      );

  Future<String?> removeProductPhoto({
    bool isLoading = false,
    required String filekey,
  }) async =>
      await profileUseCases.removeProductPhoto(
        isLoading: isLoading,
        filekey: filekey,
      );
}
