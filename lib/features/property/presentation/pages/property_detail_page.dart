import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../domain/entities/property.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

// --- Dummy Data Classes for UI ---
class _Facility {
  final IconData icon;
  final String label;
  const _Facility(this.icon, this.label);
}

class _Review {
  final String author;
  final String avatarUrl;
  final int rating;
  final String text;
  const _Review({
    required this.author,
    required this.avatarUrl,
    required this.rating,
    required this.text,
  });
}

/// Detail page for a single property listing (Kost, Homestay, or Villa).
class PropertyDetailPage extends StatefulWidget {
  final Property property;

  const PropertyDetailPage({super.key, required this.property});

  @override
  State<PropertyDetailPage> createState() => _PropertyDetailPageState();
}

class _PropertyDetailPageState extends State<PropertyDetailPage> {
  final ValueNotifier<bool> _isBottomBarVisible = ValueNotifier<bool>(true);

  Property get property => widget.property;

  @override
  void dispose() {
    _isBottomBarVisible.dispose();
    super.dispose();
  }

  // --- Dummy Data Definitions ---
  static const List<String> _dummyGallery = [
    'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&q=80&w=400',
    'https://images.unsplash.com/photo-1502672260266-1c1c29408447?auto=format&fit=crop&q=80&w=400',
    'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?auto=format&fit=crop&q=80&w=400',
    'https://images.unsplash.com/photo-1497366216548-37526070297c?auto=format&fit=crop&q=80&w=400',
  ];

  static const List<_Facility> _dummyFacilities = [
    _Facility(Icons.local_parking_outlined, 'Parkir Motor/Mobil'),
    _Facility(Icons.bathroom_outlined, 'Kamar Mandi dalam'),
    _Facility(Icons.bed_outlined, 'Kasur'),
    _Facility(Icons.wifi, 'Free Wi-fi'),
    _Facility(Icons.desk_outlined, 'Meja'),
    _Facility(Icons.door_sliding_outlined, 'Lemari'),
    _Facility(Icons.delivery_dining_outlined, 'Paket Sewaan'),
  ];

  static const _Review _dummyReview = _Review(
    author: 'Ahmad Sobirin',
    avatarUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
    rating: 5,
    text:
        'tempat, atau peristiwa secara rinci menggunakan kata-kata, yang bertujuan agar pembaca seolah-olah melihat',
  );

