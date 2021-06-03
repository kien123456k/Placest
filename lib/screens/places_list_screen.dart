import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/add_place_screen.dart';
import '../screens/place_detail_screen.dart';
import '../providers/great_places.dart';
import '../helpers/custom_route.dart';

class PlacesListScreen extends StatelessWidget {
  Future<void> _refreshPlaces(BuildContext context) async {
    await Provider.of<GreatPleaces>(context, listen: false).fetchAndSetPlaces();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pleacest'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: _refreshPlaces(context),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<GreatPleaces>(
                child: Center(
                  child: Text('Got no places yet, start adding some!'),
                ),
                builder: (ctx, greatPlaces, ch) => greatPlaces.items.length <= 0
                    ? ch
                    : RefreshIndicator(
                        onRefresh: () => _refreshPlaces(context),
                        child: ListView.builder(
                          itemCount: greatPlaces.items.length,
                          itemBuilder: (ctx, index) => Card(
                            elevation: 4,
                            margin: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal:
                                  MediaQuery.of(context).size.width / 24,
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 8,
                              ),
                              leading: Hero(
                                tag: greatPlaces.items[index].id,
                                child: CircleAvatar(
                                  radius:
                                      MediaQuery.of(context).size.width / 10,
                                  backgroundImage: FileImage(
                                    greatPlaces.items[index].image,
                                  ),
                                ),
                              ),
                              title: Text(
                                greatPlaces.items[index].title,
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              subtitle: Text(
                                greatPlaces.items[index].location.address,
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              onTap: () {
                                Navigator.of(context).push(
                                  CustomMaterialPageRoute(
                                    builder: (ctx) => PlaceDetailScreen(),
                                    settings: RouteSettings(
                                      arguments: greatPlaces.items[index].id,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
              ),
      ),
    );
  }
}
