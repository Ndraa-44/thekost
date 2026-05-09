import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_strings.dart';

/// A custom searchable dropdown widget that supports two interaction modes:
///
/// 1. **Type-to-search**: User types in the text field, and the dropdown
///    filters items matching the input (case-insensitive, startsWith).
/// 2. **Tap dropdown arrow**: Opens the full dropdown menu showing all items.
///
/// This widget uses [OverlayEntry] + [CompositedTransformFollower] for
/// precise positioning and full styling control — unlike Flutter's built-in
/// [DropdownButton] which has limited customization.
///
/// Generic type [T] allows this widget to work with any data model.
class SearchableDropdown<T> extends StatefulWidget {
  /// The complete list of selectable items.
  final List<T> items;

  /// Converts an item of type [T] into a display label string.
  final String Function(T) labelBuilder;

  /// The currently selected item, or `null` if nothing is selected.
  final T? selectedItem;

  /// Callback fired when the user selects an item from the dropdown.
  final ValueChanged<T> onChanged;

  /// Callback fired when the user clears the text field, resetting selection.
  final VoidCallback? onCleared;

  /// Placeholder text shown when no item is selected and the field is empty.
  final String placeholder;

  /// Optional icon displayed at the leading edge of the input field.
  final IconData? prefixIcon;

  /// Maximum height of the dropdown menu.
  final double menuMaxHeight;

  const SearchableDropdown({
    super.key,
    required this.items,
    required this.labelBuilder,
    this.selectedItem,
    required this.onChanged,
    this.onCleared,
    this.placeholder = 'Select',
    this.prefixIcon,
    this.menuMaxHeight = 250,
  });

  @override
  State<SearchableDropdown<T>> createState() => _SearchableDropdownState<T>();
}

