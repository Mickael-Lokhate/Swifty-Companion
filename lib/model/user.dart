import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class Cursus {
  final int id;
  final String? name;

  Cursus(this.id, this.name);
  factory Cursus.fromJson(Map<String, dynamic> json) => _$CursusFromJson(json);
}

@JsonSerializable()
class Skills {
  final int id;
  final String? name;
  final double? level;

  Skills(this.id, this.name, this.level);
 factory Skills.fromJson(Map<String, dynamic> json) => _$SkillsFromJson(json); 
}

@JsonSerializable()
class CursusUsers {
  final int id;
  final double? level;
  final Cursus? cursus;
  final List<Skills>? skills;
  final DateTime? end_at;

  CursusUsers(this.id, this.cursus, this.level, this.skills, this.end_at);
  factory CursusUsers.fromJson(Map<String, dynamic> json) => _$CursusUsersFromJson(json);
}

@JsonSerializable()
class Campus {
  final int id;
  final String? name;
  final String? country;
  final int? users_count;

  Campus(this.id, this.name, this.users_count, this.country);
  factory Campus.fromJson(Map<String, dynamic> json) => _$CampusFromJson(json);
}

@JsonSerializable()
class Titles {
  final int id;
  final String? name;

  Titles(this.id, this.name);
  factory Titles.fromJson(Map<String, dynamic> json) => _$TitlesFromJson(json);
}

@JsonSerializable()
class Project {
  final int id;
  final String? name;

  Project(this.id, this.name);

  factory Project.fromJson(Map<String, dynamic> json) => _$ProjectFromJson(json);
}

@JsonSerializable()
class ProjectUser {
  final int id;
  final int? final_mark;
  final String? status;
  final bool? validated;
  final Project? project;

  ProjectUser(this.id, this.status, this.project, this.final_mark, this.validated);

  factory ProjectUser.fromJson(Map<String, dynamic> json) => _$ProjectUserFromJson(json);
}

@JsonSerializable()
class Achievements {
  final int? id;
  final String? name;
  final String? description;
  final String? image;

  Achievements(this.id, this.name, this.description, this.image);

  factory Achievements.fromJson(Map<String, dynamic> json) => _$AchievementsFromJson(json);
}

@JsonSerializable()
class User {
  final int     id;
  final String?  email;
  final String?  url;
  final String?  login;
  final String?  first_name;
  final String?  last_name;
  final String?  displayname;
  final String?  image_url;
  final bool?    staff;
  final int?     correction_point;
  final String?  pool_month;
  final String?  pool_year;
  final String?  location;
  final List<CursusUsers>?  cursus_users;
  final List<Campus>?  campus;
  final List<Titles>?  titles;
  final List<ProjectUser>? projects_users;
  final int? wallet;
  final List<Achievements>? achievements;

  User(this.id, this.email, this.login, this.first_name, this.wallet,
        this.last_name, this.displayname, this.image_url, this.url,
        this.staff, this.correction_point, this.pool_month,
        this.pool_year, this.location, this.cursus_users, this.campus, this.titles, this.projects_users, this.achievements);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
