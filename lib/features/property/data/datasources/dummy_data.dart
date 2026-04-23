import '../../domain/entities/category.dart';
import '../../domain/entities/property.dart';

class DummyData {
  static final List<Category> categories = [
    Category(
      id: '1',
      name: 'Kos',
      imageUrl: 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?q=80&w=600',
      count: 12,
    ),
    Category(
      id: '2',
      name: 'Hotel',
      imageUrl: 'https://images.unsplash.com/photo-1631049307264-da0ec9d70304?q=80&w=600',
      count: 8,
    ),
    Category(
      id: '3',
      name: 'Villa',
      imageUrl: 'https://images.unsplash.com/photo-1570129477492-45a003537e1f?q=80&w=600',
      count: 15,
    ),
  ];

  static final List<Property> properties = [
    Property(
      id: '1',
      name: 'Aspire Living Kemang',
      location: 'South Jakarta',
      price: 'Rp 2.450.000',
      imageUrl: 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?q=80&w=500',
      rating: 4.8,
    ),
    Property(
      id: '2',
      name: 'D\'Kost Elite Sudirman',
      location: 'Central Jakarta',
      price: 'Rp 3.200.000',
      imageUrl: 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?q=80&w=500',
      rating: 4.9,
    ),
    Property(
      id: '3',
      name: 'D\'Kost Jogja',
      location: 'Yogyakarta',
      price: 'Rp 2.200.000',
      imageUrl: 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?q=80&w=500',
      rating: 4.7,
    ),
  ];
}
