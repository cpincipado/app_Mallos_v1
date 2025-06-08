import 'package:flutter/material.dart';
import 'package:mi_app_velneo/config/theme.dart';
import 'package:mi_app_velneo/utils/responsive_helper.dart';
import 'package:mi_app_velneo/views/widgets/common/custom_app_bar.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: 'Política de Privacidad',
        showBackButton: true,
        showMenuButton: false,
        showFavoriteButton: false,
        showLogo: true,
      ),
      body: SingleChildScrollView(
        padding: ResponsiveHelper.getHorizontalPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Logo
            Center(
              child: Image.asset(
                'assets/images/distrito_mallos_logo.png',
                height: 80,
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(height: 30),

            // Título principal
            const Text(
              'POLÍTICA DE PRIVACIDAD',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            // Contenido de la política de privacidad
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lea atentamente esta declaración de privacidade ("Declaración de privacidad") xa que describe a nosa práctica de recompilar, usar, divulgar, conservar e protexer os seus datos persoais. Esta declaración de privacidade aplícase a calquera sitio web, aplicación ou servizo que faga referencia a esta declaración. Cando nos proporciona ou recolle datos persoais dalgunha das formas descritas na cláusula 2 a continuación, acepta que recompilamos, almacenamos e utilizamos tales datos: (a) co fin de cumprir coas nosas obrigas contractuais con vostede; (b) polo noso interese lexítimo en tratalos (é dicir, para fins de administración interna, análise de datos e benchmarking – para máis información, ver cláusula 3 – marketing directo, mantemento de sistemas de copia de seguridade automática ou para a detección ou prevención). de delitos); ou (c) co seu propio consentimento, que pode retirar en calquera momento, segundo se describe nesta Declaración de privacidade.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 15),

                  Text(
                    'Esta Declaración de privacidade pode ser relevante para vostede aínda que non sexa o noso cliente e nunca utilizou un sitio web, aplicación ou servizo que nos pertence. Podemos ter os seus datos persoais porque os recibimos dun usuario dun dos nosos sitios web, aplicacións ou servizos.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 15),

                  Text(
                    'Brexit: as referencias nesta Declaración de privacidade ao "GDPR" incluirán calquera "RGPD do Reino Unido" creado a través da Lei de protección de datos do Reino Unido de 2018 no caso de que o Reino Unido saia da Unión Europea.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 20),

                  Text(
                    'A nosa empresa',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  SizedBox(height: 10),

                  Text(
                    'Esta Declaración de Privacidade aplícase a todos os produtos, aplicacións e servizos ofrecidos por Distrito Mallos e Ronda de Outeiro, Esquina Mallos Subterráneo s/n 15007 A Coruña, pero exclúe os produtos e aplicacións ou servizos que conteñan declaracións de privacidade independentes sen integrar a presente.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 20),

                  Text(
                    'Recollida de información',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  SizedBox(height: 10),

                  Text(
                    'Na medida en que o permita a lexislación aplicable, recompilamos datos sobre vostede e sobre calquera outra parte cuxos datos nos proporcione cando:',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 10),

                  Text(
                    '• rexistrarse para usar os nosos sitios web, aplicacións ou servizos (incluídas as probas gratuítas); Isto pode incluír o teu nome (incluído o nome da empresa), enderezo, enderezo de correo electrónico e número de teléfono. Tamén é posible que lle solicitemos información adicional sobre a súa actividade profesional e as súas preferencias;',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),

                  Text(
                    '• facer un pedido a través dos nosos sitios web, aplicacións ou servizos; Isto pode incluír o teu nome (incluído o nome da empresa), enderezo, contacto (como o teu número de teléfono e enderezo de correo electrónico) e detalles de pago;',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),

                  Text(
                    '• utilizar as nosas aplicacións, que poden incluír a recollida de metadatos;',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),

                  Text(
                    '• cubrir formularios en liña (incluídas solicitudes de devolución de chamada), participar en enquisas, publicar nos nosos taboleiros de mensaxes, blogue, participar en concursos ou sorteos, descargar información como libros brancos e outras publicacións ou participar en calquera outra área interactiva que apareza no noso sitio web ou dentro da nosa aplicación ou servizo;',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),

                  Text(
                    '• interactuar connosco a través das redes sociais;',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),

                  Text(
                    '• Ofrécenos os seus datos de contacto cando se rexistra para utilizar ou acceder a calquera sitio web, aplicación ou servizo que poñamos á súa disposición ou cando actualiza tales datos; e',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),

                  Text(
                    '• póñase en contacto connosco a través de canles non en liña, como por teléfono, fax, SMS, correo electrónico ou correo ordinario.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 15),

                  Text(
                    'Tamén recollemos os seus datos cando só completa parcialmente e/ou abandona a entrada de información no noso sitio web e/ou noutros formularios en liña; Así, é posible que utilicemos os devanditos datos co fin de poñernos en contacto contigo para lembrarche que completes os datos pendentes e/ou con fins de mercadotecnia.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 15),

                  Text(
                    'Tamén recompilamos datos dos seus dispositivos (incluídos os dispositivos móbiles) e das aplicacións que vostede ou os seus usuarios usan para acceder e utilizar calquera dos nosos sitios web, aplicacións ou servizos (por exemplo, podemos recoller o número e o tipo de identificación do dispositivo, datos de localización e información de conexión, como estatísticas sobre as súas páxinas vistas, o tráfico desde e para sitios web, URL de ligazóns anteriores, datos de anuncios, o seu enderezo IP, o seu historial de navegación e os datos de acceso ao sitio web). Para iso, podemos utilizar cookies ou tecnoloxías similares (como se describe na cláusula 11 a continuación).',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 15),

                  Text(
                    'Podemos complementar os datos persoais que recompilamos de vostede con información que obtemos de terceiros que teñen permiso para compartilos; por exemplo, información de axencias de crédito, provedores de información de busca ou fontes públicas (por exemplo, para fins de debida dilixencia do cliente), pero en cada caso conforme o permita a lexislación aplicable.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 20),

                  Text(
                    'Transferencia de datos de terceiros',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  SizedBox(height: 10),

                  Text(
                    'Se nos proporciona datos persoais doutra persoa, é responsable de asegurarse de que cumpre coas obrigas e as obrigas de consentimento en virtude da lei de protección de datos aplicable en relación con tal divulgación. Na medida en que o requira a lexislación aplicable en materia de protección de datos, debes asegurarte de ter informado debidamente á outra persoa, de que tes o seu consentimento explícito ou de que tes unha base legal para transferirnos a súa información, e que che explicou como recompilamos, utilizar, divulgar e conservar os seus datos persoais ou dirixirlle a ler a nosa Declaración de privacidade.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 20),

                  Text(
                    'Uso dos seus datos',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  SizedBox(height: 10),

                  Text(
                    'Na medida en que o permita a lexislación aplicable, utilizamos os seus datos para:',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 10),

                  Text(
                    '• proporcionar información e servizos que solicitou ou aplicacións ou servizos que solicitou;\n'
                    '• comparar a información para a súa exactitude e verificala con terceiros;\n'
                    '• proporcionar, manter, protexer e mellorar aplicacións, produtos, servizos e información que nos solicitou;\n'
                    '• xestionar e administrar o uso das aplicacións, produtos e servizos que nos solicitou;\n'
                    '• xestionar a nosa relación contigo (por exemplo, atención ao cliente e actividades de apoio);\n'
                    '• avaliar, medir, mellorar e protexer o noso contido, sitio web, aplicacións e servizos, e ofrecerlle unha experiencia de usuario mellorada e persoal;\n'
                    '• realizar probas internas do noso sitio web, aplicacións, sistemas e servizos para probar e mellorar a súa seguridade, aprovisionamento e rendemento, en cuxo caso pseudonimizaremos calquera información utilizada para tales fins e aseguraremos que só se mostra en niveis agregados que non se poden vincular a vostede ou calquera outra persoa física individualmente;\n'
                    '• proporcionarlle a información que estamos obrigados a enviarlle para cumprir coas nosas obrigas legais ou regulamentarias;\n'
                    '• cumprir con calquera outra das nosas obrigas regulamentarias ou legais;\n'
                    '• detectar, previr, investigar ou corrixir delitos, actividades ilegais ou prohibidas ou, en xeral, protexer os nosos dereitos legais (incluídas para tal fin as comunicacións cos organismos reguladores e coas forzas de seguridade);\n'
                    '• contactar contigo para ver se queres participar na nosa investigación de clientes (por exemplo, a túa opinión sobre o teu uso das nosas aplicacións, produtos e servizos);\n'
                    '• avaluar, realizar análises estatísticas e benchmarking, sempre que, en tales circunstancias, se faga de forma agregada que non se poida vincular a vostede nin a ningunha outra persoa física individualmente, salvo o que permita a lei;\n'
                    '• proporcionarche publicidade, información ou mercadotecnia dirixidas (que poden incluír mensaxes no produto) que pode resultar útil en función do uso das nosas aplicacións e servizos;\n'
                    '• ofrecer contido e servizos conxuntamente con terceiros cos que teña unha relación separada (por exemplo, provedores de redes sociais); e\n'
                    '• ofrecerche servizos vinculados á túa localización (por exemplo, publicidade e outros contidos personalizados), nos que recollemos datos de xeolocalización.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 15),

                  Text(
                    'Na medida en que o permita a lexislación aplicable, conservaremos os datos sobre vostede despois do peche da súa conta de Sage, no caso de que a súa solicitude de conta de Sage sexa denegada ou se decide non continuar co proceso. Estes datos conservaranse e utilizaranse durante o tempo permitido para fins legais, regulamentarios, de prevención de fraudes e lexítimos fins comerciais.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 20),

                  Text(
                    'Política de privacidad de datos:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  SizedBox(height: 10),

                  Text(
                    'En cumprimento da lexislación en materia de Protección de Datos de Carácter Persoal, ASOCIACION COMERCIANTES DISTRITO MALLO. infórmalle do seguinte:',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 15),

                  Text(
                    '1.- Os seus datos pasarán a formar parte dun ficheiro automatizado propiedade de ASOCIACION COMERCIANTES DISTRITO MALLO, B15590961, empresa Distrito Mallos. Ronda de Outeiro, Esquina Mallos Metro s/n 15007 A Coruña Teléfono: 981 238 164. Fax: 981 168 153 Correo electrónico: distritomallos@gmail.com , destinatario e responsable da información que voluntariamente nos facilita.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 15),

                  Text(
                    '2.- A ASOCIACION COMERCIANTES DISTRITO MALLO utilizará os teus datos para contactar contigo por correo ordinario, correo electrónico, SMS, teléfono ou por calquera outro medio electrónico con fins comerciais, de mercadotecnia, publicidade e investigación de opinión.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 15),

                  Text(
                    '3.- Se non desexa recibir información promocional e ofertas en xeral, incluídas as que lle sexan comunicadas por correo ordinario, correo electrónico, SMS, teléfono ou calquera outro medio electrónico, ou se desexa exercer os seus dereitos de acceso, rectificación, cancelación u oposición, Outeiro, Esquina Mallos Metro s/n 15007 A Coruña Teléfono: 981 238 164. Fax: 981 168 153 Correo electrónico: distritomallos@gmail.com',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 20),

                  Text(
                    'Máis información',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                  SizedBox(height: 10),

                  Text(
                    'Se tes algunha dúbida sobre como procesamos os teus datos, sobre o contido desta Declaración de privacidade, sobre os teus dereitos segundo a lexislación local, sobre como actualizamos os teus rexistros ou sobre como obter unha copia dos datos que temos sobre ti, podes escribirnos a ao noso correo electrónico distritomallos@gmail.com.',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Información de contacto
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                children: [
                  Text(
                    'Para más información sobre nuestra política de privacidad:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 15),
                  Text(
                    'distritomallos@gmail.com',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '623 74 42 26',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
