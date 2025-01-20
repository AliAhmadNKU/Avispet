
import 'package:avispets/ui/main_screen/map/google_maps_service.dart';
import 'package:flutter/material.dart';
import '../../../utils/my_routes/route_name.dart';

class SearchingBar extends StatelessWidget {
  final Function(String) onChanged;
  final Function(String) onPlaceSelected;

  const SearchingBar({
    Key? key,
    required this.onChanged,
    required this.onPlaceSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xffEBEBEB)),
              borderRadius: BorderRadius.circular(10)
          ),
          child: IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: PlaceSearchDelegate(onPlaceSelected: onPlaceSelected),
              );
            },
          ),
        ),GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, RoutesName.filterScreen);
          },

    child: Container(
    width: 40,
    height: 40,
    padding: EdgeInsets.all(8),
    decoration: BoxDecoration(
    color: Color(0xff4F2020),
    borderRadius: BorderRadius.circular(150)),
    child: Image.asset('assets/images/icons/filter.png'))),
      ],
    );
  }
}
class PlaceSearchDelegate extends SearchDelegate {
  final Function(String) onPlaceSelected;

  PlaceSearchDelegate({required this.onPlaceSelected});

  Future<List<String>> _getSuggestions(String query) async {
    try {
      return await GoogleMapsService.getPlaceSuggestions(query);
    } catch (e) {
      return [];
    }
  }
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    onPlaceSelected(query);
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _getSuggestions(query),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());

        final suggestions = snapshot.data!;
        return ListView.builder(
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(suggestions[index]),
              onTap: () {
                onPlaceSelected(suggestions[index]);
                close(context, null);
              },
            );
          },
        );
      },
    );
  }
}
