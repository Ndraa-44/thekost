import 'package:equatable/equatable.dart';

class CreateBookingState extends Equatable {
  final int duration;
  final int rooms;
  final String rentalPackage; // 'None', 'Motor', 'Mobil'
  final String paymentMethod;
  final int basePrice;
  final DateTime? checkInDate;
  final DateTime? checkOutDate;
  final String category;

  const CreateBookingState({
    this.duration = 1,
    this.rooms = 1,
    this.rentalPackage = 'None',
    this.paymentMethod = 'Transfer Bank',
    this.basePrice = 0,
    this.checkInDate,
    this.checkOutDate,
    this.category = '',
  });

  bool get isDaily => category.toLowerCase() == 'villa' || category.toLowerCase() == 'homestay';

  int get days {
    if (checkInDate != null && checkOutDate != null) {
      final difference = checkOutDate!.difference(checkInDate!).inDays;
      return difference > 0 ? difference : 1;
    }
    return 1;
  }

  int get rentalPrice {
    if (rentalPackage == 'Motor') return 100000;
    if (rentalPackage == 'Mobil') return 300000;
    return 0;
  }
  
  int get totalPrice {
    if (isDaily) {
      return (basePrice * days * rooms) + (rentalPrice * days);
    } else {
      return (basePrice * duration * rooms) + rentalPrice;
    }
  }

  CreateBookingState copyWith({
    int? duration,
    int? rooms,
    String? rentalPackage,
    String? paymentMethod,
    int? basePrice,
    DateTime? checkInDate,
    DateTime? checkOutDate,
    String? category,
  }) {
    return CreateBookingState(
      duration: duration ?? this.duration,
      rooms: rooms ?? this.rooms,
      rentalPackage: rentalPackage ?? this.rentalPackage,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      basePrice: basePrice ?? this.basePrice,
      checkInDate: checkInDate ?? this.checkInDate,
      checkOutDate: checkOutDate ?? this.checkOutDate,
      category: category ?? this.category,
    );
  }

  @override
  List<Object?> get props => [
        duration,
        rooms,
        rentalPackage,
        paymentMethod,
        basePrice,
        checkInDate,
        checkOutDate,
        category,
      ];
}
