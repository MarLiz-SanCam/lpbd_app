import 'package:flutter/material.dart';

class AddOrderForm extends StatefulWidget {
  @override
  _AddOrderFormState createState() => _AddOrderFormState();
}

class _AddOrderFormState extends State<AddOrderForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> _services = [];
  final TextEditingController _serviceController = TextEditingController();

  void _addService() {
    if (_serviceController.text.isNotEmpty) {
      setState(() {
        _services.add(_serviceController.text);
        _serviceController.clear();
      });
    }
  }

  void _submitOrder() {
    if (_formKey.currentState!.validate()) {
      // Process the order
      print('Order submitted with services: $_services');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Order'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Customer Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a customer name';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Customer Contact'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a customer contact';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _serviceController,
                decoration: InputDecoration(labelText: 'Service'),
              ),
              ElevatedButton(
                onPressed: _addService,
                child: Text('Add Service'),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _services.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_services[index]),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: _submitOrder,
                child: Text('Submit Order'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}