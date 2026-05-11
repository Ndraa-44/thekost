/// Centralized UI strings for the TheKost application.
///
/// Keeping all user-facing text in one place makes it easy to:
/// - Maintain consistency across the app
/// - Prepare for internationalization (i18n) in the future
/// - Quickly update copy without searching through widgets
class AppStrings {
  AppStrings._(); // Prevent instantiation

  // ── App ──
  static const String appName = 'thekost.';
  static const String appTitle = 'thekost';
  static const String appTagline = 'Temukan Kos Idamanmu';

  // ── Auth ──
  static const String loginTitle = "Masuk";
  static const String loginSubtitle =
      'Silakan masuk untuk memesan properti idaman Anda.';
  static const String loginButton = 'Masuk';
  static const String registerTitle = "Daftar";
  static const String registerButton = 'Daftar';
  static const String googleLoginButton = 'Masuk Dengan Google';
  static const String googleRegisterButton = 'Daftar Dengan Google';
  static const String orDivider = 'Atau';
  static const String noAccountText = 'Belum punya akun? ';
  static const String hasAccountText = 'Sudah punya akun? ';
  static const String loginNow = 'Masuk Sekarang';
  static const String logoutTitle = 'Keluar';
  static const String logoutConfirm =
      'Apakah Anda yakin ingin keluar dari akun?';
  static const String logoutButton = 'Keluar dari Akun';
  static const String cancel = 'Batal';
  static const String loginRequired = 'Silakan Login terlebih dahulu.';
  static const String loginErrorDefault =
      'Email atau password salah. (Gunakan admin@dkost.com / admin123)';

  // ── Home / Discover ──
  static const String welcomeGreeting = 'Selamat Datang 👋';
  static const String appHeaderTitle = 'thekost. App';
  static const String heroTitle = 'Temukan Hunian\nIdeal di Jogja';
  static const String searchCategory = 'Kategori Pencarian';
  static const String searchPlaceholder = 'Temukan yang kamu cari';
  static const String locationTitle = 'Lokasi Kami di Yogyakarta';
  static const String noPropertyInLocation =
      'Belum ada properti di lokasi ini.';

  // ── Property Detail ──
  static const String facilities = 'Fasilitas';
  static const String description = 'Deskripsi';
  static const String price = 'Harga';
  static const String bookNow = 'Pesan Sekarang';
  static const String bookingContinue = 'Lanjut ke Halaman Pemesanan...';
  static const String propertyDescription =
      'Properti eksklusif ini menawarkan kenyamanan seperti hotel dengan '
      'fasilitas lengkap, cocok untuk mahasiswa dan profesional muda. '
      'Berlokasi strategis di pusat kota dengan akses mudah ke berbagai '
      'fasilitas umum.';

  // ── Booking ──
  static const String myBookings = 'Pesanan Saya';
  static const String bookingActive = 'Aktif';
  static const String bookingCompleted = 'Selesai';
  static const String bookingCancelled = 'Dibatalkan';
  static const String viewDetail = 'Lihat Detail';
  static const String total = 'Total';
  static const String checkIn = 'Check-in';
  static const String checkOut = 'Check-out';
  static const String noActiveBooking = 'Belum ada pesanan aktif.';
  static const String noCompletedBooking = 'Belum ada pesanan selesai.';
  static const String noCancelledBooking = 'Tidak ada pesanan yang dibatalkan.';

  // ── Saved / Favorites ──
  static const String favorites = 'Favorit';
  static const String noFavorites = 'Belum ada favorit';
  static const String favoriteHint =
      'Telusuri properti dan tap ikon ❤️\nuntuk menyimpannya di sini.';
  static String removedFromFavorite(String name) =>
      '$name dihapus dari favorit';
  static const String undoAction = 'Batal';

  // ── Profile ──
  static const String profile = 'Profil';
  static const String notLoggedIn = 'Anda Belum Login';
  static const String loginPromptProfile =
      'Login untuk mengelola profil,\npesanan, dan preferensi Anda.';
  static const String accountSection = 'Akun';
  static const String supportSection = 'Dukungan';
  static const String startRenting = 'Mulai Menyewakan';
  static const String startRentingSub = 'Daftar Sebagai Pemilik Kos';
  static const String myOrders = 'Pesanan Saya';
  static const String verifyAccount = 'Verifikasi Akun';
  static const String verifyAccountSub = 'Akun belum diverifikasi';
  static const String editProfile = 'Edit Profil';
  static const String paymentMethod = 'Metode Pembayaran';
  static const String notifications = 'Notifikasi';
  static const String helpCenter = 'Pusat Bantuan';
  static const String termsConditions = 'Syarat & Ketentuan';
  static const String privacyPolicy = 'Kebijakan Privasi';
  static String comingSoon(String feature) => '$feature — Segera hadir!';

  // ── Login Prompts (shared) ──
  static const String bookingLoginTitle = 'Lihat Pesanan Anda';
  static const String bookingLoginSubtitle =
      'Silakan login untuk melihat dan mengelola\npesanan properti Anda.';
  static const String savedLoginTitle = 'Simpan Favorit Anda';
  static const String savedLoginSubtitle =
      'Login untuk menyimpan properti\nyang Anda sukai.';

