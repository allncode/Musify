import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myapp/songs.dart'; // Import your Album model
import '../widget.dart'; // Import your MyLibrary class or file

class BottomSheetHelper {
  static void showBottomSheet(BuildContext context, Album album) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: FaIcon(FontAwesomeIcons.circlePlus, color: Colors.white),
            title:
                Text('Add to Library', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              _showLibraryOptions(context, album);
            },
          ),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.circleInfo, color: Colors.white),
            title: Text('Song Details', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              _handleMenuSelection('Option2', album);
            },
          ),
        ],
      ),
    );
  }

  static void _showLibraryOptions(BuildContext context, Album album) {
    List<String> libraries =
        _getLibraries(); // Replace with your method to fetch libraries

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: libraries.isNotEmpty
            ? libraries
                .map((library) => ListTile(
                      title:
                          Text(library, style: TextStyle(color: Colors.white)),
                      onTap: () {
                        Navigator.pop(context);
                        _addToLibrary(library, album);
                      },
                    ))
                .toList()
            : [
                ListTile(
                  leading: FaIcon(FontAwesomeIcons.plus, color: Colors.white),
                  title: Text('Create New Library',
                      style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.pop(context);
                    _createNewLibrary(context, album);
                  },
                ),
              ],
      ),
    );
  }

  static List<String> _getLibraries() {
    // Replace with your implementation to fetch libraries from MyLibrary or SharedPreferences
    return []; // Example empty list, replace with actual data fetching
  }

  static void _addToLibrary(String library, Album album) {
    // Handle adding the album to the selected library
  }

  static void _createNewLibrary(BuildContext context, Album album) {
    // Show dialog to create a new library
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController controller = TextEditingController();
        return AlertDialog(
          title: Text('Create New Library'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Library Name'),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('Create'),
              onPressed: () {
                String newLibraryName = controller.text;
                if (newLibraryName.isNotEmpty) {
                  // Save the new library and add the album to it
                  _saveNewLibrary(newLibraryName);
                  Navigator.pop(context);
                  _addToLibrary(newLibraryName, album);
                }
              },
            ),
          ],
        );
      },
    );
  }

  static void _saveNewLibrary(String libraryName) {
    // Replace with your implementation to save the new library to MyLibrary or SharedPreferences
  }

  static void _handleMenuSelection(String value, Album album) {
    switch (value) {
      case 'Option1':
        // Handle Option 1 action
        break;
      case 'Option2':
        // Handle Option 2 action
        break;
      default:
        // Handle default case
        break;
    }
  }
}
