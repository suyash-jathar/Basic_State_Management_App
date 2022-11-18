import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      // In routes keys are String and Values are functions  
      routes: {
        '/new-contact':(context)=> NewContactView(),
        }
    )
  );
}

class Contact{
  final String name;
  const Contact({required this.name});
}

// Vanilla Class and also Making Singleton Class
class ContactBook{
  ContactBook._sharedInstance();
  static final ContactBook _shared=ContactBook._sharedInstance();
  factory ContactBook() => _shared;

  final List<Contact> _contacts=[];
  int get length => _contacts.length;

  void add({required Contact contact})
  {
    _contacts.add(contact);
  }
  void remove({required Contact contact})
  {
    _contacts.remove(contact);
  }

// Gona used for adding it on specific index  
  Contact? contact({required int atIndex}){
    return _contacts.length>atIndex? _contacts[atIndex] :null;
  }

}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // contactBook will get initialized for only one time
    final contactBook=ContactBook();
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      body: ListView.builder(
      itemCount: contactBook.length,
      itemBuilder: ((context, index) {
        final contact=contactBook.contact(atIndex: index)!;
        return ListTile(
          title: Text(contact.name),
        );
      }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
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
    _controller=TextEditingController();
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
            onPressed: (){
              final contact=Contact(name: _controller.text);
              ContactBook().add(contact: contact);
              Navigator.of(context).pop();
            }, 
            child: Text("Add new Contacts"))

        ],
      ),
    );
  }
}