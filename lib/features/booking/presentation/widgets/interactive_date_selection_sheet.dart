import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';

class InteractiveDateSelectionSheet extends StatefulWidget {
  final DateTime? initialCheckIn;
  final DateTime? initialCheckOut;
  final bool isDaily;
  final String initialActiveTab; // 'checkin' or 'checkout'
  final int durationMonths;

  const InteractiveDateSelectionSheet({
    super.key,
    this.initialCheckIn,
    this.initialCheckOut,
    required this.isDaily,
    this.initialActiveTab = 'checkin',
    this.durationMonths = 1,
  });

  @override
  State<InteractiveDateSelectionSheet> createState() =>
      _InteractiveDateSelectionSheetState();
}

class _InteractiveDateSelectionSheetState
    extends State<InteractiveDateSelectionSheet> {
  late DateTime _checkInDate;
  late DateTime? _checkOutDate;
  late String _activeTab;
  late DateTime _displayedMonth;

  final List<String> _months = [
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

  @override
  void initState() {
    super.initState();
    DateTime rawCheckIn = widget.initialCheckIn ?? DateTime.now();
    _checkInDate = DateTime(rawCheckIn.year, rawCheckIn.month, rawCheckIn.day);

    if (widget.initialCheckOut != null) {
      _checkOutDate = DateTime(
        widget.initialCheckOut!.year,
        widget.initialCheckOut!.month,
        widget.initialCheckOut!.day,
      );
    }

    _activeTab = widget.initialActiveTab;

    if (!widget.isDaily) {
      _activeTab = 'checkin';
      _checkOutDate = DateTime(
        _checkInDate.year,
        _checkInDate.month + widget.durationMonths,
        _checkInDate.day,
      );
    }

    DateTime activeDate = _activeTab == 'checkin'
        ? _checkInDate
        : (_checkOutDate ?? _checkInDate);
    _displayedMonth = DateTime(activeDate.year, activeDate.month, 1);
  }

  void _onDateSelected(DateTime selectedDate) {
    // Only allow selecting dates from today onwards
    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    if (selectedDate.isBefore(today)) return;

    setState(() {
      if (_activeTab == 'checkin') {
        _checkInDate = selectedDate;
        if (!widget.isDaily) {
          _checkOutDate = DateTime(
            _checkInDate.year,
            _checkInDate.month + widget.durationMonths,
            _checkInDate.day,
          );
        } else {
          if (_checkOutDate != null && !_checkOutDate!.isAfter(_checkInDate)) {
            _checkOutDate = _checkInDate.add(const Duration(days: 1));
          }
        }
      } else if (_activeTab == 'checkout' && widget.isDaily) {
        _checkOutDate = selectedDate;
        if (!_checkInDate.isBefore(_checkOutDate!)) {
          _checkInDate = _checkOutDate!.subtract(const Duration(days: 1));
        }
      }
    });
  }

  String _formatDateIndo(DateTime? date) {
    if (date == null) return 'Pilih Tanggal';
    const days = ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'];
    const monthsShort = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agt',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];

    int dayIndex = date.weekday % 7;
    String dayName = days[dayIndex];
    String monthName = monthsShort[date.month - 1];

    return '$dayName ${date.day} $monthName';
  }

  int _getDaysInMonth(int year, int month) {
    if (month == 12) return 31;
    return DateTime(year, month + 1, 0).day;
  }

  void _changeMonth(int increment) {
    setState(() {
      _displayedMonth = DateTime(
        _displayedMonth.year,
        _displayedMonth.month + increment,
        1,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: 16,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close, color: Colors.black87),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    _activeTab == 'checkin'
                        ? 'Tentukan Tanggal Check-in'
                        : 'Tentukan Tanggal Checkout',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // Tabs
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Expanded(
                    child: _buildTabBox(
                      label: 'Check-in',
                      date: _formatDateIndo(_checkInDate),
                      isActive: _activeTab == 'checkin',
                      onTap: () {
                        setState(() {
                          _activeTab = 'checkin';
                          _displayedMonth = DateTime(
                            _checkInDate.year,
                            _checkInDate.month,
                            1,
                          );
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTabBox(
                      label: 'Checkout',
                      date: _formatDateIndo(_checkOutDate),
                      isActive: _activeTab == 'checkout',
                      isDisabled: !widget.isDaily,
                      onTap: () {
                        if (widget.isDaily) {
                          setState(() {
                            _activeTab = 'checkout';
                            if (_checkOutDate != null) {
                              _displayedMonth = DateTime(
                                _checkOutDate!.year,
                                _checkOutDate!.month,
                                1,
                              );
                            }
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Pilih cepat via dropdown
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pilih cepat via dropdown',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: _buildDropdown(
                          value: _months[_displayedMonth.month - 1],
                          items: _months,
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                int newMonthIndex = _months.indexOf(val) + 1;
                                _displayedMonth = DateTime(
                                  _displayedMonth.year,
                                  newMonthIndex,
                                  1,
                                );
                                DateTime targetDate = _activeTab == 'checkin'
                                    ? _checkInDate
                                    : (_checkOutDate ?? _checkInDate);
                                int maxDays = _getDaysInMonth(
                                  _displayedMonth.year,
                                  newMonthIndex,
                                );
                                int newDay = targetDate.day > maxDays
                                    ? maxDays
                                    : targetDate.day;
                                _onDateSelected(
                                  DateTime(
                                    _displayedMonth.year,
                                    newMonthIndex,
                                    newDay,
                                  ),
                                );
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 1,
                        child: _buildDropdown(
                          value:
                              (_activeTab == 'checkin'
                                      ? _checkInDate.day
                                      : (_checkOutDate?.day ??
                                            _checkInDate.day))
                                  .toString(),
                          items: List.generate(
                            _getDaysInMonth(
                              _displayedMonth.year,
                              _displayedMonth.month,
                            ),
                            (index) => (index + 1).toString(),
                          ),
                          onChanged: (val) {
                            if (val != null) {
                              _onDateSelected(
                                DateTime(
                                  _displayedMonth.year,
                                  _displayedMonth.month,
                                  int.parse(val),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 1,
                        child: _buildDropdown(
                          value: _displayedMonth.year.toString(),
                          items: List.generate(
                            10,
                            (index) => (DateTime.now().year + index).toString(),
                          ),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                int newYear = int.parse(val);
                                _displayedMonth = DateTime(
                                  newYear,
                                  _displayedMonth.month,
                                  1,
                                );
                                DateTime targetDate = _activeTab == 'checkin'
                                    ? _checkInDate
                                    : (_checkOutDate ?? _checkInDate);
                                int maxDays = _getDaysInMonth(
                                  newYear,
                                  _displayedMonth.month,
                                );
                                int newDay = targetDate.day > maxDays
                                    ? maxDays
                                    : targetDate.day;
                                _onDateSelected(
                                  DateTime(
                                    newYear,
                                    _displayedMonth.month,
                                    newDay,
                                  ),
                                );
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Calendar
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Calendar Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left),
                          onPressed: () => _changeMonth(-1),
                        ),
                        Text(
                          '${_months[_displayedMonth.month - 1]} ${_displayedMonth.year}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed: () => _changeMonth(1),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Weekdays
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children:
                          ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'].map(
                            (day) {
                              return Expanded(
                                child: Center(
                                  child: Text(
                                    day,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                    ),
                    const SizedBox(height: 8),
                    // Custom Calendar Grid
                    _buildCalendarGrid(),
                  ],
                ),
              ),
            ),
            // Save Button
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, {
                    'checkIn': _checkInDate,
                    'checkOut': _checkOutDate,
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                ),
                child: const Text(
                  'Simpan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    // Ensure value exists in items to prevent errors
    String dropdownValue = items.contains(value) ? value : items.first;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: dropdownValue,
          icon: const Icon(Icons.keyboard_arrow_down, size: 18),
          isExpanded: true,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<String>>((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, overflow: TextOverflow.ellipsis),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTabBox({
    required String label,
    required String date,
    required bool isActive,
    bool isDisabled = false,
    required VoidCallback onTap,
  }) {
    Color borderColor = isActive ? AppColors.primary : Colors.grey.shade300;
    Color backgroundColor = isActive
        ? AppColors.primary.withValues(alpha: 0.05)
        : (isDisabled ? Colors.grey.shade100 : Colors.white);
    Color labelColor = isDisabled ? Colors.grey : Colors.black54;
    Color dateColor = isDisabled
        ? Colors.grey
        : (isActive ? AppColors.primary : Colors.black87);

    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor, width: isActive ? 1.5 : 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: labelColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              date,
              style: TextStyle(
                fontSize: 14,
                color: dateColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    int daysInMonth = _getDaysInMonth(
      _displayedMonth.year,
      _displayedMonth.month,
    );
    int firstDayWeekday = DateTime(
      _displayedMonth.year,
      _displayedMonth.month,
      1,
    ).weekday;
    int firstDayOffset = firstDayWeekday == 7
        ? 0
        : firstDayWeekday; // Map Sunday=7 to 0
    int totalCells = daysInMonth + firstDayOffset;
    int rows = (totalCells / 7).ceil();

    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1.2,
      ),
      itemCount: rows * 7,
      itemBuilder: (context, index) {
        if (index < firstDayOffset || index >= totalCells) {
          return const SizedBox.shrink(); // Empty cell
        }

        int day = index - firstDayOffset + 1;
        DateTime cellDate = DateTime(
          _displayedMonth.year,
          _displayedMonth.month,
          day,
        );
        bool isPastDate = cellDate.isBefore(today);

        bool isCheckIn =
            cellDate.year == _checkInDate.year &&
            cellDate.month == _checkInDate.month &&
            cellDate.day == _checkInDate.day;
        bool isCheckOut =
            _checkOutDate != null &&
            cellDate.year == _checkOutDate!.year &&
            cellDate.month == _checkOutDate!.month &&
            cellDate.day == _checkOutDate!.day;
        bool isInRange =
            _checkOutDate != null &&
            cellDate.isAfter(_checkInDate) &&
            cellDate.isBefore(_checkOutDate!);

        // For range highlight effect
        bool hasRangeToRight =
            isCheckIn &&
            _checkOutDate != null &&
            _checkOutDate!.isAfter(_checkInDate);
        bool hasRangeToLeft =
            isCheckOut && _checkInDate.isBefore(_checkOutDate!);

        // Disable unselectable dates based on active tab
        bool isDisabled = isPastDate;
        if (_activeTab == 'checkout' && cellDate.isBefore(_checkInDate)) {
          isDisabled = true;
        }

        return GestureDetector(
          onTap: isDisabled ? null : () => _onDateSelected(cellDate),
          child: Stack(
            children: [
              if (isInRange || hasRangeToRight || hasRangeToLeft)
                Center(
                  child: SizedBox(
                    height: 36,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            color: hasRangeToLeft || isInRange
                                ? AppColors.primary.withValues(alpha: 0.15)
                                : Colors.transparent,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: hasRangeToRight || isInRange
                                ? AppColors.primary.withValues(alpha: 0.15)
                                : Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              // Circle for Check-in / Check-out
              Center(
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isCheckIn || isCheckOut
                        ? AppColors.primary
                        : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    day.toString(),
                    style: TextStyle(
                      color: isCheckIn || isCheckOut
                          ? Colors.white
                          : (isDisabled
                                ? Colors.grey.shade400
                                : Colors.black87),
                      fontWeight: isCheckIn || isCheckOut
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