  static const String _dummyDescription =
      'Deskripsi adalah pemaparan atau penggambaran objek,tempat, atau peristiwa secara rinci menggunakan kata-kata, yang bertujuan agar pembaca seolah-olah melihat,mendengar, atau merasakan langsung apa yang dijelaskan. Teks ini melibatkan panca indra dan fokus pada karakteristik, sifat, serta detail fisik subjek';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // 1. Scrolling Content (Back layer)
          NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification.metrics.extentAfter <= 0) {
                if (!_isBottomBarVisible.value) {
                  _isBottomBarVisible.value = true;
                }
              } else if (notification is UserScrollNotification) {
                if (notification.direction == ScrollDirection.forward) {
                  if (!_isBottomBarVisible.value) {
                    _isBottomBarVisible.value = true;
                  }
                } else if (notification.direction == ScrollDirection.reverse) {
                  if (_isBottomBarVisible.value) {
                    _isBottomBarVisible.value = false;
                  }
                }
              }
              return false;
            },
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 380), // Padding to start below the static header
                Container(
                  color: AppColors.background,
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppSpacing.sm),
                      _buildGallerySection(),
                      const SizedBox(height: AppSpacing.lg),
                      _buildFacilitiesSection(),
                      const SizedBox(height: AppSpacing.lg),
                      _buildDescriptionSection(),
                      const SizedBox(height: AppSpacing.lg),
                      _buildReviewsSection(),
                      const SizedBox(height: AppSpacing.lg),
                      _buildHelpSection(),
                      const SizedBox(height: AppSpacing.lg),
                      _buildLocationSection(),
                      const SizedBox(height: 120), // Padding for bottom nav
                    ],
                  ),
                ),
              ],
            ),
          ),
          ),
          
          // 2. Fixed Header (Image + Title Card) (Front layer)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                _buildHeaderImage(),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Blocks scrolling content from peeking through margins
                    Positioned.fill(
                      child: Container(color: AppColors.background),
                    ),
                    Transform.translate(
                      offset: const Offset(0, -30),
                      child: _buildTitleCard(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Pinned Top Bar (Back Button & Badge)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.sm,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => context.pop(),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Fixed Bottom Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ValueListenableBuilder<bool>(
              valueListenable: _isBottomBarVisible,
              builder: (context, isVisible, child) {
                return AnimatedSlide(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  offset: isVisible ? Offset.zero : const Offset(0, 1.2), // 1.2 to hide completely including shadow
                  child: child,
                );
              },
              child: _buildBottomBar(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderImage() {
    return Stack(
      children: [
        Container(
          height: 300,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(property.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.4),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.4],
              ),
            ),
          ),
        ),
        // Verified Badge on the image
        Positioned(
          top: 0,
          right: 0,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.verified, color: AppColors.success, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      'Verified By TheKost',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            property.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Icon(Icons.location_on_outlined,
                  color: Colors.grey[600], size: 16),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  property.location,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGallerySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            'Galeri',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            itemCount: _dummyGallery.length + 1,
            itemBuilder: (context, index) {
              if (index == _dummyGallery.length) {
                return _buildSeeAllGalleryCard();
              }
              return Container(
                width: 120,
                margin: const EdgeInsets.only(right: AppSpacing.sm),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  image: DecorationImage(
                    image: NetworkImage(_dummyGallery[index]),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSeeAllGalleryCard() {
    return Container(
      width: 120,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Lihat',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
            Text(
              'Semua',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFacilitiesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Fasilitas',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          GridView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 4,
              crossAxisSpacing: AppSpacing.sm,
              mainAxisSpacing: AppSpacing.sm,
            ),
            itemCount: _dummyFacilities.length,
            itemBuilder: (context, index) {
              final facility = _dummyFacilities[index];
              return Row(
                children: [
                  Icon(facility.icon, size: 20, color: Colors.black87),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      facility.label,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Informasi Kost',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            _dummyDescription,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[800],
              height: 1.5,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Penilaian dan Ulasan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 18),
              const SizedBox(width: 4),
              Text(
                '${property.rating}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 4),
              const Text('•', style: TextStyle(color: Colors.grey)),
              const SizedBox(width: 4),
              const Text('45 Ulasan', style: TextStyle(color: Colors.grey)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(_dummyReview.avatarUrl),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _dummyReview.author,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < _dummyReview.rating
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 14,
                        );
                      }),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _dummyReview.text,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[800],
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        // TODO: Implement see all reviews
                      },
                      child: const Text(
                        'Lihat Semua Ulasan',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHelpSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Butuh bantuan?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          const Text(
            'Ketuk di bawah untuk hubungi customer service',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          InkWell(
            onTap: () {
              // TODO: Implement contact CS
            },
            child: Row(
              children: [
                const Icon(Icons.support_agent, color: AppColors.primary),
                const SizedBox(width: AppSpacing.sm),
                const Text(
                  'Hubungi Kami',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Lokasi',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          // Google Maps Placeholder
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              color: Colors.grey[200],
              image: const DecorationImage(
                image: NetworkImage(
                    'https://developers.google.com/static/maps/images/landing/hero_maps_static_api.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.location_on,
                color: AppColors.primary,
                size: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Saved',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            ElevatedButton(
              onPressed: () => _handleBooking(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: 8,
                ),
                minimumSize: const Size(0, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
              ),
              child: const Text(
                'Pesan Sekarang',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleBooking(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.push(AppRouter.createBookingPath, extra: property);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.loginRequired)),
      );
      context.push(AppRouter.loginPath);
    }
  }
}
