class User {
  final int     id;
  final String  email;
  final String  login;
  final String  first_name;
  final String  last_name;
  final String  display_name;
  final String  image_url;
  final bool    staff;
  final int     correction_point;
  final String  pool_month;
  final String  pool_year;
  final String  location;
  final int     wallet;

  User(this.id, this.email, this.login, this.first_name,
        this.last_name, this.display_name, this.image_url,
        this.staff, this.correction_point, this.pool_month,
        this.pool_year, this.location, this.wallet);
}
/*
{
  "id": 2,
  "email": "andre@42.fr",
  "login": "andre",
  "first_name": "André",
  "last_name": "Aubin",
  "usual_first_name": "Juliette",
  "url": "https://api.intra.42.fr/v2/users/andre",
  "phone": null,
  "displayname": "André Aubin",
  "usual_full_name": "Juliette Aubin",
  "image_url": "https://cdn.intra.42.fr/images/default.png",
  "staff?": false,
  "correction_point": 4,
  "pool_month": "july",
  "pool_year": "2016",
  "location": null,
  "wallet": 0,
  "anonymize_date": "2021-02-20T00:00:00.000+03:00",
  "groups": [],
  "cursus_users": [
    {
      "id": 2,
      "begin_at": "2017-05-14T21:37:50.172Z",
      "end_at": null,
      "grade": null,
      "level": 0.0,
      "skills": [],
      "cursus_id": 1,
      "has_coalition": true,
      "user": {
        "id": 2,
        "login": "andre",
        "url": "https://api.intra.42.fr/v2/users/andre"
      },
      "cursus": {
        "id": 1,
        "created_at": "2017-11-22T13:41:00.750Z",
        "name": "Piscine C",
        "slug": "piscine-c"
      }
    }
  ],
  "projects_users": [],
  "languages_users": [
    {
      "id": 2,
      "language_id": 3,
      "user_id": 2,
      "position": 1,
      "created_at": "2017-11-22T13:41:03.638Z"
    }
  ],
  "achievements": [],
  "titles": [],
  "titles_users": [],
  "partnerships": [],
  "patroned": [
    {
      "id": 4,
      "user_id": 2,
      "godfather_id": 15,
      "ongoing": true,
      "created_at": "2017-11-22T13:42:11.565Z",
      "updated_at": "2017-11-22T13:42:11.572Z"
    }
  ],
  "patroning": [],
  "expertises_users": [
    {
      "id": 2,
      "expertise_id": 3,
      "interested": false,
      "value": 2,
      "contact_me": false,
      "created_at": "2017-11-22T13:41:22.504Z",
      "user_id": 2
    }
  ],
  "campus": [
    {
      "id": 1,
      "name": "Cluj",
      "time_zone": "Europe/Bucharest",
      "language": {
        "id": 3,
        "name": "Romanian",
        "identifier": "ro",
        "created_at": "2017-11-22T13:40:59.468Z",
        "updated_at": "2017-11-22T13:41:26.139Z"
      },
      "users_count": 28,
      "vogsphere_id": 1
    }
  ],
  "campus_users": [
    {
      "id": 2,
      "user_id": 2,
      "campus_id": 1,
      "is_primary": true
    }
  ]
}*/