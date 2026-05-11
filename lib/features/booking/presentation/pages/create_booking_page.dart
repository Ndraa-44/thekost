import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../property/domain/entities/property.dart';
import '../cubit/create_booking_cubit.dart';
import '../cubit/create_booking_state.dart';
import '../widgets/interactive_date_selection_sheet.dart';

class CreateBookingPage extends StatelessWidget {
  final Property property;

  const CreateBookingPage({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CreateBookingCubit()..init(property.price, property.category),
      child: _CreateBookingView(property: property),
    );
  }
}

class _CreateBookingView extends StatefulWidget {
  final Property property;

  const _CreateBookingView({required this.property});

  @override
  State<_CreateBookingView> createState() => _CreateBookingViewState();
}

class _CreateBookingViewState extends State<_CreateBookingView> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _fillFromProfile(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      final user = authState.user;

      if (user.name.isEmpty || user.phoneNumber.isEmpty || user.email.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Profil Anda belum lengkap. Silakan lengkapi profil terlebih dahulu.',
            ),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      setState(() {
        _nameController.text = user.name;
        _phoneController.text = user.phoneNumber;
        _emailController.text = user.email;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil diisi dari profil')),
      );
    }
  }

  String _formatCurrency(int amount) {
    final str = amount.toString();
    var result = '';
    var count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      if (count != 0 && count % 3 == 0) {
        result = '.$result';
      }
      result = str[i] + result;
      count++;
    }
    return 'Rp $result';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Konfirmasi Reservasi',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildPropertyCard(),
            _buildOrderForm(context),
            const SizedBox(height: AppSpacing.sm),
            _buildPaymentMethodSection(context),
            const SizedBox(height: AppSpacing.sm),
            _buildPaymentDetailsSection(context),
            const SizedBox(height: 100), // padding for bottom bar
          ],
        ),
      ),
      bottomSheet: _buildBottomBar(context),
    );
  }

  Widget _buildPropertyCard() {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppSpacing.radiusMd),
            ),
            child: Image.network(
              widget.property.imageUrl,
              height: 180,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                Text(
                  widget.property.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        widget.property.location,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderForm(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Detail Pemesan',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildProfileAutofillBanner(context),
          const SizedBox(height: AppSpacing.md),
          _buildTextField(
            'Nama Lengkap',
            _nameController,
            Icons.person_outline,
          ),
          const SizedBox(height: AppSpacing.md),
          _buildTextField(
            'No. Whatsapp',
            _phoneController,
            Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: AppSpacing.md),
          _buildTextField(
            'Email',
            _emailController,
            Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: AppSpacing.md),

          BlocBuilder<CreateBookingCubit, CreateBookingState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildDateSelector(context, 'Check-in', state),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: _buildDateSelector(
                          context,
                          'Check-out',
                          state,
                          isReadOnly: !state.isDaily,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      if (!state.isDaily) ...[
                        Expanded(
                          child: _buildDurationSelector(
                            context,
                            state.duration,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                      ],
                      Expanded(
                        child:
                            widget.property.category.toLowerCase() == 'homestay'
                            ? _buildCompactDropdown(
                                context,
                                'Jumlah Kamar',
                                ['1 Kamar', '2 Kamar', '3 Kamar'],
                                '${state.rooms} Kamar',
                                (val) {
                                  if (val != null) {
                                    int rooms = int.parse(val.split(' ')[0]);
                                    context
                                        .read<CreateBookingCubit>()
                                        .updateRooms(rooms);
                                  }
                                },
                              )
                            : _buildLockedRoomSelector(context),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          if (widget.property.category.toLowerCase() == 'villa' ||
              widget.property.category.toLowerCase() == 'homestay') ...[
            const SizedBox(height: AppSpacing.md),
            const Text(
              'Kendaraan / Fasilitas',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            BlocBuilder<CreateBookingCubit, CreateBookingState>(
              builder: (context, state) {
                return _buildSegmentedRental(context, state.rentalPackage);
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProfileAutofillBanner(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          onTap: () => _fillFromProfile(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                const Icon(Icons.person, color: AppColors.primary, size: 20),
                const SizedBox(width: 8),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Isi data dari Profil',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        'Gunakan data profil untuk mempercepat pemesanan',
                        style: TextStyle(color: Colors.black54, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: AppColors.primary,
                  ),
                  padding: const EdgeInsets.all(4),
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    final authState = context.read<AuthBloc>().state;
                    if (authState is AuthAuthenticated) {
                      context.push(
                        AppRouter.editProfilePath,
                        extra: authState.user,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey, size: 20),
            hintText: 'Masukkan $label',
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              borderSide: const BorderSide(color: AppColors.primary),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildDateSelector(
    BuildContext context,
    String label,
    CreateBookingState state, {
    bool isReadOnly = false,
  }) {
    DateTime? date = label == 'Check-in'
        ? state.checkInDate
        : state.checkOutDate;

    final List<String> months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    String dateText = date != null
        ? '${date.day} ${months[date.month - 1]} ${date.year}'
        : 'Pilih Tanggal';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: isReadOnly
              ? null
              : () async {
                  final result =
                      await showModalBottomSheet<Map<String, DateTime?>>(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(AppSpacing.radiusLg),
                          ),
                        ),
                        builder: (bottomSheetContext) {
                          return InteractiveDateSelectionSheet(
                            initialCheckIn: state.checkInDate,
                            initialCheckOut: state.checkOutDate,
                            isDaily: state.isDaily,
                            initialActiveTab: label == 'Check-in'
                                ? 'checkin'
                                : 'checkout',
                            durationMonths: state.duration,
                          );
                        },
                      );

                  if (result != null && result['checkIn'] != null) {
                    context.read<CreateBookingCubit>().updateDates(
                      result['checkIn']!,
                      result['checkOut'],
                    );
                  }
                },
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          child: Container(
            height: 46,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              border: Border.all(color: Colors.grey.shade300),
              color: isReadOnly ? Colors.grey.shade100 : Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dateText,
                  style: TextStyle(
                    fontSize: 14,
                    color: isReadOnly ? Colors.grey.shade600 : Colors.black87,
                  ),
                ),
                Icon(
                  Icons.calendar_today_outlined,
                  color: isReadOnly ? Colors.grey : AppColors.primary,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLockedRoomSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Jumlah Kamar',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 46,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            border: Border.all(color: Colors.grey.shade300),
            color: Colors.grey.shade100,
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '1 Kamar',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              Icon(Icons.lock_outline, color: Colors.grey, size: 18),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDurationSelector(BuildContext context, int duration) {
    String label =
        '${duration == 12 ? 1 : duration} ${duration == 12 ? 'Tahun' : 'Bulan'}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Durasi',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _showDurationBottomSheet(context, duration),
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          child: Container(
            height: 46,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              border: Border.all(color: Colors.grey.shade300),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label, style: const TextStyle(fontSize: 14)),
                const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showDurationBottomSheet(BuildContext context, int currentDuration) {
    final options = [
      {'label': '1 Bulan', 'value': 1},
      {'label': '3 Bulan', 'value': 3},
      {'label': '6 Bulan', 'value': 6},
      {'label': '1 Tahun', 'value': 12},
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: Text(
                  'Pilih Durasi',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              ...options.map((opt) {
                final isSelected = currentDuration == opt['value'];
                return ListTile(
                  title: Text(
                    opt['label'] as String,
                    style: TextStyle(
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isSelected ? AppColors.primary : Colors.black87,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: AppColors.primary)
                      : null,
                  onTap: () {
                    context.read<CreateBookingCubit>().updateDuration(
                      opt['value'] as int,
                    );
                    Navigator.pop(bottomSheetContext);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCompactDropdown(
    BuildContext context,
    String label,
    List<String> items,
    String value,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            return Theme(
              data: Theme.of(context).copyWith(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: PopupMenuButton<String>(
                initialValue: value,
                onSelected: onChanged,
                offset: const Offset(0, 50),
                constraints: BoxConstraints(
                  minWidth: constraints.maxWidth,
                  maxWidth: constraints.maxWidth,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                color: Colors.white,
                elevation: 8,
                clipBehavior: Clip.antiAlias,
                itemBuilder: (BuildContext context) {
              return items.map((String item) {
                final isSelected = item == value;
                return PopupMenuItem<String>(
                  value: item,
                  padding: EdgeInsets.zero,
                  height: 48,
                  child: Container(
                    width: double.infinity,
                    height: 48,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : Colors.transparent,
                    ),
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: 14,
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList();
            },
            child: Container(
              height: 46,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                border: Border.all(color: Colors.grey.shade300),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(value, style: const TextStyle(fontSize: 14)),
                  const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                ],
              ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildSegmentedRental(BuildContext context, String selectedPackage) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildSegmentedCard(
              context,
              'None',
              'Tanpa Kendaraan',
              selectedPackage == 'None',
            ),
          ),
          Expanded(
            child: _buildSegmentedCard(
              context,
              'Motor',
              'Motor',
              selectedPackage == 'Motor',
            ),
          ),
          Expanded(
            child: _buildSegmentedCard(
              context,
              'Mobil',
              'Mobil',
              selectedPackage == 'Mobil',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentedCard(
    BuildContext context,
    String package,
    String label,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () => context.read<CreateBookingCubit>().setRentalPackage(package),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm - 1),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildPaymentMethodSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Metode Pembayaran',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: AppSpacing.md),
          BlocBuilder<CreateBookingCubit, CreateBookingState>(
            builder: (context, state) {
              return InkWell(
                onTap: () =>
                    _showPaymentBottomSheet(context, state.paymentMethod),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _getPaymentIcon(state.paymentMethod),
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          state.paymentMethod,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  IconData _getPaymentIcon(String method) {
    switch (method) {
      case 'Transfer Bank':
        return Icons.account_balance;
      case 'Kartu Kredit':
        return Icons.credit_card;
      case 'E-Wallet':
        return Icons.account_balance_wallet;
      case 'Indomaret / Alfamart':
        return Icons.storefront;
      default:
        return Icons.payment;
    }
  }

  void _showPaymentBottomSheet(BuildContext context, String currentMethod) {
    final methods = [
      'Transfer Bank',
      'Kartu Kredit',
      'E-Wallet',
      'Indomaret / Alfamart',
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: Text(
                  'Pilih Metode Pembayaran',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              ...methods.map((method) {
                final isSelected = currentMethod == method;
                return ListTile(
                  leading: Icon(
                    _getPaymentIcon(method),
                    color: isSelected
                        ? AppColors.primary
                        : Colors.grey.shade600,
                  ),
                  title: Text(
                    method,
                    style: TextStyle(
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isSelected ? AppColors.primary : Colors.black87,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: AppColors.primary)
                      : null,
                  onTap: () {
                    context.read<CreateBookingCubit>().updatePaymentMethod(
                      method,
                    );
                    Navigator.pop(bottomSheetContext);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaymentDetailsSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      color: Colors.white,
      child: BlocBuilder<CreateBookingCubit, CreateBookingState>(
        builder: (context, state) {
          int durationMultiplier = state.isDaily ? state.days : state.duration;
          int price = state.basePrice * durationMultiplier * state.rooms;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Detail Pembayaran',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: AppSpacing.md),
              _buildPaymentRow('Harga', _formatCurrency(price)),
              if (state.rentalPackage != 'None' && state.isDaily) ...[
                const SizedBox(height: 8),
                _buildPaymentRow(
                  'Sewa ${state.rentalPackage}',
                  _formatCurrency(state.rentalPrice * state.days),
                ),
              ],
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Divider(),
              ),
              _buildPaymentRow(
                'Estimasi Total Pembayaran',
                _formatCurrency(state.totalPrice),
                isTotal: true,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPaymentRow(String label, String amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isTotal ? Colors.black : Colors.grey.shade700,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            fontSize: isTotal ? 16 : 14,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            color: isTotal ? AppColors.primary : Colors.black87,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            fontSize: isTotal ? 16 : 14,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: BlocBuilder<CreateBookingCubit, CreateBookingState>(
                builder: (context, state) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Pembayaran',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      Text(
                        _formatCurrency(state.totalPrice),
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement actual payment gateway call here
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Melanjutkan ke pembayaran...')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
              ),
              child: const Text(
                'BAYAR SEKARANG',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
