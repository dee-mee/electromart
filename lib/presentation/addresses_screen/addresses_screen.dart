import 'package:flutter/material.dart';
import 'package:electromart/presentation/addresses_screen/address_form_screen.dart';

class Address {
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final String country;

  Address({
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
  });
}

class AddressesScreen extends StatefulWidget {
  const AddressesScreen({Key? key}) : super(key: key);

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  final List<Address> _addresses = [
    Address(
      street: '123 Main St',
      city: 'Anytown',
      state: 'CA',
      zipCode: '12345',
      country: 'USA',
    ),
    Address(
      street: '456 Oak Ave',
      city: 'Someville',
      state: 'NY',
      zipCode: '67890',
      country: 'USA',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Addresses'),
      ),
      body: ListView.builder(
        itemCount: _addresses.length,
        itemBuilder: (context, index) {
          final address = _addresses[index];
          return ListTile(
            title: Text(address.street),
            subtitle: Text('${address.city}, ${address.state} ${address.zipCode}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    final updatedAddress = await Navigator.of(context).push<Address>(
                      MaterialPageRoute(
                        builder: (context) => AddressFormScreen(address: address),
                      ),
                    );
                    if (updatedAddress != null) {
                      setState(() {
                        final index = _addresses.indexOf(address);
                        if (index != -1) {
                          _addresses[index] = updatedAddress;
                        }
                      });
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Address'),
                        content: const Text('Are you sure you want to delete this address?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _addresses.removeAt(index);
                              });
                              Navigator.of(context).pop();
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newAddress = await Navigator.of(context).push<Address>(
            MaterialPageRoute(
              builder: (context) => const AddressFormScreen(),
            ),
          );
          if (newAddress != null) {
            setState(() {
              _addresses.add(newAddress);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
