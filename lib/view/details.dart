import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swifty_companion/model/user.dart';
import 'package:url_launcher/url_launcher.dart';

class Details extends StatefulWidget {
  const Details(this.user, { Key? key }) : super(key: key);
  final dynamic user;

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  late User user;

  @override
  void initState() {
    super.initState();
    user = User.fromJson(widget.user);
  }

  @override
  Widget build(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    return Scaffold(
      appBar: AppBar(
        title: Text(user.login!.toUpperCase()),
        actions: [
          TextButton(
            child: const Text('Profile on 42', style: TextStyle(color: Colors.white),),
            onPressed: () async {
              final String url = 'https://profile.intra.42.fr/users/' + user.login!; 
              if ((await canLaunch(url))) {
                if (!(await launch(url))) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Can\'t go to the 42 intra profile'))
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Can\'t go to the 42 intra profile'))
                  );
              }
            },)
        ]
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 15,),
          Container(
            padding: const EdgeInsets.fromLTRB(15, 5, 5, 5),
            child: const Text('Projects', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
          ),
          const SizedBox(height: 10,),
          SizedBox(height: 150, child: _buildProjects()),
          const SizedBox(height: 15,),
          Container(
            padding: const EdgeInsets.fromLTRB(15, 5, 5, 5),
            child: const Text('Skills', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
          ),
          const SizedBox(height: 10,),
          SizedBox(height: 50, child: _buildSkills()),
          const SizedBox(height: 15,),
          Container(
            padding: const EdgeInsets.fromLTRB(15, 5, 5, 5),
            child: const Text('Achievements', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
          ),
          const SizedBox(height: 10,),
          SizedBox(height: 150, child: _buildAchievements()),
        ],
      ),
    );
  }

  Widget _buildAchievements() {
    List<Achievements>? achievs = user.achievements;
    if (achievs == null) {
      return const Text('No achievements yet');
    }
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: achievs.length,
      itemBuilder: (BuildContext context, int index) {
        String imageUrl = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQE62KWg_n_MHLu2mo90z1OgZ3rtslxnJa6iXRveeGzi9V4OJgL79h6SGfrWbZDPyItoOQ&usqp=CAU';
        if (achievs[index].image != null) {
          imageUrl = 'https://api.intra.42.fr' + (achievs[index].image!);
        }
        Widget image = SvgPicture.network(imageUrl, width: 64, placeholderBuilder: (BuildContext context) => const Center(child: CircularProgressIndicator(),));
        return IntrinsicHeight(
          child: Card(
            color: Colors.black87,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Center(child: image),
                  radius: 32,
                ),
                Container(
                  width: 200,
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(achievs[index].name ?? '', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),),
                      const SizedBox(height: 10,),
                      Text(achievs[index].description ?? '', style: const TextStyle(color: Colors.white54))
                    ],
                  ),
                )
                
              ],
            ),
          ),
        );
      }
    );
  }

  Widget _buildSkills() {
    CursusUsers? cursus;
    if (user.cursus_users != null) {
      for (CursusUsers c in user.cursus_users!) {
        if (c.end_at == null) {
          cursus = c;
        }
      }
    }
    if (cursus == null || cursus.skills == null) {
      return const Text('No skills yet');
    }
    List<Skills> skills = cursus.skills!;
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: skills.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          color: Colors.black87,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              children: [
                Text(skills[index].name ?? '', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),),
                const Text(' - '),
                Text(skills[index].level.toString(), style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.white54)),
              ],
            )
          )
        );
      }
    );
  }

  Widget _buildProjects() {
    final List<ProjectUser> projects = user.projects_users ?? [];
    if (projects.isEmpty) {
      return const Text("No projects done.");
    }
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: projects.length,
      itemBuilder: (BuildContext context, int index) {
        Color colorValidation = Colors.white54;
        String? projectUrl;

        if (projects[index].validated != null && projects[index].validated == true){
          colorValidation = Colors.teal;
        } else if (projects[index].validated != null && projects[index].validated == false) {
          colorValidation = const Color.fromARGB(255, 173, 0, 0);
        }

        if (user.projects_users != null && user.projects_users![index].project != null && user.projects_users![index].project!.slug != null) {
          projectUrl = 'https://projects.intra.42.fr/projects/' + user.projects_users![index].project!.slug!;
        }
        return Card(
          color: Colors.black87,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text((projects[index].project?.name ?? 'undefined'), style: TextStyle(fontWeight: FontWeight.bold, color: colorValidation),),
                Text(projects[index].status ?? 'unkown', style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.white54),),
                Text(projects[index].final_mark != null ? projects[index].final_mark.toString() + '%' : '', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: colorValidation),),
                projectUrl != null ? ElevatedButton(child: const Text('View project',), style: ElevatedButton.styleFrom(primary: const Color.fromARGB(255, 92, 92, 92)), onPressed: () async {
                  if (await canLaunch(projectUrl!)) {
                    if (!await launch(projectUrl)) {
                       ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Can\'t go to the 42 project page'))
                      );
                    }
                  }
                },) : const Text('Can\'t show project page'),
              ],
            ),
          ),
        );
      }
    );
  }

  Widget _buildHeader() {
    CursusUsers? cursus;
    if (user.cursus_users != null) {
      for (CursusUsers c in user.cursus_users!) {
        if (c.end_at == null) {
          cursus = c;
        }
      }
    }
    String nameRow = (user.first_name ?? '') + ' ' + (user.last_name ?? '') + ' - ' + (user.login?.toUpperCase() ?? '');
    String role = '-- STUDENT --';
    if (user.staff != null && user.staff == true) {
      nameRow = '[' + (user.first_name ?? '') + ' ' + (user.last_name ?? '') + ' - ' + (user.login?.toUpperCase() ?? '') + ']';
      role = '-- STAFF --';
    }
    return Container(
      color: Colors.black87,
      padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.transparent,
            backgroundImage: Image.network(
              user.image_url ?? 'https://i0.wp.com/sbcf.fr/wp-content/uploads/2018/03/sbcf-default-avatar.png?w=300&ssl=1', 
              width: 128,).image,
            radius: 64,
          ),
          const SizedBox(width: 15,),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15,),
              Text(role, style: const TextStyle(color: Colors.teal)),
              Row(
                children: [Text(nameRow, style: const TextStyle(color: Colors.white54),)],
              ),
              const SizedBox(height: 10,),
              Text(user.email ?? 'No email', style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.white30),),
              const SizedBox(height: 10,),
              Row(children: [
                Text('42 ' + user.campus![0].name! + ', ', style: const TextStyle(color: Colors.white54),),
                Text(user.campus![0].country!, style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.white54),),
                const Text(' - ', style: TextStyle(color: Colors.white54),),
                Text((user.location != null ? "At the `" + user.location!.toUpperCase() + '`' : 'Not logged'), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white54),),
              ],),
              const SizedBox(height: 10,),
              Row(
                children: [
                  Text(user.correction_point.toString() + ' evaluation points - ', style: const TextStyle(color: Colors.white54),),
                  Text(user.wallet.toString() + '₳', style: const TextStyle(color: Colors.white54),),
                ],
              ),
              const SizedBox(height: 10,),
              Text('${((cursus!.level! - cursus.level!.toInt()) * 100).round()}% of level ${cursus.level?.toInt()}', style: const TextStyle(color: Colors.white54, fontWeight: FontWeight.bold),),
            ],
          ),
        ],
      ),
    );
  }
}