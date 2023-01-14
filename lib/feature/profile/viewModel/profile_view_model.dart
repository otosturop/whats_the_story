import 'dart:io';

import 'package:flutter/material.dart';
import 'package:whats_the_story/product/cache_manager/cache_manager.dart';

import '../model/user_profile_model.dart';
import '../service/profile_service.dart';

class ProfileViewModel with ChangeNotifier, CacheManager {
  final IUserProfileService profileService;

  bool isLoading = false;
  bool isSelectedPhoto = false;
  String avatarUrl = "-";
  ProfileData? profileData;
  late String userId;
  File? _selectedPhoto;
  String baseUrl = 'http://whatsyourstory.massviptransfer.com';

  set setSelectedPhoto(value) {
    _selectedPhoto = File(value);
    _changeSelectedPhotoStatus(true);
  }

  get selectedPhoto => _selectedPhoto;

  ProfileViewModel(this.profileService) {
    getUserInfo();
  }

  bool checkSelectedPhoto() {
    if (selectedPhoto != null) {
      _changeSelectedPhotoStatus(true);
      return true;
    } else {
      _changeSelectedPhotoStatus(false);
      return false;
    }
  }

  void _changeLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  Future<bool> logOut() async {
    bool result = await removeUser();
    profileData = null;
    userId = "0";
    if (result) {
      return true;
    } else {
      return false;
    }
  }

  void _changeSelectedPhotoStatus(bool value) {
    isSelectedPhoto = value;
    notifyListeners();
  }

  Future<String> controlUserId() async {
    userId = await getUserId() ?? "0";
    return userId;
  }

  Future<void> getUserInfo() async {
    _changeLoading();
    await controlUserId();
    if (userId != "0") {
      profileData = (await profileService.getUserProfile(userId))?.data;
      if (profileData != null) {
        setAvatarUrl(profileData?.avatarUrl ?? "-");
      }
    }
    _changeLoading();
  }

  void setAvatarUrl(String url) {
    avatarUrl = url;
  }

  Future<bool> updateUserProfile() async {
    _changeLoading();
    if (userId != "0") {
      bool result = await profileService.updateUserProfile(userId, profileData);
      _changeLoading();
      return result;
    }
    _changeLoading();
    return false;
  }

  Future<bool> updateAvatarImage() async {
    _changeLoading();
    if (checkSelectedPhoto()) {
      bool result = await profileService.uploadAvatarImage(userId, _selectedPhoto!);
      _changeLoading();
      return result;
    }
    _changeLoading();
    return false;
  }
}
