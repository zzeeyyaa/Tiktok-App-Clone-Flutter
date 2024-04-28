import 'package:flutter/material.dart' hide SearchController;
import 'package:get/get.dart';
import 'package:tiktok_app_clone_flutter/core/res/app_colors.dart';
import 'package:tiktok_app_clone_flutter/src/controller/search_controller.dart';
import 'package:tiktok_app_clone_flutter/src/model/user.dart';
import 'package:tiktok_app_clone_flutter/src/view/home/profile/profile_view.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  SearchController searchController = Get.put(SearchController());
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          titleSpacing: 6,
          backgroundColor: Colors.black,
          title: Padding(
            padding: const EdgeInsets.all(20),
            child: TextFormField(
              onTapOutside: (event) {
                FocusScope.of(context).unfocus();
              },
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: AppColors.primaryColor, width: 2),
                  borderRadius: BorderRadius.circular(6),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: AppColors.primaryColor, width: 2),
                  borderRadius: BorderRadius.circular(6),
                ),
                hintText: 'Search here...',
                hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
              ),
              onFieldSubmitted: (value) {
                searchController.searchForUser(value);
              },
              // onFieldSubmitted: ,
            ),
          ),
          actions: [
            if (searchController.usersSearchedList.isNotEmpty)
              Padding(
                  padding: const EdgeInsets.only(right: 24),
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          searchController.removeAllSearchedUser();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text('Clear All')))
          ],
        ),
        body: searchController.usersSearchedList.isEmpty
            ? Center(
                child: Opacity(
                  opacity: 0.35,
                  child: Image.asset(
                    'assets/icons/try.png',
                    width: 110,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: searchController.usersSearchedList.length,
                itemBuilder: (context, index) {
                  User eachSearchedUserRecord =
                      searchController.usersSearchedList[index];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                    child: Card(
                      child: InkWell(
                        onTap: () {
                          Get.to(ProfileView(
                              visitUserID:
                                  eachSearchedUserRecord.uid.toString()));
                        },
                        borderRadius: BorderRadius.circular(10),
                        splashColor: AppColors.primaryColor,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                eachSearchedUserRecord.image.toString()),
                          ),
                          title: Text(
                            eachSearchedUserRecord.name.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            eachSearchedUserRecord.email.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              setState(() {
                                searchController.removeSearchedUser(index);
                              });
                            },
                            icon: const Icon(
                              Icons.close,
                              size: 24,
                              color: Colors.redAccent,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      );
    });
  }
}
