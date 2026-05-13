import 'package:flutter/material.dart';

void main() {
  runApp(const KitapKatalogApp());
}

class KitapKatalogApp extends StatelessWidget {
  const KitapKatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kitap Dünyası',
      theme: ThemeData(primarySwatch: Colors.indigo, useMaterial3: true),
      home: const KatalogAnaSayfa(),
    );
  }
}

class KatalogAnaSayfa extends StatefulWidget {
  const KatalogAnaSayfa({super.key});

  @override
  State<KatalogAnaSayfa> createState() => _KatalogAnaSayfaState();
}

class _KatalogAnaSayfaState extends State<KatalogAnaSayfa> {
  final List<Map<String, String>> sepet = [];
  final List<Map<String, String>> kitaplar = [
    {"ad": "Sefiller", "yazar": "Victor Hugo", "fiyat": "150 TL", "tur": "Klasik", "ozet": "Jean Valjean'ın kürek mahkumiyetinden kurtulup hayatını yeniden kurma çabasını ve müfettiş Javert ile olan amansız takibini anlatan ölümsüz bir eser."},
    {"ad": "1984", "yazar": "George Orwell", "fiyat": "120 TL", "tur": "Distopya", "ozet": "Büyük Birader'in her şeyi izlediği, düşünce suçunun yasak olduğu karanlık bir gelecekte, Winston Smith'in sisteme karşı başkaldırısını konu alır."},
    {"ad": "Simyacı", "yazar": "Paulo Coelho", "fiyat": "90 TL", "tur": "Roman", "ozet": "Endülüslü çoban Santiago'nun Mısır piramitlerinin eteklerinde hazinesini aramak için çıktığı yolculuğu anlatan ilham verici bir hikaye."},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kitap Keşfet", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SepetSayfasi(sepet: sepet))),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
           
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Kitap ara...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: kitaplar.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.book, color: Colors.indigo),
                    title: Text(kitaplar[index]["ad"]!),
                    subtitle: Text(kitaplar[index]["yazar"]!),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => KitapDetaySayfasi(kitap: kitaplar[index], sepet: sepet)));
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class KitapDetaySayfasi extends StatelessWidget {
  final Map<String, String> kitap;
  final List<Map<String, String>> sepet;
  const KitapDetaySayfasi({super.key, required this.kitap, required this.sepet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(kitap["ad"]!)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Icon(Icons.book, size: 120, color: Colors.indigo[100])),
            const SizedBox(height: 20),
            Text(kitap["ad"]!, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            Text(kitap["yazar"]!, style: const TextStyle(fontSize: 18, color: Colors.grey)),
            const SizedBox(height: 20),
            const Text("Açıklama", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(kitap["ozet"]!, style: const TextStyle(fontSize: 16, height: 1.5)),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(kitap["fiyat"]!, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
                  onPressed: () {
                    sepet.add(kitap);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Sepete Eklendi!"), duration: Duration(seconds: 1)));
                  },
                  child: const Text("Sepete Ekle"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class SepetSayfasi extends StatefulWidget {
  final List<Map<String, String>> sepet;
  const SepetSayfasi({super.key, required this.sepet});

  @override
  State<SepetSayfasi> createState() => _SepetSayfasiState();
}

class _SepetSayfasiState extends State<SepetSayfasi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sepetim")),
      body: widget.sepet.isEmpty 
          ? const Center(child: Text("Sepetiniz boş.")) 
          : ListView.builder(
              itemCount: widget.sepet.length,
              itemBuilder: (context, index) => ListTile(
                leading: const Icon(Icons.book, color: Colors.indigo),
                title: Text(widget.sepet[index]["ad"]!), 
                subtitle: Text(widget.sepet[index]["fiyat"]!),
                // SEPETTEN ÇIKARMA BUTONU
                trailing: IconButton(
                  icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      widget.sepet.removeAt(index);
                    });
                  },
                ),
              ),
            ),
      bottomNavigationBar: widget.sepet.isEmpty 
          ? null 
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, 
                  foregroundColor: Colors.white, 
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {}, 
                child: const Text("Ödemeye Geç", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
    );
  }
}