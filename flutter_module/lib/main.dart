import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_module/API/api_client.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/people?id=108',
      onGenerateRoute: _onGenerateRoute,
    );
  }

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    final Uri uri = Uri.parse(settings.name ?? '');
    final path = uri.path;
    final queryParams = uri.queryParameters;

    switch (path) {
      case '/people':
        final id = int.tryParse(queryParams['id'] ?? '') ?? 0;
        return MaterialPageRoute(
            builder: (_) => PeoplePage(
                  id: id,
                ));
      default:
        return MaterialPageRoute(
            builder: (_) => const PeoplePage(
                  id: 108,
                ));
    }
  }
}

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
                profileImage(),
                name == null
                    ? const CircularProgressIndicator()
                    : Text(
                        'Name: $name',
                        style: const TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                birthday == null
                    ? const CircularProgressIndicator()
                    : Text(
                        'Birthday: $birthday',
                        style: const TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                birthPlace == null
                    ? const CircularProgressIndicator()
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: Text(
                          'Place of Birth: $birthPlace',
                          style: const TextStyle(
                            fontSize: 19.0,
                          ),
                        ),
                      ),
                biography == null
                    ? const CircularProgressIndicator()
                    : Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          'Biography: $biography',
                          style: const TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                      ),
              ],
            ),
          ),
          SafeArea(
            child: Row(
              children: [
                const Spacer(),
                IconButton(
                  onPressed: () => SystemNavigator.pop(animated: true),
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }

  Widget profileImage() {
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
