import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../domain/entities/booking.dart';

/// Detail page showing full transaction history for a booking.
///
/// Includes property summary, transaction details, payment breakdown,
/// status info, and a refund card with a 4-hour countdown timer.
class BookingDetailPage extends StatelessWidget {
  final Booking booking;

  const BookingDetailPage({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.transactionHistory),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            // ── Property Card ──
            _PropertySummaryCard(booking: booking),
            const SizedBox(height: AppSpacing.md),

            // ── Detail Transaksi ──
            _TransactionDetailCard(booking: booking),
            const SizedBox(height: AppSpacing.md),

            // ── Detail Pembayaran ──
            _PaymentDetailCard(booking: booking),
            const SizedBox(height: AppSpacing.md),

            // ── Status Transaksi ──
            _TransactionStatusCard(booking: booking),
            const SizedBox(height: AppSpacing.md),

            // ── Ajukan Refund ──
            if (booking.status == BookingStatus.completed ||
                booking.status == BookingStatus.active)
              _RefundCard(booking: booking),

            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}

// ─────────────── PROPERTY SUMMARY ───────────────
class _PropertySummaryCard extends StatelessWidget {
  final Booking booking;
  const _PropertySummaryCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppSpacing.radiusLg),
            ),
            child: Image.network(
              booking.propertyImage,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 180,
                color: Colors.grey.shade200,
                child: const Center(child: Icon(Icons.broken_image, size: 48)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Property type label
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusSm),
                      ),
                      child: Text(
                        booking.propertyType,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey.shade700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    // Status badge
                    _buildStatusBadge(),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  booking.propertyName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on,
                        size: 14, color: Colors.grey.shade500),
                    const SizedBox(width: 4),
                    Text(
                      booking.location,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 13,
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

  Widget _buildStatusBadge() {
    final Color bgColor;
    final String label;

    switch (booking.status) {
      case BookingStatus.active:
        bgColor = AppColors.primary;
        label = AppStrings.bookingActive;
      case BookingStatus.completed:
        bgColor = const Color(0xFF16A34A);
        label = AppStrings.bookingCompleted;
      case BookingStatus.refund:
        bgColor = const Color(0xFFF59E0B);
        label = AppStrings.bookingRefund;
      case BookingStatus.cancelled:
        bgColor = const Color(0xFFDC2626);
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
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ─────────────── DETAIL TRANSAKSI ───────────────
class _TransactionDetailCard extends StatelessWidget {
  final Booking booking;
  const _TransactionDetailCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
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
          const Text(
            AppStrings.transactionDetail,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _DetailRow(
            icon: Icons.receipt_long_rounded,
            iconColor: AppColors.primary,
            label: AppStrings.transactionDate,
            value: booking.transactionDate,
            valueColor: AppColors.primary,
          ),
          const SizedBox(height: AppSpacing.md),
          _DetailRow(
            icon: Icons.login_rounded,
            iconColor: AppColors.primary,
            label: AppStrings.checkInDate,
            value: booking.checkIn,
            valueColor: AppColors.primary,
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _DetailRow(
                  icon: Icons.access_time_rounded,
                  iconColor: AppColors.primary,
                  label: AppStrings.durationLabel,
                  value: booking.duration,
                  valueColor: AppColors.primary,
                ),
              ),
              Expanded(
                child: _DetailRow(
                  icon: Icons.bed_rounded,
                  iconColor: AppColors.primary,
                  label: AppStrings.roomCountLabel,
                  value: '${booking.roomCount} Kamar',
                  valueColor: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          child: Icon(icon, size: 18, color: iconColor),
        ),
        const SizedBox(width: AppSpacing.sm + 2),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: valueColor ?? AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────── DETAIL PEMBAYARAN ───────────────
class _PaymentDetailCard extends StatelessWidget {
  final Booking booking;
  const _PaymentDetailCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
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
          const Text(
            AppStrings.paymentDetail,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _PaymentRow(
            label: AppStrings.rentPerMonth,
            value: booking.rentPrice,
          ),
          if (booking.motorBikePrice != null) ...[
            const SizedBox(height: AppSpacing.sm),
            _PaymentRow(
              label: AppStrings.motorBikePackage,
              value: booking.motorBikePrice!,
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
          _PaymentRow(
            label: AppStrings.serviceFeeLabel,
            value: booking.serviceFee,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.sm + 2),
            child: Divider(height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                AppStrings.totalPaymentLabel,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                booking.totalPayment,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PaymentRow extends StatelessWidget {
  final String label;
  final String value;
  const _PaymentRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

// ─────────────── STATUS TRANSAKSI ───────────────
class _TransactionStatusCard extends StatelessWidget {
  final Booking booking;
  const _TransactionStatusCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.18),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              color: AppColors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: AppSpacing.sm + 2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  AppStrings.transactionStatus,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppStrings.transactionSuccessMsg,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                    height: 1.5,
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

// ─────────────── AJUKAN REFUND (with countdown) ───────────────
class _RefundCard extends StatefulWidget {
  final Booking booking;
  const _RefundCard({required this.booking});

  @override
  State<_RefundCard> createState() => _RefundCardState();
}

class _RefundCardState extends State<_RefundCard> {
  Timer? _timer;
  Duration _remaining = Duration.zero;
  bool _isExpired = false;

  static const _refundDuration = Duration(hours: 4);

  @override
  void initState() {
    super.initState();
    _calculateRemaining();
    if (!_isExpired) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        _calculateRemaining();
      });
    }
  }

  void _calculateRemaining() {
    final confirmedAt = widget.booking.tenantArrivalConfirmedAt;
    if (confirmedAt == null) {
      // Arrival not confirmed yet — no countdown, but card stays clickable
      setState(() {
        _isExpired = false;
        _remaining = _refundDuration;
      });
      return;
    }

    final deadline = confirmedAt.add(_refundDuration);
    final now = DateTime.now();
    final diff = deadline.difference(now);

    if (diff.isNegative || diff == Duration.zero) {
      setState(() {
        _isExpired = true;
        _remaining = Duration.zero;
      });
      _timer?.cancel();
    } else {
      setState(() {
        _isExpired = false;
        _remaining = diff;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final hours = d.inHours.toString().padLeft(2, '0');
    final minutes = (d.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isExpired
          ? null
          : () {
              // TODO: Navigate to refund submission page
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Refund page — coming soon'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: _isExpired
              ? Colors.grey.shade100
              : const Color(0xFFFEF2F2),
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(
            color: _isExpired
                ? Colors.grey.shade300
                : const Color(0xFFDC2626).withValues(alpha: 0.25),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _isExpired
                        ? Colors.grey.shade300
                        : const Color(0xFFDC2626).withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isExpired
                        ? Icons.block_rounded
                        : Icons.error_rounded,
                    color: _isExpired
                        ? Colors.grey.shade500
                        : const Color(0xFFDC2626),
                    size: 22,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm + 2),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isExpired
                            ? AppStrings.refundExpired
                            : AppStrings.refundTitle,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: _isExpired
                              ? Colors.grey.shade500
                              : const Color(0xFFDC2626),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _isExpired
                            ? AppStrings.refundExpiredDesc
                            : AppStrings.refundDescription,
                        style: TextStyle(
                          fontSize: 12,
                          color: _isExpired
                              ? Colors.grey.shade500
                              : Colors.grey.shade700,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Countdown Timer
            if (widget.booking.tenantArrivalConfirmedAt != null) ...[
              const SizedBox(height: AppSpacing.md),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md, vertical: 10),
                decoration: BoxDecoration(
                  color: _isExpired
                      ? Colors.grey.shade200
                      : AppColors.primary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.timer_rounded,
                      size: 18,
                      color: _isExpired
                          ? Colors.grey.shade500
                          : AppColors.primary,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      _isExpired
                          ? '00:00:00'
                          : _formatDuration(_remaining),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        fontFeatures: const [FontFeature.tabularFigures()],
                        color: _isExpired
                            ? Colors.grey.shade500
                            : AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
