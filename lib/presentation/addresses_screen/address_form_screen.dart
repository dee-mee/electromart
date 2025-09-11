import 'package:flutter/material.dart';
import 'package:electromart/presentation/addresses_screen/addresses_screen.dart';

class AddressFormScreen extends StatefulWidget {
  final Address? address;

  const AddressFormScreen({Key? key, this.address}) : super(key: key);

  @override
  State<AddressFormScreen> createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends State<AddressFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _countryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.address != null) {
      _streetController.text = widget.address!.street;
      _cityController.text = widget.address!.city;
      _stateController.text = widget.address!.state;
      _zipCodeController.text = widget.address!.zipCode;
      _countryController.text = widget.address!.country;
    }
  }

  @override
  void dispose() {
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.address == null ? 'Add Address' : 'Edit Address'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _streetController,
                decoration: const InputDecoration(labelText: 'Street'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the street';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(labelText: 'City'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the city';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _stateController,
                decoration: const InputDecoration(labelText: 'State'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the state';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _zipCodeController,
                decoration: const InputDecoration(labelText: 'Zip Code'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the zip code';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _countryController,
                decoration: const InputDecoration(labelText: 'Country'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the country';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final resultAddress = Address(
                      street: _streetController.text,
                      city: _cityController.text,
                      state: _stateController.text,
                      zipCode: _zipCodeController.text,
                      country: _countryController.text,
                    );
                    Navigator.of(context).pop(resultAddress);
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
