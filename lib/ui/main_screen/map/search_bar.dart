import 'package:avispets/models/events_response_model.dart';
import 'package:avispets/models/locations/get_location_name_address.dart';
import 'package:avispets/models/online_store_response_model.dart';
import 'package:avispets/ui/main_screen/map/google_maps_service.dart';
import 'package:avispets/utils/my_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/my_routes/route_name.dart';

class SearchingBar extends StatelessWidget {
  final Future<dynamic> Function(String) onChanged;
  final Function(dynamic) onPlaceSelected;
  final bool allowFilter;

  const SearchingBar({
    Key? key,
    required this.onChanged,
    required this.onPlaceSelected,
    this.allowFilter = true
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Color(0xffEBEBEB)),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(13),
              topRight:  Radius.circular(allowFilter ? 50 : 13),
              bottomLeft: Radius.circular(13),
              bottomRight: Radius.circular(allowFilter ? 50 : 13))),
      child: TextField(
        scrollPadding: const EdgeInsets.only(bottom: 50),
        readOnly: true,
        onTap: (){
          showSearch(
            context: context,
            delegate: PlaceSearchDelegate(
              onPlaceSelected: onPlaceSelected,
              onChanged: onChanged,
            ),
          );
        },
        style: TextStyle(color: MyColor.black, fontSize: 14),
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          prefixIcon: IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: PlaceSearchDelegate(
                    onPlaceSelected: onPlaceSelected,
                  onChanged: onChanged,
                ),
              );
            },
          ),
          suffixIcon: allowFilter ?
              GestureDetector(
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
                      child: Image.asset('assets/images/icons/filter.png'))) : null,
          contentPadding:
          const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
          hintText: 'search'.tr,
          hintStyle: TextStyle(color: MyColor.textBlack0, fontSize: 14),
        ),
        onChanged: (value) {},
      ),
    );
    //   Row(
    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //   children: [
    //     Container(
    //       decoration: BoxDecoration(
    //           border: Border.all(color: Color(0xffEBEBEB)),
    //           borderRadius: BorderRadius.circular(10)),
    //       child: IconButton(
    //         icon: const Icon(Icons.search),
    //         onPressed: () {
    //           showSearch(
    //             context: context,
    //             delegate: PlaceSearchDelegate(
    //                 onPlaceSelected: onPlaceSelected,
    //               onChanged: onChanged,
    //             ),
    //           );
    //         },
    //       ),
    //     ),
    //     GestureDetector(
    //         onTap: () {
    //           Navigator.pushNamed(context, RoutesName.filterScreen);
    //         },
    //         child: Container(
    //             width: 40,
    //             height: 40,
    //             padding: EdgeInsets.all(8),
    //             decoration: BoxDecoration(
    //                 color: Color(0xff4F2020),
    //                 borderRadius: BorderRadius.circular(150)),
    //             child: Image.asset('assets/images/icons/filter.png'))),
    //   ],
    // );
  }
}

class PlaceSearchDelegate extends SearchDelegate {
  final Function(dynamic) onPlaceSelected;
  final Future<dynamic> Function(String) onChanged;

  PlaceSearchDelegate({
    required this.onPlaceSelected,
    required this.onChanged,
  });

  Future<dynamic> _getSuggestions(String query) async {
    try {
      return await onChanged(query);
      // return await GoogleMapsService.getPlaceSuggestions(query);
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
    // onPlaceSelected(_selectedLocation!);
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: _getSuggestions(query),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());

        final suggestions = snapshot.data!;
        if(suggestions is List<LocationData>){
          return ListView.builder(
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: suggestions[index].profile != null
                    ? CircleAvatar(
                  backgroundImage: NetworkImage(suggestions[index].profile!),
                  radius: 20,
                )
                    : CircleAvatar(
                  radius: 20,
                  child: Icon(Icons.location_on, color: Colors.black), // Fallback icon
                ),
                title: Text('${suggestions[index].name!} ${suggestions[index].address!}'),
                onTap: () {
                  onPlaceSelected(suggestions[index]);
                  close(context, null);
                },
              );
            },
          );
        }
        else if(suggestions is List<EventsModel>){
          return ListView.builder(
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: suggestions[index].profile != null
                    ? CircleAvatar(
                  backgroundImage: NetworkImage(suggestions[index].profile!),
                  radius: 20,
                )
                    : CircleAvatar(
                  radius: 20,
                  child: Icon(Icons.location_on, color: Colors.white), // Fallback icon
                ),
                title: Text('${suggestions[index].name!}, ${suggestions[index].venue!}, ${suggestions[index].city}'),
                onTap: () {
                  onPlaceSelected(suggestions[index]);
                  close(context, null);
                },
              );
            },
          );
        }
        else if(suggestions is List<OnlineStoreModel>){
          return ListView.builder(
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: suggestions[index].profile != null
                    ? CircleAvatar(
                  backgroundImage: NetworkImage(suggestions[index].profile!),
                  radius: 20,
                )
                    : CircleAvatar(
                  radius: 20,
                  child: Icon(Icons.location_on, color: Colors.white), // Fallback icon
                ),
                title: Text('${suggestions[index].name!}, ${suggestions[index].address!}'),
                onTap: () {
                  onPlaceSelected(suggestions[index]);
                  close(context, null);
                },
              );
            },
          );
        }
        return SizedBox();
      },
    );
  }
}
