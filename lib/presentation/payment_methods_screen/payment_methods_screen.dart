import 'package:flutter/material.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({Key? key}) : super(key: key);

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  final List<String> _paymentMethods = ['Mpesa STK Push'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Methods'),
      ),
      body: ListView.builder(
        itemCount: _paymentMethods.length,
        itemBuilder: (context, index) {
          final method = _paymentMethods[index];
          return ListTile(
            title: Text(method),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Payment Method'),
                    content: const Text('Are you sure you want to delete this payment method?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _paymentMethods.removeAt(index);
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
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showMpesaPhoneNumberDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showMpesaPhoneNumberDialog(BuildContext context) {
    final TextEditingController _phoneNumberController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter Mpesa Phone Number'),
        content: TextField(
          controller: _phoneNumberController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Phone Number',
            hintText: 'e.g., 254712345678',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final phoneNumber = _phoneNumberController.text;
              if (phoneNumber.isNotEmpty) {
                // In a real application, you would send this phone number to your backend
                // to initiate the Mpesa STK Push. For now, we'll just simulate it.
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Initiating Mpesa STK Push for $phoneNumber...'),
                  ),
                );
                Navigator.of(context).pop();
              }
            },
            child: const Text('Initiate STK Push'),
          ),
        ],
      ),
    );
  }
}
