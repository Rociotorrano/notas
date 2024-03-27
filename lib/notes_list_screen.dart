import 'package:flutter/material.dart';
import 'note.dart';
import 'note_detail_screen.dart';

class NotesListScreen extends StatefulWidget {
  @override
  _NotesListScreenState createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  List<Note> notes = [
    Note(title: 'Nota 1', content: 'Contenido de la nota 1'),
    Note(title: 'Nota 2', content: 'Contenido de la nota 2'),
  ];

  ThemeMode _themeMode = ThemeMode.light; // Modo claro por defecto
  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(), // Tema claro por defecto
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(), // Tema oscuro por defecto
      themeMode: _themeMode,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Todas las Notas',
            style: TextStyle(fontSize: 24.0),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.lightbulb),
              onPressed: _toggleTheme,
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NoteDetailScreen(
                          note: notes[index],
                          isDarkMode: _themeMode == ThemeMode.dark,
                        ),
                      ),
                    ).then((value) {
                      if (value != null && value is Note) {
                        setState(() {
                          notes[index] = value;
                        });
                      }
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notes[index].title,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18.0),
                          ),
                          SizedBox(height: 8.0),
                          Text(notes[index].content,
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15.0,
                              )),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final newNote = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NoteDetailScreen(
                  isDarkMode: _themeMode == ThemeMode.dark,
                ),
              ),
            );
            if (newNote != null && newNote is Note) {
              setState(() {
                notes.add(newNote);
              });
            }
          },
          child: Icon(Icons.border_color),
        ),
      ),
    );
  }
}
