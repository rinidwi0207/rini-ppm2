import 'package:flutter/material.dart';

// ============================================================
// GANTI DATA DI BAWAH INI DENGAN DATA ANDA
// ============================================================
const String kNama = 'Rini Dwi Yulianti';
const String kNim = '20240040159';
const String kProdiKelas = 'Teknik Informatika / Kelas TI24D';
// ============================================================

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PPM Sesi 2',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        // Warna tema pilihan (ubah sesuai selera)
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: const HomePage(),
    );
  }
}

/// Halaman utama: Scaffold + AppBar + body berisi Promo, Profil, dan Produk.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('PPM Sesi 2 - $kNama ($kNim)'),
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            PromoBanner(),
            SizedBox(height: 16),
            ProfileCard(nama: kNama, nim: kNim, prodiKelas: kProdiKelas),
            SizedBox(height: 16),
            ProductCard(
              namaProduk: 'Sepatu Sneakers Pria',
              kategori: 'Fashion',
              harga: 250000,
            ),
          ],
        ),
      ),
    );
  }
}

/// Banner promo sederhana menggunakan Stack dan Positioned.
class PromoBanner extends StatelessWidget {
  const PromoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      height: 130,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [scheme.primary, scheme.tertiary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Lingkaran dekoratif
          Positioned(
            right: -20,
            top: -20,
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white.withValues(alpha: 0.15),
            ),
          ),
          Positioned(
            right: 40,
            bottom: -30,
            child: CircleAvatar(
              radius: 45,
              backgroundColor: Colors.white.withValues(alpha: 0.12),
            ),
          ),
          // Label diskon di pojok kanan atas
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'DISKON 30%',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
          // Teks promo di kiri bawah
          const Positioned(
            left: 16,
            bottom: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Promo Akhir Tahun',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Belanja hemat, kualitas tetap hebat!',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Kartu profil mahasiswa (StatelessWidget).
class ProfileCard extends StatelessWidget {
  final String nama;
  final String nim;
  final String prodiKelas;

  const ProfileCard({
    super.key,
    required this.nama,
    required this.nim,
    required this.prodiKelas,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 38,
              backgroundColor: scheme.primaryContainer,
              child: Icon(
                Icons.person,
                size: 44,
                color: scheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nama,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text('NIM: $nim'),
                  Text(prodiKelas),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(
                      5,
                      (_) =>
                          const Icon(Icons.star, color: Colors.amber, size: 24),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Kartu produk (StatefulWidget).
class ProductCard extends StatefulWidget {
  final String namaProduk;
  final String kategori;
  final int harga;

  const ProductCard({
    super.key,
    required this.namaProduk,
    required this.kategori,
    required this.harga,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isFavorite = false;
  int _likeCount = 10;
  int _qty = 1;

  int get _totalHarga => widget.harga * _qty;

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
      _likeCount += _isFavorite ? 1 : -1;
    });
  }

  void _decrement() {
    if (_qty > 1) {
      setState(() => _qty--);
    }
  }

  void _increment() {
    setState(() => _qty++);
  }

  void _addToCart() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            '$_qty x ${widget.namaProduk} ditambahkan ke keranjang '
            '(${_formatRupiah(_totalHarga)})',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
  }

  /// Format angka menjadi "Rp 250.000" tanpa package tambahan.
  String _formatRupiah(int value) {
    final digits = value.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      final posisiDariKanan = digits.length - i;
      buffer.write(digits[i]);
      if (posisiDariKanan > 1 && posisiDariKanan % 3 == 1) {
        buffer.write('.');
      }
    }
    return 'Rp $buffer';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 3,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Placeholder gambar produk + badge kategori (Stack & Positioned)
          Stack(
            children: [
              Container(
                height: 170,
                width: double.infinity,
                color: scheme.primaryContainer,
                child: Icon(
                  Icons.shopping_bag,
                  size: 80,
                  color: scheme.onPrimaryContainer,
                ),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: scheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.kategori,
                    style: TextStyle(
                      color: scheme.onPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nama produk + tombol Favorite
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.namaProduk,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: _toggleFavorite,
                      tooltip: 'Favorite',
                      icon: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: _isFavorite ? Colors.red : Colors.grey,
                      ),
                    ),
                    Text(
                      '$_likeCount Like',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Text('Kategori: ${widget.kategori}'),
                const SizedBox(height: 4),
                Text(
                  'Harga: ${_formatRupiah(widget.harga)}',
                  style: TextStyle(
                    fontSize: 16,
                    color: scheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Divider(height: 24),
                // Pengatur jumlah (- dan +)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Jumlah',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Row(
                      children: [
                        IconButton.outlined(
                          onPressed: _qty > 1 ? _decrement : null,
                          icon: const Icon(Icons.remove),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            '$_qty',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton.outlined(
                          onPressed: _increment,
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Total harga
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: scheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Harga'),
                      Text(
                        _formatRupiah(_totalHarga),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Tombol Tambah ke Keranjang
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _addToCart,
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text('Tambah ke Keranjang'),
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
