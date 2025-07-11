import 'package:flutter/material.dart';
import '../models/bike_model.dart';
import '../data/bike_data.dart';

class BicycleSelectionScreen extends StatefulWidget {
  const BicycleSelectionScreen({super.key});

  @override
  State<BicycleSelectionScreen> createState() => _BicycleSelectionScreenState();
}

class _BicycleSelectionScreenState extends State<BicycleSelectionScreen> {
  List<BikeModel> bikes = [];
  int _selectedIndex = 2;

  @override
  void initState() {
    super.initState();
    bikes = BikeData.getAllBikes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        elevation: 0,
        title: const Text(
          'Choose Your\nBicycle',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 15),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {
                // Handle search
              },
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
              Color(0xFF0F3460),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 0.75,
            ),
            itemCount: bikes.length,
            itemBuilder: (context, index) {
              return _buildBikeCard(bikes[index]);
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF16213E),
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          if (index == 0) {
            Navigator.popUntil(context, (route) => route.isFirst);
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Rentals',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_bike),
            label: 'Bikes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildBikeCard(BikeModel bike) {
    bool isAvailable = bike.isAvailable;
    
    return GestureDetector(
      onTap: isAvailable ? () {
        _showBikeDetails(bike);
      } : null,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isAvailable 
              ? [
                  const Color(0xFF4A90E2),
                  const Color(0xFF357ABD),
                ]
              : [
                  Colors.grey.shade600,
                  Colors.grey.shade700,
                ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bike Image
              Expanded(
                flex: 4,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isAvailable ? Colors.white.withOpacity(0.1) : Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: _getBikeImage(bike, isAvailable),
                ),
              ),
              const SizedBox(height: 12),
              // Bike Info
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bike.fullName,
                      style: TextStyle(
                        color: isAvailable ? Colors.white : Colors.grey.shade400,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '\$${bike.pricePerHour.toStringAsFixed(2)}/hr',
                      style: TextStyle(
                        color: isAvailable ? Colors.white : Colors.grey.shade400,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Quantity Display
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: isAvailable ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${bike.availableCount}/${bike.totalCount}',
                            style: TextStyle(
                              color: isAvailable ? Colors.green.shade200 : Colors.red.shade200,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Icon(
                          Icons.circle,
                          size: 8,
                          color: isAvailable ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            isAvailable ? 'Available' : 'All Rented',
                            style: TextStyle(
                              color: isAvailable ? Colors.white70 : Colors.grey.shade400,
                              fontSize: 10,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getBikeImage(BikeModel bike, bool isAvailable) {
    // Using styled bike icons with different styles for each type
    IconData bikeIcon;
    Color iconColor = isAvailable ? Colors.white : Colors.grey.shade400;
    
    switch (bike.type.name) {
      case 'mountain':
        bikeIcon = Icons.terrain; // Mountain bike icon
        break;
      case 'road':
        bikeIcon = Icons.directions_bike; // Road bike icon
        break;
      case 'electric':
        bikeIcon = Icons.electric_bike; // Electric bike icon
        break;
      case 'hybrid':
        bikeIcon = Icons.pedal_bike; // Hybrid bike icon
        break;
      default:
        bikeIcon = Icons.directions_bike;
    }

    return Center(
      child: Icon(
        bikeIcon,
        size: 60,
        color: iconColor,
      ),
    );
  }

  void _showBikeDetails(BikeModel bike) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bike Image in Modal
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: _getBikeGradient(bike.type.name),
                borderRadius: BorderRadius.circular(15),
              ),
              child: _getBikeImage(bike, true),
            ),
            const SizedBox(height: 15),
            Text(
              bike.fullName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Location: ${bike.location}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Price: \$${bike.pricePerHour.toStringAsFixed(2)}/hour',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 15),
            // Enhanced Quantity Display
            Row(
              children: [
                _buildDetailChip('Available: ${bike.availableCount}', Colors.green),
                const SizedBox(width: 10),
                _buildDetailChip('Rented: ${bike.rentedCount}', Colors.orange),
                const SizedBox(width: 10),
                _buildDetailChip('Total: ${bike.totalCount}', Colors.blue),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Handle rent bike
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Rent This Bike',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  LinearGradient _getBikeGradient(String bikeType) {
    switch (bikeType) {
      case 'mountain':
        return const LinearGradient(
          colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'road':
        return const LinearGradient(
          colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'electric':
        return const LinearGradient(
          colors: [Color(0xFF7B1FA2), Color(0xFFBA68C8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'hybrid':
        return const LinearGradient(
          colors: [Color(0xFFE65100), Color(0xFFFF9800)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return const LinearGradient(
          colors: [Color(0xFF424242), Color(0xFF757575)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  Widget _buildDetailChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
