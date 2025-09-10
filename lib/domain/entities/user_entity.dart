import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.avatar = 'https://placehold.co/44x44',
    this.createdAt,
    this.updatedAt,
    this.bio,
    this.lastActiveAt,
    required this.isAdmin,
  });

  final String id;
  final String name;
  final String email;
  final String avatar;
  final String? bio;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? lastActiveAt;
  final bool isAdmin;

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    avatar,
    bio,
    createdAt,
    updatedAt,
    isAdmin,
    lastActiveAt,
  ];

  UserEntity copyWith({
    String? id,
    String? name,
    String? email,
    String? avatar,
    String? bio,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastActiveAt,
    bool? isAdmin,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      bio: bio ?? this.bio,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }
}