class _SearchableDropdownState<T> extends State<SearchableDropdown<T>>
    with SingleTickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  OverlayEntry? _overlayEntry;
  List<T> _filteredItems = [];
  bool _isOpen = false;

  /// Animation controller for the dropdown arrow rotation.
  late final AnimationController _arrowController;
  late final Animation<double> _arrowRotation;

  @override
  void initState() {
    super.initState();
    _filteredItems = List.from(widget.items);

    // Pre-fill text field if an item is already selected.
    if (widget.selectedItem != null) {
      _textController.text = widget.labelBuilder(widget.selectedItem as T);
    }

    _arrowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _arrowRotation = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(parent: _arrowController, curve: Curves.easeInOut),
    );

    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void didUpdateWidget(covariant SearchableDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync text field when the selected item changes externally.
    if (widget.selectedItem != oldWidget.selectedItem) {
      if (widget.selectedItem != null) {
        _textController.text = widget.labelBuilder(widget.selectedItem as T);
      } else {
        _textController.clear();
      }
    }
  }

  @override
  void dispose() {
    _removeOverlay();
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
    _textController.dispose();
    _arrowController.dispose();
    super.dispose();
  }

  // ─────────────── FOCUS HANDLING ───────────────

  void _onFocusChanged() {
    if (_focusNode.hasFocus && !_isOpen) {
      // When user taps the text field, open with current filter.
      _filterItems(_textController.text);
      _showOverlay();
    }
  }

  // ─────────────── FILTER LOGIC ───────────────

  void _filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredItems = List.from(widget.items);
      } else {
        _filteredItems = widget.items.where((item) {
          final label = widget.labelBuilder(item).toLowerCase();
          return label.startsWith(query.toLowerCase());
        }).toList();
      }
    });
    // Rebuild overlay to reflect new filtered items.
    _overlayEntry?.markNeedsBuild();
  }

  // ─────────────── OVERLAY MANAGEMENT ───────────────

  void _showOverlay() {
    if (_isOpen) return;
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    _isOpen = true;
    _arrowController.forward();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (_isOpen) {
      _isOpen = false;
      _arrowController.reverse();
    }
  }

  void _toggleDropdown() {
    if (_isOpen) {
      _removeOverlay();
      _focusNode.unfocus();
    } else {
      // When opening via arrow, show all items regardless of text.
      _filteredItems = List.from(widget.items);
      _focusNode.requestFocus();
      _showOverlay();
    }
  }

  void _selectItem(T item) {
    _textController.text = widget.labelBuilder(item);
    // Move cursor to end of text.
    _textController.selection = TextSelection.fromPosition(
      TextPosition(offset: _textController.text.length),
    );
    widget.onChanged(item);
    _removeOverlay();
    _focusNode.unfocus();
  }

  // ─────────────── OVERLAY ENTRY ───────────────

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    return OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            // Invisible barrier to dismiss on outside tap.
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  _removeOverlay();
                  _focusNode.unfocus();
                  // Restore selected item text if user didn't pick anything.
                  if (widget.selectedItem != null) {
                    _textController.text =
                        widget.labelBuilder(widget.selectedItem as T);
                  } else {
                    _textController.clear();
                  }
                },
                child: const SizedBox.expand(),
              ),
            ),
            // The dropdown menu itself.
            CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0, size.height + 6),
              child: Material(
                color: Colors.transparent,
                child: _DropdownMenu<T>(
                  items: _filteredItems,
                  labelBuilder: widget.labelBuilder,
                  selectedItem: widget.selectedItem,
                  onItemSelected: _selectItem,
                  maxHeight: widget.menuMaxHeight,
                  width: size.width,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ─────────────── BUILD ───────────────

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            if (widget.prefixIcon != null) ...[
              Icon(
                widget.prefixIcon,
                color: AppColors.textSecondary,
                size: 18,
              ),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: TextField(
                controller: _textController,
                focusNode: _focusNode,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: widget.placeholder,
                  hintStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade400,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
                onChanged: (value) {
                  _filterItems(value);
                  if (value.isEmpty) {
                    // Reset selection when text is fully cleared.
                    widget.onCleared?.call();
                  }
                  if (!_isOpen) {
                    _showOverlay();
                  }
                },
              ),
            ),
            GestureDetector(
              onTap: _toggleDropdown,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: RotationTransition(
                  turns: _arrowRotation,
                  child: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.textSecondary,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────── DROPDOWN MENU (PRIVATE) ───────────────

/// The floating dropdown menu rendered inside the [OverlayEntry].
class _DropdownMenu<T> extends StatelessWidget {
  final List<T> items;
  final String Function(T) labelBuilder;
  final T? selectedItem;
  final ValueChanged<T> onItemSelected;
  final double maxHeight;
  final double width;

  const _DropdownMenu({
    required this.items,
    required this.labelBuilder,
    this.selectedItem,
    required this.onItemSelected,
    required this.maxHeight,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: items.isEmpty
            ? Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                child: Center(
                  child: Text(
                    AppStrings.noLocationFound,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 6),
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final label = labelBuilder(item);
                  final isSelected = selectedItem != null &&
                      labelBuilder(selectedItem as T) == label;

                  return _DropdownMenuItem(
                    label: label,
                    isSelected: isSelected,
                    isLast: index == items.length - 1,
                    onTap: () => onItemSelected(item),
                  );
                },
              ),
      ),
    );
  }
}

// ─────────────── DROPDOWN MENU ITEM (PRIVATE) ───────────────

/// A single item row inside the dropdown menu.
///
/// Highlights with [AppColors.primary] when selected, matching
/// the reference design where the active item has a filled background.
class _DropdownMenuItem extends StatefulWidget {
  final String label;
  final bool isSelected;
  final bool isLast;
  final VoidCallback onTap;

  const _DropdownMenuItem({
    required this.label,
    required this.isSelected,
    required this.isLast,
    required this.onTap,
  });

  @override
  State<_DropdownMenuItem> createState() => _DropdownMenuItemState();
}

class _DropdownMenuItemState extends State<_DropdownMenuItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeInOut,
            margin: EdgeInsets.only(bottom: widget.isLast ? 0 : 2),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: widget.isSelected
                  ? AppColors.primary
                  : _isHovered
                      ? AppColors.primary.withValues(alpha: 0.08)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Text(
              widget.label,
              style: TextStyle(
                fontSize: 14,
                fontWeight:
                    widget.isSelected ? FontWeight.w600 : FontWeight.w400,
                color: widget.isSelected ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
