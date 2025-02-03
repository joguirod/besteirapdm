import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../model/contact.dart';

class ContactRegisterView extends StatefulWidget {
  final Contact? contact;
  const ContactRegisterView({super.key, this.contact});

  @override
  _ContactRegisterViewState createState() => _ContactRegisterViewState();
}

class _ContactRegisterViewState extends State<ContactRegisterView> {
  late TextEditingController _nameController;
  late TextEditingController _latitudeController;
  late TextEditingController _longitudeController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.contact?.name ?? "");
    _latitudeController = TextEditingController(text: widget.contact?.latitude?.toString() ?? "");
    _longitudeController = TextEditingController(text: widget.contact?.longitude?.toString() ?? "");
  }

  Future<void> _saveContact() async {
    String name = _nameController.text;
    double? latitude = double.tryParse(_latitudeController.text);
    double? longitude = double.tryParse(_longitudeController.text);

    if (name.isNotEmpty && latitude != null && longitude != null) {
      Contact newContact = Contact(
        id: widget.contact?.id, // Mantém o ID se for uma edição
        name: name,
        latitude: latitude,
        longitude: longitude,
      );

      if (widget.contact == null) {
        await DatabaseHelper.instance.insertContact(newContact);
      } else {
        await DatabaseHelper.instance.updateContact(newContact);
      }

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
