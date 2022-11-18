import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      // In routes keys are String and Values are functions
      routes: {
        '/new-contact': (context) => NewContactView(),
      }));
}

class Contact {
  final String id;
  final String name;
  Contact({required this.name}) : id = Uuid().v4();
}

// Vanilla Class and also Making Singleton Class
class ContactBook extends ValueNotifier<List<Contact>> {
  //Currently Managing Empty List
  ContactBook._sharedInstance() : super([]);

  static final ContactBook _shared = ContactBook._sharedInstance();
  factory ContactBook() => _shared;

  int get length => value.length;

  /// When the value is replaced with something that is not equal to the old
  /// value as evaluated by the equality operator ==, this class notifies its
  /// listeners.So --> value.add(contact); --> linew don't work here
  void add({required Contact contact}) {
    // value.add(contact);
    final contacts=value;
    contacts.add(contact);
    // value=contacts; not reqired currently because it manages by it own
    notifyListeners();
    // Here first we store the value then we add contact value to
    // it and added notifylisterner to it
    // Example -> if we take value as array first we take the reference then 
    // we add the number and again we reasign it to value of ValueNotifier and 
    // then we add notifylistner.
    // We can also write it as -: 
    //          value.add(contacts);
    //          notifyListners();
  }

  void remove({required Contact contact}) {
    // _contacts.remove(contact);
    final contacts=value;
    if(contacts.contains(contact)){
      contacts.remove(contact);
      // value=contacts; Again here we don;t needed 
      notifyListeners();
    }
  }

// Gona used for adding it on specific index
  Contact? contact({required int atIndex}) {
    return value.length > atIndex ? value[atIndex] : null;
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // contactBook will get initialized for only one time
    // final contactBook = ContactBook();
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      body: ValueListenableBuilder(
        valueListenable: ContactBook(),
        builder: ((contact, value, child) {
          final contacts=value as List<Contact>;
          return ListView.builder(
          itemCount: contacts.length,
          itemBuilder: ((context, index) {
            final contact = contacts[index];
            return Dismissible(
              onDismissed: (direction){
                // contacts.remove(contact); Or
                ContactBook().remove(contact: contact);  
              },
              key: ValueKey(contact.id),
              child: Material(
                color: Colors.white,
                elevation: 6,
                child: ListTile(
                  title: Text(contact.name),
                ),
              ),
            );
          }),
        );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).pushNamed('/new-contact');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class NewContactView extends StatefulWidget {
  const NewContactView({Key? key}) : super(key: key);

  @override
  State<NewContactView> createState() => _NewContactViewState();
}

class _NewContactViewState extends State<NewContactView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("add a New contact"),
      ),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Enter a New Name',
            ),
          ),
          TextButton(
              onPressed: () {
                final contact = Contact(name: _controller.text);
                ContactBook().add(contact: contact);
                Navigator.of(context).pop();
              },
              child: Text("Add new Contacts"))
        ],
      ),
    );
  }
}
