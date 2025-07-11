import 'package:flutter/material.dart';
import '../models/bike_model.dart';
import '../data/bike_data.dart';
import 'bicycle_selection_screen.dart';
import 'rental_form_screen.dart';

class BicycleAvailabilityScreen extends StatefulWidget {
  const BicycleAvailabilityScreen({super.key});

  @override
  State<BicycleAvailabilityScreen> createState() =>
      _BicycleAvailabilityScreenState();
}

class _BicycleAvailabilityScreenState extends State<BicycleAvailabilityScreen> {
  List<BikeModel> bikes = [];
  List<BikeModel> filteredBikes = [];
  int _selectedIndex = 0;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();
    bikes = BikeData.getAllBikes();
    filteredBikes = bikes;
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
        
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: selectedTime ?? TimeOfDay.now(),
      );
            
      if (pickedTime != null) {
        setState(() {
          selectedDate = pickedDate;
          selectedTime = pickedTime;
          _filterBikesByDateTime();
        });
      }
    }
  }

  void _filterBikesByDateTime() {
    if (selectedDate == null || selectedTime == null) {
      setState(() {
        filteredBikes = bikes;
      });
      return;
    }
    setState(() {
      filteredBikes = bikes.where((bike) => bike.isAvailable).toList();
    });
  }

  // Navigate to rental form without pre-selected bike
  void _navigateToRentalForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RentalFormScreen(
          selectedBike: null,
          selectedDate: selectedDate,
          selectedTime: selectedTime,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        elevation: 0,
        title: const Text(
          'Bicycle Availability',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Colors.blue),
            onPressed: _navigateToRentalForm,
            tooltip: 'Create Rental Request',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              // Date Time Picker Button
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF16213E),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () => _selectDateTime(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedDate == null || selectedTime == null
                            ? 'Select Date & Time'
                            : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year} at ${selectedTime!.format(context)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      const Icon(Icons.calendar_today, color: Colors.blue),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Create Rental Request Button
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 15),
                child: ElevatedButton.icon(
                  onPressed: _navigateToRentalForm,
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text(
                    'Create Rental Request',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              // Info text when date/time is selected
              if (selectedDate != null && selectedTime != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    'Showing bikes available on ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year} at ${selectedTime!.format(context)}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ),

              // Available Bikes Header
              const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Icon(Icons.directions_bike, color: Colors.blue, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Available Bicycles',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // Bike Grid
              Expanded(
                child: filteredBikes.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.directions_bike,
                              size: 64,
                              color: Colors.white54,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No bicycles available',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Try selecting a different date and time',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        itemCount: filteredBikes.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 15,
                          crossAxisSpacing: 15,
                          childAspectRatio: 0.62,
                        ),
                        itemBuilder: (context, index) {
                          return _buildBikeCard(filteredBikes[index]);
                        },
                      ),
              ),
            ],
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
            Navigator.pop(context);
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BicycleSelectionScreen(),
              ),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Rentals',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_bike),
            label: 'Bikes',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToRentalForm,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildBikeCard(BikeModel bike) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 100,
              width: double.infinity,
              color: Colors.grey.shade100,
              child: _getBikeImage(bike),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            bike.fullName,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            'Location: ${bike.location}',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          _buildQuantityChip(
            'Available: ${bike.availableCount}',
            bike.availableCount > 0 ? Colors.green : Colors.grey,
            bike.availableCount > 0,
          ),
          const SizedBox(height: 4),
          _buildQuantityChip(
            'Rented: ${bike.rentedCount}',
            Colors.orange,
            false,
          ),
          const SizedBox(height: 6),
          Text(
            'Total: ${bike.totalCount} bikes',
            style: const TextStyle(
              fontSize: 11,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: bike.isAvailable ? const Color(0xFF4CAF50) : Colors.grey,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              bike.isAvailable ? 'AVAILABLE' : 'RENTED',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityChip(String text, Color color, bool isAvailable) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _getBikeImage(BikeModel bike) {
    String imagePath;
    switch (bike.type.name) {
      case 'mountain':
        imagePath =
            'https://images.unsplash.com/photo-1571068316344-75bc76f77890?w=400&h=400&fit=crop&auto=format';
        break;
      case 'road':
        imagePath =
            'https://images.unsplash.com/photo-1485965120184-e220f721d03e?w=400&h=400&fit=crop&auto=format';
        break;
      case 'electric':
        imagePath =
            'https://images.unsplash.com/photo-1571068316344-75bc76f77890?w=400&h=400&fit=crop&auto=format';
        break;
      case 'hybrid':
        imagePath =
            'https://images.unsplash.com/photo-1502744688674-c619d1586c9e?w=400&h=400&fit=crop&auto=format';
        break;
      default:
        imagePath =
            'https://images.unsplash.com/photo-1571068316344-75bc76f77890?w=400&h=400&fit=crop&auto=format';
    }

    return Image.network(
      imagePath,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey.shade200,
          child: Icon(
            Icons.directions_bike,
            size: 40,
            color: Colors.grey.shade600,
          ),
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
            strokeWidth: 2,
          ),
        );
      },
    );
  }
}