  // ── Search ──
  static const String searchPropertyHint = 'Cari nama properti...';
  static String propertiesFound(int count) => '$count properti ditemukan';
  static String noResultFound(String category, String location) =>
      'Tidak ada $category ditemukan\ndi $location';
  static const String changeSearch = 'Ubah Pencarian';
  static const String selectLocation = 'Pilih Lokasi';
  static const String noLocationFound = 'Tidak ada lokasi ditemukan';
  static const String selectLocationFirst = 'Pilih lokasi terlebih dahulu';

  // ── Seller Auth ──
  static const String sellerLoginTitle =
      'Masuk untuk mulai menyewakan properti anda';
  static const String sellerLoginSubtitle =
      'Daftarkan akun seller dan kelola properti Anda dengan mudah di TheKost.';
  static const String sellerLoginButton = 'Masuk sebagai Seller';
  static const String sellerNoAccount = 'Belum punya akun? ';
  static const String sellerRegisterLink = 'Daftar';
  static const String sellerRegisterTitle =
      'Masuk untuk mulai menyewakan properti anda';
  static const String sellerRegisterSubtitle =
      'Daftarkan akun seller dan kelola properti Anda dengan mudah di TheKost.';
  static const String sellerWhatsappLabel = 'No. Whatsapp';
  static const String sellerWhatsappHint = 'Masukkan nomor whatsapp aktif';
  static const String sellerWhatsappNote =
      'Nomor Whatsapp digunakan untuk verifikasi akun & komunikasi pembeli.';
  static const String sellerPasswordHint = 'Buat password akun';
  static const String sellerPasswordNote =
      'Minimal 8 karakter dengan kombinasi huruf dan angka.';
  static const String sellerConfirmPasswordLabel = 'Konfirmasi Password';
  static const String sellerConfirmPasswordHint =
      'Masukkan ulang password anda';
  static const String sellerContinueButton = 'Lanjutkan';
  static const String sellerHasAccount = 'Sudah punya akun? ';
  static const String sellerLoginLink = 'Masuk';
  static const String sellerAgreePrefix = 'Dengan mendaftar, Anda menyetujui ';
  static const String sellerTermsLink = 'Syarat & Ketentuan';
  static const String sellerAndText = ' serta ';
  static const String sellerPrivacyLink = 'Kebijakan Privasi';
  static const String sellerAgreeTheKost = ' TheKost.';

  // ── Seller WhatsApp Verification ──
  static const String sellerWaVerifyTitle = 'Verifikasi Nomor WhatsApp';
  static const String sellerWaVerifySubtitle =
      'Kami telah mengirim kode OTP ke nomor WhatsApp anda. Silahkan Masukan kode tersebut dibawah.';
  static const String sellerWaVerifyButton = 'Verifikasi Sekarang';
  static const String sellerWaNotReceived = 'Tidak menerima kode?';
  static const String sellerWaResend = 'Kirim ulang kode';

  // ── Seller Identity ──
  static const String sellerIdentityTitle = 'Lengkapi Identitas Seller';
  static const String sellerIdentitySubtitle =
      'Unggah identitas dan rekening untuk keamanan transaksi.';
  static const String sellerStepIdentity = 'Identitas';
  static const String sellerStepWaiting = 'Menunggu verifikasi';
  static const String sellerDataKtp = 'Data KTP';
  static const String sellerUploadKtp = 'Upload Foto KTP';
  static const String sellerUploadKtpFormat = 'Format: JPG, PNG, max 5MB';
  static const String sellerNamaKtp = 'Nama Sesuai KTP';
  static const String sellerNamaKtpHint = 'Contoh: Ahmad Santoso';
  static const String sellerNik = 'NIK';
  static const String sellerNikHint = '16 digit nomor induk kependudukan';
  static const String sellerRekeningTitle = 'Rekening Bank';
  static const String sellerNamaBank = 'Nama Bank';
  static const String sellerNamaBankHint = 'Contoh: BCA';
  static const String sellerNoRekening = 'Nomor Rekening';
  static const String sellerNoRekeningHint = 'Masukkan nomor rekening';
  static const String sellerNamaPemilik = 'Nama Pemilik Rekening';
  static const String sellerNamaPemilikHint =
      'Masukkan nama sesuai buku tabungan';
  static const String sellerAgreeIdentity =
      'Saya telah membaca, memahami, dan menyetujui ';
  static const String sellerIdentityTerms = 'Syarat & Ketentuan';
  static const String sellerIdentityForText = ' untuk pendaftaran seller dan ';
  static const String sellerIdentityPrivacy = 'kebijakan privasi';
  static const String sellerIdentityEnding = ' yang berlaku.';
  static const String sellerRegisterButton = 'Daftar Sebagai Seller';

  // ── Seller Verification Success ──
  static const String sellerSuccessTitle = 'Pengajuan Seller Berhasil';
  static const String sellerSuccessSubtitle =
      'Data Anda sedang ditinjau oleh tim TheKost. Setelah disetujui, Anda dapat mulai mengelola dan mempublikasikan property.';
  static const String sellerSuccessEstimation = 'Estimasi Waktu';
  static const String sellerSuccessEstimationValue =
      'Estimasi waktu verifikasi maksimal 1 x 24 jam';
  static const String sellerBackToDashboard = 'Kembali ke Dashboard';
  static const String sellerCheckStatus = 'Lihat Status Pengajuan';

  // ── Navigation ──
  static const String navDiscover = 'Discover';
  static const String navBookings = 'Bookings';
  static const String navChat = 'Chat';
  static const String navSaved = 'Saved';
  static const String navProfile = 'Profile';
}
