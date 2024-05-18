import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_module/api/api_client.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_module/people/widgets/shimmer.dart';
import 'package:flutter_module/widget_extensions/widget_extensions.dart';

class PeoplePage extends StatefulWidget {
  const PeoplePage({super.key, required this.id});

  final int id;

  @override
  State<PeoplePage> createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  String? name;
  String? birthday;
  String? biography;
  String? birthPlace;
  String? profilePath;

  final _apiClient = ApiClientLive.live;

  @override
  void initState() {
    super.initState();
    getPeople(widget.id);
  }

  void getPeople(int id) async {
    final person = await _apiClient.getDetails(id);
    setState(() {
      name = person.name;
      birthday = person.birthday;
      biography = person.biography;
      birthPlace = person.birthPlace;
      profilePath = person.profilePath;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ProfileImage(profilePath: profilePath),
                ProfileText(name, fontSize: 20),
                ProfileText(birthday, fontSize: 18),
                ProfileText(birthPlace, fontSize: 18),
                ProfileText(biography, fontSize: 15),
              ],
            ),
          ),
          const Toolbar()
        ]),
      ),
    );
  }
}

class ProfileImage extends StatelessWidget {
  const ProfileImage({
    super.key,
    required this.profilePath,
  });

  final String? profilePath;

  @override
  Widget build(BuildContext context) {
    if (profilePath != null) {
      return CachedNetworkImage(
        imageUrl: 'https://image.tmdb.org/t/p/w1280/$profilePath',
        progressIndicatorBuilder: (context, url, downloadProgress) =>
            CircularProgressIndicator(value: downloadProgress.progress),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      );
    } else {
      return const CircularProgressIndicator();
    }
  }
}

class ProfileText extends StatelessWidget {
  const ProfileText(this.text, {super.key, required this.fontSize});

  final String? text;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    if (text != null) {
      // return Text(
      //   text!,
      //   style: TextStyle(fontSize: fontSize),
      // );
      return const ShimmerView.rectangular(height: 30)
          .padSymmetric(vertical: 10, horizontal: 30);
    } else {
      return const ShimmerView.rectangular(height: 30)
          .padSymmetric(vertical: 10, horizontal: 30);
    }
  }
}

/* Toolbar */
class Toolbar extends StatelessWidget {
  const Toolbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        children: [
          const Spacer(),
          Stack(alignment: Alignment.center, children: [
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.black.withOpacity(0.4)),
            ),
            IconButton(
              onPressed: () => SystemNavigator.pop(animated: true),
              icon: const Icon(
                Icons.close,
                color: Colors.white,
                size: 30,
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
