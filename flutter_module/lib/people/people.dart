import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_module/api/api_client.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_module/people/widgets/shimmer.dart';
import 'package:flutter_module/widget_extensions/widget_extensions.dart';
import 'package:intl/intl.dart';

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
  bool didFetchPerson = false;

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
      didFetchPerson = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(children: [
          Container(
            color: Colors.black,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.black,
                  expandedHeight: 300,
                  stretch: true,
                  flexibleSpace: FlexibleSpaceBar(
                    stretchModes: const [StretchMode.zoomBackground],
                    background: ProfileImage(
                      profilePath: profilePath,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ProfileText(name, fontSize: 24),
                      if (!didFetchPerson ||
                          (didFetchPerson && birthday != null)) ...[
                        const StaticText('Born', fontSize: 20).padOnly(top: 10),
                        ProfileText(_formatBirthday(birthday), fontSize: 18),
                      ],
                      const StaticText('Place of Birth', fontSize: 20)
                          .padOnly(top: 10),
                      ProfileText(birthPlace, fontSize: 18),
                      const StaticText('Biography', fontSize: 20)
                          .padOnly(top: 10),
                      ProfileText(biography, fontSize: 18)
                          .padOnly(top: 10)
                          .padOnly(bottom: 20),
                    ],
                  ).padAll(20),
                )
              ],
            ),
          ),
          const Toolbar()
        ]),
      ),
    );
  }

  String? _formatBirthday(String? birthday) {
    if (birthday != null) {
      DateTime dateTime = DateTime.parse(birthday);
      return DateFormat('MMMM d, yyyy').format(dateTime);
    } else {
      return null;
    }
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
        progressIndicatorBuilder: (context, url, progress) =>
            const ShimmerView.rectangular(height: 300),
        errorWidget: (context, url, error) => const Icon(Icons.error),
        fit: BoxFit.fitWidth,
      );
    } else {
      return const ShimmerView.rectangular(height: 300);
    }
  }
}

class ProfileText extends StatelessWidget {
  const ProfileText(this.text,
      {super.key, required this.fontSize, this.fontWeight});

  final String? text;
  final double fontSize;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    if (text != null) {
      return Text(
        text!,
        style: TextStyle(
            fontFamily: 'HelveticaNeue',
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: Colors.grey[350]),
      );
    } else {
      return const ShimmerView.rectangular(height: 50)
          .padSymmetric(vertical: 10, horizontal: 0);
    }
  }
}

class StaticText extends StatelessWidget {
  const StaticText(this.text, {super.key, required this.fontSize});

  final String text;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontFamily: 'HelveticaNeue',
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white),
    );
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
