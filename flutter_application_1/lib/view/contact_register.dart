import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../model/contact.dart';

class ContactRegisterView extends StatefulWidget {
  const ContactRegisterView({super.key});

  @override
  _ContactRegisterViewState createState() => _ContactRegisterViewState();
}

class _ContactRegisterViewState extends State<ContactRegisterView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

  Future<void> _saveContact() async {
    final String name = _nameController.text;
    final double? latitude = double.tryParse(_latitudeController.text);
    final double? longitude = double.tryParse(_longitudeController.text);

    if (name.isNotEmpty && latitude != null && longitude != null) {
      Contact newContact = Contact(name: name, latitude: latitude, longitude: longitude);
      await DatabaseHelper.instance.insertContact(newContact);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Contato salvo!')));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Preencha todos os campos corretamente.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Adicionar Contato")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: "Nome")),
            TextField(controller: _latitudeController, decoration: const InputDecoration(labelText: "Latitude"), keyboardType: TextInputType.number),
            TextField(controller: _longitudeController, decoration: const InputDecoration(labelText: "Longitude"), keyboardType: TextInputType.number),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _saveContact, child: const Text("Salvar Contato")),
          ],
        ),
      ),
    );
  }
}
