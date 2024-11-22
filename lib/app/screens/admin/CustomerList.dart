import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shimmer/shimmer.dart';
import '../../../utils/theme.dart';

class CustomerListScreen extends StatefulWidget {
  @override
  _CustomerListScreenState createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  List<Map<String, dynamic>> customers = [];
  List<Map<String, dynamic>> filteredCustomers = [];
  TextEditingController _searchController = TextEditingController();

  // Fetch customer details from Firebase
  Future<List<Map<String, dynamic>>> fetchCustomerDetails() async {
    try {
      final customerSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'customer')
          .get();

      return customerSnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error fetching customer data: $e');
      return [];
    }
  }

  // Filter customers based on search query
  void _filterCustomers(String query) {
    setState(() {
      filteredCustomers = customers.where((customer) {
        String customerName =
            customer['name'] ?? ''; // Default to empty string if null
        String customerEmail =
            customer['email'] ?? ''; // Default to empty string if null

        return customerName.toLowerCase().contains(query.toLowerCase()) ||
            customerEmail.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchCustomerDetails().then((customerData) {
      setState(() {
        customers = customerData;
        filteredCustomers = customerData; // Initially show all customers
      });
    });

    _searchController.addListener(() {
      _filterCustomers(_searchController.text); // Apply filter as text changes
    });
  }

  // Shimmer Effect for loading
  Widget _buildShimmer() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: ListTile(
            title: Container(
              color: Colors.white,
              height: 20,
              width: double.infinity,
            ),
            subtitle: Container(
              color: Colors.white,
              height: 15,
              width: double.infinity,
            ),
            leading: Container(
              color: Colors.white,
              width: 40,
              height: 40,
            ),
          ),
        );
      },
    );
  }

  // Suggestions list below the search field
  Widget _buildSuggestions() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: filteredCustomers.length,
      itemBuilder: (context, index) {
        final customer = filteredCustomers[index];
        final customerName = customer['name'] ?? 'No Name';
        final customerEmail = customer['email'] ?? 'No Email';

        return ListTile(
          title: Text(
            customerName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primary, // Primary color for the text
            ),
          ),
          subtitle: Text(
            customerEmail,
            style: TextStyle(color: Colors.black87), // Normal text color
          ),
          leading: Icon(Icons.person,
              size: 40, color: AppColors.primary), // Primary color for the icon
          onTap: () {
            // Navigate to customer detail screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CustomerDetailScreen(
                    customerId:
                        customer['email']), // Passing email instead of ID
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white, // Set foreground color to white
        title: Text('Customer List'),
        centerTitle: true, // Center the title
        backgroundColor:
            AppColors.primary, // Use the primary color from the theme
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search,
                    color: AppColors.primary), // Use primary color for the icon
              ),
            ),
          ),
          Expanded(
            child: customers.isEmpty
                ? _buildShimmer() // Show shimmer while loading
                : filteredCustomers.isEmpty
                    ? Center(child: Text("No matching customers found."))
                    : _buildSuggestions(), // Show suggestions as user types
          ),
        ],
      ),
    );
  }
}

class CustomerDetailScreen extends StatefulWidget {
  final String customerId;

  CustomerDetailScreen({required this.customerId});

  @override
  _CustomerDetailScreenState createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  Map<String, dynamic>? customerDetails;

  // Fetch customer details by email
  Future<void> fetchCustomerDetail() async {
    try {
      final customerSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: widget.customerId) // Fetch by email
          .limit(1)
          .get();

      if (customerSnapshot.docs.isNotEmpty) {
        setState(() {
          customerDetails =
              customerSnapshot.docs.first.data() as Map<String, dynamic>;
        });
      }
    } catch (e) {
      print('Error fetching customer details: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCustomerDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Details'),
        backgroundColor: AppColors.primary, // Primary color from the theme
        foregroundColor: Colors.white, // Set foreground color to white
        centerTitle: true, // Center the title
      ),
      body: customerDetails == null
          ? Center(child: CircularProgressIndicator()) // Loading state
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ensure no null values for name, email, and phone
                  Text(
                    'Name: ${customerDetails!['name'] ?? 'No Name Available'}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Email: ${customerDetails!['email'] ?? 'No Email Available'}',
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Phone: ${customerDetails!['phone'] ?? 'No Phone Available'}',
                  ),
                  SizedBox(height: 10),
                  // Add more fields if needed, ensuring null values are handled
                ],
              ),
            ),
    );
  }
}
