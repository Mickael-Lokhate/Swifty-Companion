import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:swifty_companion/model/user.dart';

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
          SizedBox(height: 100, child: _buildProjects()),
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
          SizedBox(height: 120, child: _buildAchievements()),
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
        return Card(
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Center(child: image),
                radius: 32,
              ),
              Column(
                children: [
                  Text(achievs[index].name ?? '', style: const TextStyle(fontWeight: FontWeight.bold),),
                  const SizedBox(height: 10,),
                  Text(achievs[index].description ?? '')
                ],
              )
            ],
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
          color: Colors.teal,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              children: [
                Text(skills[index].name ?? '', style: const TextStyle(fontWeight: FontWeight.bold),),
                const Text(' - '),
                Text(skills[index].level.toString(), style: const TextStyle(fontStyle: FontStyle.italic)),
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
        MaterialColor bgColor = Colors.grey;
        if (projects[index].validated != null && projects[index].validated == true){
          bgColor = Colors.green;
        } else if (projects[index].validated != null && projects[index].validated == false) {
          bgColor = Colors.red;
        }
        return Card(
          color: bgColor,
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text((projects[index].project?.name ?? 'undefined'), style: const TextStyle(fontWeight: FontWeight.bold),),
                Text(projects[index].status ?? 'unkown', style: const TextStyle(fontStyle: FontStyle.italic),),
                Text(projects[index].final_mark != null ? projects[index].final_mark.toString() + '%' : '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
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
              Row(
                children: [Text((user.first_name ?? '') + ' ' + (user.last_name ?? '') + ' - ' + (user.login?.toUpperCase() ?? ''), style: const TextStyle(color: Colors.white54),)],
              ),
              const SizedBox(height: 10,),
              Text(user.email ?? 'No email', style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.white30),),
              const SizedBox(height: 10,),
              Row(children: [
                Text('42 ' + user.campus![0].name! + ', ', style: const TextStyle(color: Colors.white54),),
                Text(user.campus![0].country!, style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.white54),),
                const Text(' - ', style: TextStyle(color: Colors.white54),),
                Text((user.location?.toUpperCase() ?? 'Not logged'), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white54),),
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