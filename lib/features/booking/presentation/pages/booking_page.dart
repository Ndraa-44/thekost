import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/login_prompt_widget.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../data/datasources/booking_local_datasource.dart';
import '../../domain/entities/booking.dart';

/// Booking / Orders page showing user's bookings.
class BookingPage extends StatelessWidget {
  const BookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          return const _BookingContent();
        }
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(title: const Text(AppStrings.myBookings)),
          body: LoginPromptWidget(
            title: AppStrings.bookingLoginTitle,
            subtitle: AppStrings.bookingLoginSubtitle,
            icon: Icons.receipt_long_rounded,
            onLoginPressed: () => context.push(AppRouter.loginPath),
          ),
        );
      },
    );
  }
}

// ─────────────── SUDAH LOGIN ───────────────
class _BookingContent extends StatefulWidget {
  const _BookingContent();

  @override
  State<_BookingContent> createState() => _BookingContentState();
}

class _BookingContentState extends State<_BookingContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _visualIndex = 0;

  static const _tabs = [
    BookingStatus.active,
    BookingStatus.completed,
    BookingStatus.refund,
    BookingStatus.cancelled,
  ];

  static const _tabLabels = [
    AppStrings.bookingActive,
    AppStrings.bookingCompleted,
    AppStrings.bookingRefund,
    AppStrings.bookingCancelled,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    // Primary: definitive index changes (reliable for both tap & swipe completion)
    _tabController.addListener(_onTabIndexChanged);
    // Secondary: smooth real-time visual tracking during swipe gestures
    _tabController.animation?.addListener(_onTabAnimation);
  }

  void _onTabIndexChanged() {
    // Fires when tab index definitively changes after tap or swipe completion
    final idx = _tabController.index;
    if (idx != _visualIndex) {
      setState(() => _visualIndex = idx);
    }
  }

  void _onTabAnimation() {
    // Real-time tracking during active swipe gestures
    final value = _tabController.animation?.value;
    if (value != null) {
      final newIndex = value.round();
      if (newIndex != _visualIndex) {
        setState(() => _visualIndex = newIndex);
      }
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabIndexChanged);
    _tabController.animation?.removeListener(_onTabAnimation);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.myBookings),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // ── Smooth Sliding Tab Bar ──
          Container(
            margin: const EdgeInsets.fromLTRB(
                AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.sm),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: AnimatedBuilder(
              animation: _tabController.animation!,
              builder: (context, _) {
                final animValue = _tabController.animation!.value;
                return LayoutBuilder(
                  builder: (context, constraints) {
                    final tabWidth = constraints.maxWidth / _tabs.length;
                    return Stack(
                      children: [
                        // ── Sliding pill indicator ──
                        Positioned(
                          left: animValue * tabWidth,
                          width: tabWidth,
                          top: 0,
                          bottom: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(
                                  AppSpacing.radiusSm + 2),
                            ),
                          ),
                        ),
                        // ── Tab labels ──
                        Row(
                          children: List.generate(_tabs.length, (i) {
                            final distance = (animValue - i).abs();
                            final selectedness =
                                (1.0 - distance).clamp(0.0, 1.0);
                            return Expanded(
                              child: GestureDetector(
                                onTap: () => _tabController.animateTo(i),
                                behavior: HitTestBehavior.opaque,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Center(
                                    child: Text(
                                      _tabLabels[i],
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: selectedness > 0.5
                                            ? FontWeight.w700
                                            : FontWeight.w500,
                                        color: Color.lerp(
                                          Colors.grey.shade600,
                                          Colors.white,
                                          selectedness,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          // ── Tab Content ──
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _tabs
                  .map((status) => _BookingListView(status: status))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _BookingListView extends StatelessWidget {
  final BookingStatus status;

  const _BookingListView({required this.status});

  @override
  Widget build(BuildContext context) {
    final bookings = BookingLocalDataSource.bookings
        .where((b) => b.status == status)
        .toList();

    if (bookings.isEmpty) return _buildEmpty();

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: bookings.length,
      itemBuilder: (_, i) => _BookingCard(booking: bookings[i]),
    );
  }

  Widget _buildEmpty() {
    final messages = {
      BookingStatus.active: AppStrings.noActiveBooking,
      BookingStatus.completed: AppStrings.noCompletedBooking,
      BookingStatus.refund: AppStrings.noRefundBooking,
      BookingStatus.cancelled: AppStrings.noCancelledBooking,
    };
    final icons = {
      BookingStatus.active: Icons.hourglass_empty_rounded,
      BookingStatus.completed: Icons.check_circle_outline_rounded,
      BookingStatus.refund: Icons.replay_rounded,
      BookingStatus.cancelled: Icons.cancel_outlined,
    };

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icons[status], size: 64, color: Colors.grey.shade300),
          const SizedBox(height: AppSpacing.md),
          Text(
            messages[status]!,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 15),
          ),
        ],
      ),
    );
  }
}

// ─────────────── CARD PESANAN ───────────────
class _BookingCard extends StatelessWidget {
  final Booking booking;

  const _BookingCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Image ──
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppSpacing.radiusLg),
            ),
            child: Image.network(
              booking.propertyImage,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 160,
                color: Colors.grey.shade200,
                child: const Center(child: Icon(Icons.broken_image, size: 48)),
              ),
            ),
          ),

          // ── Info Section ──
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Type label + badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _PropertyTypeLabel(type: booking.propertyType),
                    _StatusBadge(status: booking.status),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),

                // Name
                Text(
                  booking.propertyName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),

                // Location
                Row(
                  children: [
                    Icon(Icons.location_on,
                        size: 14, color: Colors.grey.shade500),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        booking.location,
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                // Dates + Duration row
                Row(
                  children: [
                    Icon(Icons.calendar_today_rounded,
                        size: 14, color: Colors.grey.shade600),
                    const SizedBox(width: 6),
                    Text(
                      '${booking.checkIn} • ${booking.duration.isNotEmpty ? booking.duration : booking.checkOut}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.md),

                // Price
                Text(
                  booking.price,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                // View Detail Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      context.push(
                        AppRouter.bookingDetailPath,
                        extra: booking,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusMd),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      AppStrings.viewDetail,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Property Type Label ──
class _PropertyTypeLabel extends StatelessWidget {
  final String type;
  const _PropertyTypeLabel({required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Text(
        type,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Colors.grey.shade700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// ── Status Badge ──
class _StatusBadge extends StatelessWidget {
  final BookingStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final Color bgColor;
    final Color textColor;
    final String label;

    switch (status) {
      case BookingStatus.active:
        bgColor = AppColors.primary;
        textColor = Colors.white;
        label = AppStrings.bookingActive;
      case BookingStatus.completed:
        bgColor = const Color(0xFF16A34A);
        textColor = Colors.white;
        label = AppStrings.bookingCompleted;
      case BookingStatus.refund:
        bgColor = const Color(0xFFF59E0B);
        textColor = Colors.white;
        label = AppStrings.bookingRefund;
      case BookingStatus.cancelled:
        bgColor = const Color(0xFFDC2626);
        textColor = Colors.white;
        label = AppStrings.bookingCancelled;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
