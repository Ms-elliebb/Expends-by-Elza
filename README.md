# Expends - Harcama Takip Uygulaması

Bu proje, Flutter ile geliştirilmiş, kullanıcıların günlük harcamalarını ve alışveriş listelerini kolayca yönetmelerini sağlayan modern ve sezgisel bir mobil uygulamadır.

## 🚀 Temel Özellikler

*   **Harcama Geçmişi:** Yapılan tüm harcamaları listeleyin, kategoriye göre filtreleyin ve aylık özetleri görüntüleyin.
*   **Alışveriş Listesi:** Dinamik alışveriş listeleri oluşturun. Satın alınan ürünleri işaretleyin ve listenizi düzenleyin.
*   **Veri Depolama:** Tüm verileriniz, hızlı ve güvenli bir şekilde cihazınızda saklanır. İnternet bağlantısı olmadan da uygulamayı kullanabilirsiniz.
*   **Modern Arayüz:** `Material Design` prensipleri ve özel fontlarla tasarlanmış, kullanıcı dostu ve şık bir arayüz.

## 🛠️ Kullanılan Teknolojiler ve Kütüphaneler

*   **Framework:** [Flutter](https://flutter.dev/)
*   **Programlama Dili:** [Dart](https://dart.dev/)
*   **Durum Yönetimi (State Management):** [Provider](https://pub.dev/packages/provider) - Uygulama genelindeki state'i verimli bir şekilde yönetmek için.
*   **Yerel Veritabanı:** [Hive](https://pub.dev/packages/hive) - Hızlı ve hafif bir NoSQL veritabanı. Cihaz üzerinde veri depolamak için kullanıldı.
*   **Yardımcı Kütüphaneler:**
    *   **[google_fonts](https://pub.dev/packages/google_fonts):** Uygulama genelinde özel fontlar kullanmak için.
    *   **[intl](https://pub.dev/packages/intl):** Tarih ve sayı formatlaması gibi uluslararasılaştırma işlemleri için.
    *   **[path_provider](https://pub.dev/packages/path_provider):** Dosya sisteminde veritabanı gibi dosyaları depolamak için doğru yolu bulur.
*   **Kod Kalitesi ve Üretkenlik:**
    *   **[flutter_lints](https://pub.dev/packages/flutter_lints):** Kod standartlarını ve kalitesini yüksek tutmak için.
    *   **[build_runner](https://pub.dev/packages/build_runner) & [hive_generator](https://pub.dev/packages/hive_generator):** Hive için gerekli olan TypeAdapter'ları otomatik üreterek boilerplate kodu azaltır.

## 📂 Proje Yapısı

Proje, aşağıdaki gibi modüler ve anlaşılır bir klasör yapısına sahiptir:

```
lib/
├── models/         # Veri modelleri (Product, Spending vb.)
├── providers/      # Provider state management sınıfları
├── screens/        # Uygulama ekranları (Ana Ekran, Harcama Geçmişi vb.)
├── services/       # Hive gibi servislerin yönetildiği katman
└── widgets/        # Uygulama genelinde kullanılan ortak widget'lar
```

## ⚙️ Kurulum ve Çalıştırma

1.  **Projeyi klonlayın:**
    ```bash
    git clone https://github.com/your-github-username/expends.git
    cd expends
    ```

2.  **Gerekli paketleri yükleyin:**
    ```bash
    flutter pub get
    ```

3.  **Kod üretimi için `build_runner`'ı çalıştırın (Eğer `*.g.dart` dosyaları eksikse):**
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```

4.  **Uygulamayı çalıştırın:**
    ```bash
    flutter run
    ```
