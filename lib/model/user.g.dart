// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cursus _$CursusFromJson(Map<String, dynamic> json) => Cursus(
      json['id'] as int,
      json['name'] as String?,
    );

Map<String, dynamic> _$CursusToJson(Cursus instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

Skills _$SkillsFromJson(Map<String, dynamic> json) => Skills(
      json['id'] as int,
      json['name'] as String?,
      (json['level'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$SkillsToJson(Skills instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'level': instance.level,
    };

CursusUsers _$CursusUsersFromJson(Map<String, dynamic> json) => CursusUsers(
      json['id'] as int,
      json['cursus'] == null
          ? null
          : Cursus.fromJson(json['cursus'] as Map<String, dynamic>),
      (json['level'] as num?)?.toDouble(),
      (json['skills'] as List<dynamic>?)
          ?.map((e) => Skills.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CursusUsersToJson(CursusUsers instance) =>
    <String, dynamic>{
      'id': instance.id,
      'level': instance.level,
      'cursus': instance.cursus,
      'skills': instance.skills,
    };

Campus _$CampusFromJson(Map<String, dynamic> json) => Campus(
      json['id'] as int,
      json['name'] as String?,
      json['users_count'] as int?,
      json['country'] as String?,
    );

Map<String, dynamic> _$CampusToJson(Campus instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'country': instance.country,
      'users_count': instance.users_count,
    };

Titles _$TitlesFromJson(Map<String, dynamic> json) => Titles(
      json['id'] as int,
      json['name'] as String?,
    );

Map<String, dynamic> _$TitlesToJson(Titles instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

Project _$ProjectFromJson(Map<String, dynamic> json) => Project(
      json['id'] as int,
      json['name'] as String?,
    );

Map<String, dynamic> _$ProjectToJson(Project instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

ProjectUser _$ProjectUserFromJson(Map<String, dynamic> json) => ProjectUser(
      json['id'] as int,
      json['status'] as String?,
      json['project'] == null
          ? null
          : Project.fromJson(json['project'] as Map<String, dynamic>),
      json['final_mark'] as int?,
      json['validated'] as bool?,
    );

Map<String, dynamic> _$ProjectUserToJson(ProjectUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'final_mark': instance.final_mark,
      'status': instance.status,
      'validated': instance.validated,
      'project': instance.project,
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
      json['id'] as int,
      json['email'] as String?,
      json['login'] as String?,
      json['first_name'] as String?,
      json['wallet'] as int?,
      json['last_name'] as String?,
      json['displayname'] as String?,
      json['image_url'] as String?,
      json['url'] as String?,
      json['staff'] as bool?,
      json['correction_point'] as int?,
      json['pool_month'] as String?,
      json['pool_year'] as String?,
      json['location'] as String?,
      (json['cursus_users'] as List<dynamic>?)
          ?.map((e) => CursusUsers.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['campus'] as List<dynamic>?)
          ?.map((e) => Campus.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['titles'] as List<dynamic>?)
          ?.map((e) => Titles.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['projects_users'] as List<dynamic>?)
          ?.map((e) => ProjectUser.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'url': instance.url,
      'login': instance.login,
      'first_name': instance.first_name,
      'last_name': instance.last_name,
      'displayname': instance.displayname,
      'image_url': instance.image_url,
      'staff': instance.staff,
      'correction_point': instance.correction_point,
      'pool_month': instance.pool_month,
      'pool_year': instance.pool_year,
      'location': instance.location,
      'cursus_users': instance.cursus_users,
      'campus': instance.campus,
      'titles': instance.titles,
      'projects_users': instance.projects_users,
      'wallet': instance.wallet,
    };
