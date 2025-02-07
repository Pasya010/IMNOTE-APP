import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:imnote_app/screens/addnote_screen.dart';
import 'package:imnote_app/screens/detail_note_screen.dart';
import 'package:imnote_app/services/firestore_service.dart';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService firestoreService = FirestoreService();

  Color getRandomPastelColor() {
    final Random random = Random();
    return Color.fromRGBO(
      200 + random.nextInt(56), // Red (200-255)
      200 + random.nextInt(56), // Green (200-255)
      200 + random.nextInt(56), // Blue (200-255)
      1, // Opacity
    );
  }

  void _showPopupMenu(
      BuildContext context, String docID, String noteText, Offset tapPosition) {
    showMenu(
      color: Colors.black,
      context: context,
      position: RelativeRect.fromLTRB(
        tapPosition.dx,
        tapPosition.dy,
        tapPosition.dx + 1,
        tapPosition.dy + 1,
      ),
      items: [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.edit, color: Colors.blue),
              SizedBox(width: 8),
              Text(
                'Edit',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(Icons.delete, color: Colors.red),
              SizedBox(width: 8),
              Text(
                'Delete',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value == 'delete') {
        firestoreService.deleteNote(docID);
      } else if (value == 'edit') {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              DetailNoteScreen(docID: docID, noteText: noteText),
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Search Bar yang selalu tetap di atas
            SliverPersistentHeader(
              pinned: true, // Tetap di atas saat di-scroll
              floating: false,
              delegate: _SearchBarDelegate(),
            ),

            // List Notes
            StreamBuilder(
              stream: firestoreService.getNotesStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                        child: Text('No Notes',
                            style: TextStyle(color: Colors.white))),
                  );
                }

                final noteList = snapshot.data!.docs;

                return SliverPadding(
                  padding: EdgeInsets.all(8.0),
                  sliver: SliverMasonryGrid.count(
                    crossAxisCount: 2,
                    childCount: noteList.length,
                    itemBuilder: (context, index) {
                      final document = noteList[index];
                      final data = document.data() as Map<String, dynamic>;
                      final noteText = data['note'] ?? '';

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailNoteScreen(
                                docID: document.id,
                                noteText: noteText,
                              ),
                            ),
                          );
                        },
                        onLongPressStart: (details) {
                          _showPopupMenu(context, document.id, noteText,
                              details.globalPosition);
                        },
                        child: Container(
                          margin: EdgeInsets.all(8.0),
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: getRandomPastelColor(),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Text(
                            noteText,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 5,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w400),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: Icon(Icons.add, color: Colors.black),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) {
              return DraggableScrollableSheet(
                initialChildSize: 0.8,
                minChildSize: 0.7,
                maxChildSize: 0.9,
                expand: false,
                builder: (context, scrollController) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20.0)),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 5,
                            width: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        Expanded(child: AddnoteScreen()),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

// Kelas Delegate untuk Search Bar
class _SearchBarDelegate extends SliverPersistentHeaderDelegate {
  @override
  double get minExtent => 70; // Ukuran minimum search bar
  @override
  double get maxExtent => 70; // Ukuran maksimum search bar

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.black,
      padding: EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.center,
      child: TextField(
        decoration: InputDecoration(
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.move_up_outlined, color: Colors.white),
                SizedBox(width: 10),
                CircleAvatar(radius: 16),
              ],
            ),
          ),
          hintText: 'Search your notes',
          hintStyle: TextStyle(color: Colors.white, fontSize: 14),
          prefixIcon: Icon(Icons.menu, color: Colors.white),
          filled: true,
          fillColor: Colors.grey.shade800,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
