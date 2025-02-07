import 'package:flutter/material.dart';
import 'package:imnote_app/services/firestore_service.dart';

class DetailNoteScreen extends StatefulWidget {
  final String docID; // Tambahkan docID untuk update ke Firestore
  final String noteText;

  const DetailNoteScreen(
      {super.key, required this.docID, required this.noteText});

  @override
  State<DetailNoteScreen> createState() => _DetailNoteScreenState();
}

class _DetailNoteScreenState extends State<DetailNoteScreen> {
  final FirestoreService cloudStoreService = FirestoreService();
  late TextEditingController _controller;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.noteText);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = true;
    });
  }

  void _saveNote() {
    if (_controller.text.isNotEmpty) {
      cloudStoreService.updateNote(widget.docID, _controller.text);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.white,
          content: Text(
            'Note Update Success!',
            style: TextStyle(color: Colors.black),
          ),
          duration: Duration(seconds: 1)));
    }

    setState(() {
      _isEditing = false;
    });

    // Menutup keyboard
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_isEditing) _saveNote();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Save Icon
                      IconButton(
                        onPressed: _saveNote,
                        icon: const Icon(Icons.save_outlined,
                            color: Colors.white),
                      ),

                      // Undo & Redo
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {}, // Implement Undo
                            icon: const Icon(Icons.undo, color: Colors.white),
                          ),
                          IconButton(
                            onPressed: () {}, // Implement Redo
                            icon: const Icon(Icons.redo, color: Colors.white),
                          ),
                        ],
                      ),

                      // Share
                      IconButton(
                        onPressed: () {}, // Implement Share
                        icon: const Icon(Icons.share, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),

              // Editable Note Area
              Expanded(
                child: GestureDetector(
                  onTap: _toggleEditing,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: _isEditing
                          ? TextField(
                              controller: _controller,
                              autofocus: true,
                              maxLines: null,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                              onSubmitted: (_) =>
                                  _saveNote(), // Simpan otomatis saat selesai mengetik
                            )
                          : Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                _controller.text.isEmpty
                                    ? "Tap to edit..."
                                    : _controller.text,
                                style: TextStyle(
                                  color: _controller.text.isEmpty
                                      ? Colors.grey
                                      : Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
