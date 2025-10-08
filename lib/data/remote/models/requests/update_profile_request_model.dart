class UpdateProfileRequestModel {
  final String? name;
  final String? bio;
  final String? avatar;

  UpdateProfileRequestModel({this.name, this.bio, this.avatar});

  Map<String, dynamic> toJson() => {
    if (name != null) 'name': name,
    if (bio != null) 'bio': bio,
    if (avatar != null) 'avatar': avatar,
  };
}
