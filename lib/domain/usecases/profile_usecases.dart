import '../repositories/repository.dart';
import '../models/models.dart';

class ProfileUseCases {
  ProfileUseCases(this.repository);

  final Repository repository;

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
      await repository.setProfile(
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
      await repository.setProfilePic(
        isLoading: isLoading,
        filePath: filePath,
      );

  Future<String?> uploadBrochure({
    bool isLoading = false,
    required String filePath,
  }) async =>
      await repository.uploadBrochure(
        isLoading: isLoading,
        filePath: filePath,
      );

  Future<GetProfileModel?> getProfile({
    bool isLoading = false,
  }) async =>
      await repository.getProfile(
        isLoading: isLoading,
      );

  Future<GetBusinessCategoriesModel?> getBusinessCategories({
    bool isLoading = false,
  }) async =>
      await repository.getBusinessCategories(
        isLoading: isLoading,
      );

  Future<ProductCategoryModel?> getProductCategory({
    bool isLoading = false,
    required int page,
    required int limit,
    required String search,
  }) async =>
      await repository.getProductCategory(
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
      await repository.setBusinessProfile(
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
    required String image,
    required String description,
    required int price,
    required int offer,
    required String offerType,
  }) async =>
      await repository.addProduct(
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

  Future<String?> setProductPhoto({
    bool isLoading = false,
    required String filePath,
  }) async =>
      await repository.setProductPhoto(
        isLoading: isLoading,
        filePath: filePath,
      );

  Future<String?> uploadProductVideo({
    bool isLoading = false,
    required String filePath,
  }) async =>
      await repository.uploadProductVideo(
        isLoading: isLoading,
        filePath: filePath,
      );

  Future<String?> removeProductVideo({
    bool isLoading = false,
    required String filekey,
  }) async =>
      await repository.removeProductVideo(
        isLoading: isLoading,
        filekey: filekey,
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
      await repository.getproductList(
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
      await repository.getOneProduct(
        isLoading: isLoading,
        productid: productid,
      );

  Future<String?> removeProduct({
    bool isLoading = false,
    required String productid,
  }) async =>
      await repository.removeProduct(
        isLoading: isLoading,
        productid: productid,
      );

  Future<String?> setBusinessProfilePic({
    bool isLoading = false,
    required String filePath,
  }) async =>
      await repository.setBusinessProfilePic(
        isLoading: isLoading,
        filePath: filePath,
      );

  Future<String?> uploadBusinessPhoto({
    bool isLoading = false,
    required String filePath,
  }) async =>
      await repository.uploadBusinessPhoto(
        isLoading: isLoading,
        filePath: filePath,
      );

  Future<String?> uploadBusinessVideo({
    bool isLoading = false,
    required String filePath,
  }) async =>
      await repository.uploadBusinessVideo(
        isLoading: isLoading,
        filePath: filePath,
      );

  Future<String?> removeBrochure({
    bool isLoading = false,
    required String filekey,
  }) async =>
      await repository.removeBrochure(
        isLoading: isLoading,
        filekey: filekey,
      );

  Future<String?> removeBusinessPhoto({
    bool isLoading = false,
    required String filekey,
  }) async =>
      await repository.removeBusinessPhoto(
        isLoading: isLoading,
        filekey: filekey,
      );

  Future<String?> removeBusinessVideo({
    bool isLoading = false,
    required String filekey,
  }) async =>
      await repository.removeBusinessVideo(
        isLoading: isLoading,
        filekey: filekey,
      );

  Future<GetBusinessListModel?> getBusinessList({
    bool isLoading = false,
  }) async =>
      await repository.getBusinessList(
        isLoading: isLoading,
      );

  Future<GetOneBusinessModel?> getOneBusiness({
    bool isLoading = false,
    required String businessid,
  }) async =>
      await repository.getOneBusiness(
        isLoading: isLoading,
        businessid: businessid,
      );

  Future<ResponseModel?> removeBusiness({
    bool isLoading = false,
    required String businessid,
  }) async =>
      await repository.removeBusiness(
        isLoading: isLoading,
        businessid: businessid,
      );

  Future<String?> removeProductPhoto({
    bool isLoading = false,
    required String filekey,
  }) async =>
      await repository.removeProductPhoto(
        isLoading: isLoading,
        filekey: filekey,
      );
}
