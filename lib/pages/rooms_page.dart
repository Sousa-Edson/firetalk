import 'package:flutter/material.dart';
import 'chat_page.dart';
import '../services/firestore_service.dart';

class RoomsPage extends StatefulWidget {
  const RoomsPage({super.key});

  @override
  State<RoomsPage> createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  final FirestoreService _firestoreService = FirestoreService();

  void _createRoom() async {
    final roomName = await showDialog<String>(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('Nova Sala'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Nome da sala'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, controller.text.trim()),
              child: const Text('Criar'),
            ),
          ],
        );
      },
    );

    if (roomName != null && roomName.isNotEmpty) {
      await _firestoreService.createRoom(roomName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Salas do FireTalk')),
      body: StreamBuilder<List<String>>(
        stream: _firestoreService.getRooms(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          final rooms = snapshot.data ?? [];

          if (rooms.isEmpty) {
            return const Center(child: Text('Nenhuma sala disponível.'));
          }

          return ListView.builder(
            itemCount: rooms.length,
            itemBuilder: (context, index) {
              final roomName = rooms[index];
              return ListTile(
                title: Text(roomName),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatPage(roomName: roomName),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      // Aqui está o FAB
      floatingActionButton: FloatingActionButton(
        onPressed: _createRoom,
        child: const Icon(Icons.add),
        tooltip: 'Criar nova sala',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
