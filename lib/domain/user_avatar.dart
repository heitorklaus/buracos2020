class UserAvatar {
  String avatar;

  UserAvatar(
    this.avatar,
  );

  UserAvatar.fromJson(Map<String, dynamic> jsonUser)
      : avatar = jsonUser['avatar'];

  @override
  String toString() {
    return "$avatar";
  }
}
