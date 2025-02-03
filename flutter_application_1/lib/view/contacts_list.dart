import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../model/contact.dart';
import 'contact_register.dart';

class ContactsListView extends StatefulWidget {
  const ContactsListView({super.key});

  @override
  _ContactsListViewState createState() => _ContactsListViewState();
}

class _ContactsListViewState extends State<ContactsListView> {
  late Future<List<Contact>> _contacts;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  void _loadContacts() {
    setState(() {
      _contacts = DatabaseHelper.instance.getAllContacts();
    });
  }

  void _deleteContact(int id) async {
    await DatabaseHelper.instance.deleteContact(id);
    _loadContacts();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Contato removido!")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Contatos")),
      body: FutureBuilder<List<Contact>>(
        future: _contacts,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.isEmpty) {
            return const Center(child: Text("Nenhum contato cadastrado."));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Contact contact = snapshot.data![index];
              return ListTile(
                title: Text(contact.name),
                subtitle: Text("Lat: ${contact.latitude}, Lng: ${contact.longitude}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: const Icon(Icons.edit), onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ContactRegisterView(contact: contact)),
                      ).then((_) => _loadContacts());
                    }),
                    IconButton(icon: const Icon(Icons.delete), onPressed: () => _deleteContact(contact.id!)),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ContactRegisterView()),
          ).then((_) => _loadContacts());
        },
      ),
    );
  }
}
