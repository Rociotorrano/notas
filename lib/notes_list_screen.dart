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
  Set<int> selectedNotes = {};
  bool _modoSeleccion = false;

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
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  // Activa o desactiva el modo de selección al tocar el botón de eliminar
                  _modoSeleccion = !_modoSeleccion;
                  if (!_modoSeleccion) {
                    // Elimina las notas seleccionadas cuando se desactiva el modo de selección
                    for (var index in selectedNotes.toList()) {
                      notes.removeAt(index);
                    }
                    // Limpia el conjunto de notas seleccionadas
                    selectedNotes.clear();
                  }
                });
              },
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
                return Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (_modoSeleccion) {
                          setState(() {
                            if (selectedNotes.contains(index)) {
                              selectedNotes.remove(index);
                            } else {
                              selectedNotes.add(index);
                            }
                          });
                        } else {
                          // Si no está en modo selección, abre la pantalla de detalles de la nota
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
                        }
                      },
                      child: Container(
                        width: double
                            .infinity, // Ajuste para que los contenedores sean más anchos
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(15.0),
                          color: selectedNotes.contains(index)
                              ? Colors.blue.withOpacity(
                                  0.5) // Color de fondo cuando está seleccionado
                              : null,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                notes[index].title,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0),
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
                    ),
                    if (_modoSeleccion)
                      Positioned(
                        top: 8.0,
                        right: 8.0,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              if (selectedNotes.contains(index)) {
                                selectedNotes.remove(index);
                              } else {
                                selectedNotes.add(index);
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: selectedNotes.contains(index)
                                  ? Colors.red
                                  : Colors.grey.withOpacity(0.5),
                            ),
                            width: 20,
                            height: 20,
                            alignment: Alignment.center,
                            child: selectedNotes.contains(index)
                                ? Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 15,
                                  )
                                : null,
                          ),
                        ),
                      ),
                  ],
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
