import 'package:flutter_bloc/flutter_bloc.dart';
import 'create_booking_state.dart';

class CreateBookingCubit extends Cubit<CreateBookingState> {
  CreateBookingCubit() : super(const CreateBookingState());

  void init(String priceString, String category) {
    // Extract numbers from strings like "Rp 1.500.000 /bulan"
    final numericString = priceString.replaceAll(RegExp(r'[^0-9]'), '');
    final price = int.tryParse(numericString) ?? 0;
    
    // Set checkInDate to today by default
    final today = DateTime.now();
    DateTime checkOutDate;
    
    if (category.toLowerCase() == 'villa' || category.toLowerCase() == 'homestay') {
      // Default to tomorrow for daily
      checkOutDate = today.add(const Duration(days: 1));
    } else {
      // Default to 1 month later for monthly
      checkOutDate = DateTime(today.year, today.month + 1, today.day);
    }
    
    emit(state.copyWith(
      basePrice: price, 
      category: category,
      checkInDate: today,
      checkOutDate: checkOutDate,
    ));
  }

  void updateDuration(int duration) {
    DateTime? checkOutDate = state.checkOutDate;
    
    if (!state.isDaily && state.checkInDate != null) {
      // Calculate checkOutDate based on duration in months
      checkOutDate = DateTime(
        state.checkInDate!.year, 
        state.checkInDate!.month + duration, 
        state.checkInDate!.day,
      );
    }
    
    emit(state.copyWith(duration: duration, checkOutDate: checkOutDate));
  }

  void updateCheckInDate(DateTime date) {
    DateTime? checkOutDate = state.checkOutDate;
    
    if (!state.isDaily) {
      // For monthly/yearly, recalculate checkout based on new check-in
      checkOutDate = DateTime(
        date.year, 
        date.month + state.duration, 
        date.day,
      );
    } else {
      // For daily, make sure checkout is after check-in
      if (checkOutDate != null && !checkOutDate.isAfter(date)) {
        checkOutDate = date.add(const Duration(days: 1));
      }
    }
    
    emit(state.copyWith(checkInDate: date, checkOutDate: checkOutDate));
  }

  void updateCheckOutDate(DateTime date) {
    if (state.isDaily) {
      emit(state.copyWith(checkOutDate: date));
    }
  }

  void updateDates(DateTime checkIn, DateTime? checkOut) {
    DateTime? finalCheckOut = checkOut;
    if (!state.isDaily) {
      finalCheckOut = DateTime(
        checkIn.year, 
        checkIn.month + state.duration, 
        checkIn.day,
      );
    }
    emit(state.copyWith(checkInDate: checkIn, checkOutDate: finalCheckOut));
  }

  void updateRooms(int rooms) {
    emit(state.copyWith(rooms: rooms));
  }

  void toggleRentalPackage(String package) {
    if (state.rentalPackage == package) {
      emit(state.copyWith(rentalPackage: 'None'));
    } else {
      emit(state.copyWith(rentalPackage: package));
    }
  }

  void setRentalPackage(String package) {
    emit(state.copyWith(rentalPackage: package));
  }

  void updatePaymentMethod(String method) {
    emit(state.copyWith(paymentMethod: method));
  }
}
