// lib/services/news_service.dart
import 'package:mi_app_velneo/models/news_model.dart';

class NewsService {
  // Datos mock que simulan la respuesta de API
  static List<NewsModel> getMockNews() {
    return [
      NewsModel(
        id: '1',
        title: 'Pascua no meu barrio',
        content: '''
Esta Pascua celebramos en nuestro querido barrio con actividades especiales para toda la familia.

Disfruta de:
• Actividades para niños
• Conciertos al aire libre
• Mercadillo de artesanía local
• Gastronomía tradicional

¡Te esperamos para vivir juntos estas fiestas tan especiales!

Más información en nuestros comercios asociados.
        ''',
        imageUrl:
            "assets/images/naimallos_campaign.jpg", // Sin imagen para evitar errores 404
        publishDate: DateTime(2025, 3, 28),
        category: 'Eventos',
        isHighlighted: true,
      ),
      NewsModel(
        id: '2',
        title: 'Campaña NaiMallos',
        content: '''
¡Nueva campaña promocional NaiMallos!

Durante todo el mes de abril, disfruta de promociones especiales en todos nuestros comercios asociados.

Beneficios de la campaña:
• Descuentos exclusivos
• Puntos dobles en tu tarjeta EU MALLOS
• Sorteos semanales
• Productos de temporada

No te pierdas esta oportunidad única de ahorrar mientras apoyas el comercio local.

¡Participa ya en la campaña NaiMallos!
        ''',
        imageUrl:
            "assets/images/naimallos_campaign.jpg", // Sin imagen para evitar errores 404
        publishDate: DateTime(2025, 4, 25),
        category: 'Promociones',
        isHighlighted: false,
      ),
      NewsModel(
        id: '3',
        title: 'Nuevo comercio asociado',
        content: '''
Damos la bienvenida a un nuevo comercio a nuestra asociación.

La familia de Distrito Mallos sigue creciendo con nuevos establecimientos que se unen a nuestro proyecto de revitalización del barrio.

¡Bienvenidos!
        ''',
        imageUrl: null,
        publishDate: DateTime(2025, 4, 10),
        category: 'Asociación',
        isHighlighted: false,
      ),
    ];
  }

  // Obtener todas las noticias
  static Future<List<NewsModel>> getAllNews() async {
    // Simular delay de API
    await Future.delayed(const Duration(milliseconds: 500));
    return getMockNews();
  }

  // Obtener noticia por ID
  static Future<NewsModel?> getNewsById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final news = getMockNews();
    try {
      return news.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  // Obtener noticias destacadas
  static Future<List<NewsModel>> getFeaturedNews() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final news = getMockNews();
    return news.where((item) => item.isHighlighted).toList();
  }
}
