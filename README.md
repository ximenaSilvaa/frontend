# TemplateReto451 - FalconAlert

## Descripción General del Proyecto

TemplateReto451 es una aplicación iOS de seguridad comunitaria diseñada para reportar y documentar sitios web fraudulentos, estafas cibernéticas y amenazas en línea. Construida con SwiftUI, implementa medidas de seguridad comprehensivas alineadas con el Estándar de Verificación de Seguridad de Aplicaciones Móviles OWASP (MASVS).

La aplicación permite a usuarios registrarse, autenticarse y crear reportes detallados sobre sitios web sospechosos para ayudar a la comunidad a identificar y evitar fraudes. La plataforma centraliza la información de reportes en un dashboard con estadísticas y análisis en tiempo real.

## Características Principales

### Sistema de Reportes

La plataforma permite a los usuarios crear reportes detallados sobre:

1. **Sitios Web Fraudulentos**
   - Phishing y suplantación de identidad
   - Estafas bancarias en línea
   - Solicitud de datos sensibles sin protección
   - Redirecciones a páginas falsas

2. **Información del Reporte**
   - Título descriptivo del incidente
   - Descripción detallada del fraude
   - URL del sitio sospechoso
   - Evidencia fotográfica/captura de pantalla
   - Categorización por tipo de amenaza
   - Opción de reporte anónimo

3. **Estados de Reporte**
   - Pendiente de revisión
   - En verificación
   - Confirmado
   - Resuelto
   - Falso positivo

### Dashboard de Estadísticas

- Visualización de reportes recientes
- Listado de amenazas más reportadas del mes
- Alertas de seguridad para la comunidad
- Métricas de reportes por categoría

### Notificaciones

- Alertas de nuevas amenazas reportadas
- Actualizaciones de estado de reportes enviados
- Notificaciones de seguridad crítica

### Gestión de Perfil

- Registro seguro de usuarios
- Gestión de información personal
- Configuración de privacidad
- Historial de reportes enviados
- Preferencias de notificaciones

### Autenticación Segura

- Registro con validación de correo electrónico
- Inicio de sesión basado en tokens JWT
- Recuperación segura de contraseñas
- Protección contra ataques de fuerza bruta

## Tabla de Contenidos

1. [Características Principales](#características-principales)
2. [Casos de Uso](#casos-de-uso)
3. [Tipos de Amenazas Reportables](#tipos-de-amenazas-reportables)
4. [Requisitos del Sistema](#requisitos-del-sistema)
5. [Instalación](#instalación)
6. [Arquitectura](#arquitectura)
7. [Implementación de Seguridad](#implementación-de-seguridad)
8. [Integración de API](#integración-de-api)
9. [Estructura del Proyecto](#estructura-del-proyecto)
10. [Flujo de Desarrollo](#flujo-de-desarrollo)
11. [Pruebas](#pruebas)
12. [Contribuciones](#contribuciones)
13. [Licencia](#licencia)

## Casos de Uso

### Escenario 1: Usuario Detecta Phishing

Un usuario recibe un correo electrónico que parece ser de su banco, pero el sitio web parece sospechoso. Abre la aplicación TemplateReto451, crea un nuevo reporte:
1. Toma una captura de pantalla del sitio fraudulento
2. Proporciona la URL sospechosa
3. Categoriza como "Phishing Bancario"
4. Selecciona permanecer anónimo
5. Envía el reporte a la plataforma

El reporte se agrega a la base de datos de amenazas conocidas, alertando a otros usuarios potenciales.

### Escenario 2: Usuario Revisa Amenazas Actuales

Un usuario abre la aplicación y consulta el Dashboard para:
1. Ver las amenazas más reportadas este mes
2. Revisar alertas recientes de seguridad
3. Entender qué tipos de estafas son más comunes
4. Consultar sus propios reportes anteriores

Esta información educativa ayuda al usuario a protegerse mejor en línea.

### Escenario 3: Administrador Verifica Reportes

Un administrador de la plataforma accede a los reportes pendientes:
1. Revisa cada reporte nuevo
2. Verifica la legitimidad de la amenaza
3. Categoriza correctamente si es necesario
4. Actualiza el estado del reporte (Confirmado/Falso positivo)
5. Las alertas se envían a usuarios suscritos

### Impacto Comunitario

- **Educación**: Usuarios aprenden a identificar fraudes comunes
- **Prevención**: La comunidad se protege mutuamente compartiendo información
- **Reporte Seguro**: Los usuarios pueden reportar anónimamente sin temor
- **Bases de Datos de Amenazas**: Se construye un registro centralizado de sitios maliciosos

## Tipos de Amenazas Reportables

### Categorías de Fraude

1. **Phishing y Suplantación de Identidad**
   - Sitios que imitan bancos legítimos
   - Correos falsos solicitando credenciales
   - Redirecciones a páginas de login falsas

2. **Estafas Financieras**
   - Solicitud de datos bancarios sin protección
   - Transferencias de dinero fraudulentas
   - Promesas de inversiones falsas

3. **Robo de Identidad**
   - Solicitud de información personal
   - Documentos de identidad falsificados
   - Venta de datos personales

4. **Malware y Software Malicioso**
   - Descargas de software infectado
   - Distribución de virus
   - Ransomware

5. **Redes Sociales y Relaciones Falsas**
   - Perfiles falsos de celebridades
   - Romance scams
   - Solicitud de dinero en línea

6. **Estafas de Comercio Electrónico**
   - Tiendas online falsas
   - Productos no entregados
   - Cobros no autorizados

7. **Otras Amenazas**
   - Acoso cibernético
   - Contenido ilegal
   - Violación de privacidad

## Requisitos del Sistema

- Xcode 15.0 o posterior
- iOS 15.0 o superior (objetivo de despliegue)
- Swift 5.9+
- macOS 13.0 o posterior (para desarrollo)

## Instalación

### Requisitos Previos

Antes de comenzar, asegúrese de tener:
- Xcode instalado y actualizado
- Una cuenta válida de Apple Developer
- CocoaPods o Swift Package Manager (si utiliza dependencias externas)

### Instrucciones de Configuración

1. Clone el repositorio:
```bash
git clone https://github.com/ximenaSilvaa/frontend.git
cd frontend
```

2. Abra el proyecto de Xcode:
```bash
open TemplateReto451.xcodeproj
```

3. Seleccione el objetivo TemplateReto451 y configure la firma:
   - Abra la pestaña Signing & Capabilities
   - Seleccione su equipo de desarrollo
   - Actualice el identificador de paquete si es necesario

4. Construya y ejecute:
   - Seleccione un simulador o dispositivo conectado
   - Presione Cmd+R o seleccione Product > Run

## Arquitectura

### Stack Tecnológico

- **Marco de UI**: SwiftUI
- **Patrón de Arquitectura**: MVVM (Model-View-ViewModel)
- **Redes**: URLSession con HTTPClient personalizado
- **Persistencia**: iOS Keychain para datos sensibles
- **Autenticación**: Token basado (JWT con tokens de acceso y actualización)

### Capas

```
Capa de Presentación (Views)
    |
    v
Capa de ViewModel (Lógica de Negocio)
    |
    v
Capa de Repositorio/Red (HTTPClient)
    |
    v
Capa de Datos (Keychain, UserDefaults)
    |
    v
API del Backend
```

## Implementación de Seguridad

### 1. Seguridad en el Almacenamiento de Tokens

**Problema Abordado**: Prevención de exposición de tokens en texto plano

**Implementación**:
- Tokens almacenados en iOS Keychain con cifrado AES-256
- Ubicación: `Security/SecureTokenStorage.swift`
- Migración automática de UserDefaults inseguro a Keychain al iniciar la aplicación
- Protección de acceso: Los tokens solo son accesibles cuando el dispositivo está desbloqueado

**Cumplimiento**: OWASP MASVS STORAGE-1, STORAGE-2

### 2. Protección de Registro de PII

**Problema Abordado**: Prevención de exposición de Información Identificable Personal en logs

**Implementación**:
- Implementación personalizada de SecureLogger con sanitización automática
- Ubicación: `Logging/SecureLogger.swift`
- Detección basada en patrones y redacción de:
  - Direcciones de correo electrónico
  - Números de teléfono
  - Tokens de API y JWT
  - Números de Seguro Social (SSN)
  - Números de tarjeta de crédito
  - Claves sensibles personalizadas

**Características**:
- Compilaciones DEBUG: Logs detallados con sanitización
- Compilaciones RELEASE: Solo errores críticos
- Métodos seguros para registro de autenticación, red y acceso a datos

**Cumplimiento**: Artículo GDPR 5(1)(a), CCPA

### 3. Protección de Contraseñas en Memoria

**Problema Abordado**: Prevención de persistencia de contraseñas en texto plano en memoria

**Implementación**:
- Clase personalizada MemorySecureString con cifrado en memoria
- Ubicación: `Security/MemorySecureString.swift`
- Cifrado XOR con claves aleatorias de 256 bits
- Sobrescritura de memoria con memset() al limpiar
- Limpieza automática mediante deinit y método clear() explícito
- Limpieza garantizada mediante bloques defer en ViewModels

**Componente SecurePasswordField**:
- Ubicación: `Views/Components/SecurePasswordField.swift`
- Protecciones de teclado: Autocorrección y texto predictivo deshabilitados
- Protección de privacidad: Prevención de captura de pantalla mediante .privacySensitive()
- Alternancia de visibilidad de contraseña entre SecureField y TextField

**Cumplimiento**: OWASP MASVS CODE-2, CODE-4

### 4. Protección de Captura de Pantalla y App Switcher

**Problema Abordado**: Prevención de exposición de datos sensibles en captura de pantalla y app switcher

**Implementación**:
- Modificador .privacySensitive() en todas las pantallas de autenticación
- Ubicación:
  - LoginScreen.swift (Línea 192)
  - ScreenUserRegistration.swift (Línea 294)
  - SecurePasswordField.swift (Línea 65)
- Modificador personalizado PrivacyProtectionModifier para controles de privacidad reutilizables
- Ubicación: `Views/Modifiers/PrivacyProtectionModifier.swift`
- Detección de intentos de captura de pantalla y registro

**Cumplimiento**: OWASP MASVS RESILIENCE-2

### 5. Seguridad en la Red

**Implementación Planeada**:
- Cumplimiento de HTTPS (migración de HTTP a HTTPS)
- Fijación de certificados
- Versión mínima de TLS 1.3

## Integración de API

### Puntos Finales de Autenticación

La aplicación se comunica con una API de backend para autenticación de usuarios y gestión de perfiles.

### Métodos Implementados

#### Autenticación de Usuarios

1. **Registro de Usuario**
   - Punto final: POST /users/register
   - Carga útil: nombre, correo electrónico, contraseña
   - Respuesta: Objeto usuario con ID y correo electrónico

2. **Inicio de Sesión de Usuario**
   - Punto final: POST /auth/login
   - Carga útil: correo electrónico, contraseña
   - Respuesta: accessToken, refreshToken

3. **Validación de Token**
   - Punto final: GET /users/profile
   - Encabezados: Authorization (Bearer token)
   - Respuesta: Información del perfil del usuario

4. **Actualización de Token**
   - Punto final: POST /auth/refresh
   - Carga útil: refreshToken
   - Respuesta: Nuevo accessToken

#### Gestión de Reportes

5. **Crear Reporte**
   - Punto final: POST /reports/create
   - Carga útil: título, descripción, URL, categoría, imagen, es_anónimo
   - Respuesta: Confirmación de reporte creado

6. **Obtener Reportes del Usuario**
   - Punto final: GET /reports/user
   - Encabezados: Authorization (Bearer token)
   - Respuesta: Lista de reportes enviados por el usuario

7. **Obtener Todos los Reportes**
   - Punto final: GET /reports/all
   - Encabezados: Authorization (Bearer token)
   - Respuesta: Lista paginada de reportes verificados

8. **Subir Imagen de Reporte**
   - Punto final: POST /upload/report-image
   - Carga útil: Datos de imagen (multipart/form-data)
   - Respuesta: Ruta de la imagen almacenada

#### Dashboard y Estadísticas

9. **Obtener Dashboard**
   - Punto final: GET /dashboard
   - Encabezados: Authorization (Bearer token)
   - Respuesta: Alertas recientes, reportes principales del mes

10. **Obtener Categorías**
    - Punto final: GET /categories
    - Encabezados: Authorization (Bearer token)
    - Respuesta: Lista de categorías de reportes disponibles

#### Notificaciones

11. **Obtener Notificaciones**
    - Punto final: GET /notifications
    - Encabezados: Authorization (Bearer token)
    - Respuesta: Lista de notificaciones del usuario

12. **Obtener Configuración de Notificaciones**
    - Punto final: GET /settings/notifications
    - Encabezados: Authorization (Bearer token)
    - Respuesta: Preferencias de notificaciones del usuario

### Manejo de Errores

El HTTPClient implementa manejo exhaustivo de errores con integración de SecureLogger:
- Errores de red (sin internet, tiempo de espera agotado)
- Errores del servidor (códigos de estado 5xx)
- Errores del cliente (códigos de estado 4xx)
- Errores de validación

Todo el registro de errores se realiza a través de SecureLogger para prevenir la exposición de PII.

## Estructura del Proyecto

```
TemplateReto451/
├── Security/
│   ├── MemorySecureString.swift          (Cifrado en memoria)
│   └── SecureTokenStorage.swift          (Integración Keychain)
│
├── Logging/
│   └── SecureLogger.swift                (Sanitización de PII)
│
├── Networking/
│   ├── HTTPClient.swift                  (Comunicación API)
│   ├── URLEndpoints.swift                (Puntos finales API)
│   ├── Models/
│   │   ├── UserLoginResponse.swift
│   │   ├── RegisterResponse.swift
│   │   ├── ReportDTO.swift               (Modelo de reportes)
│   │   ├── DashboardDTO.swift            (Datos del dashboard)
│   │   ├── NotificationDTO.swift         (Notificaciones)
│   │   ├── CategoryDTO.swift             (Categorías de reportes)
│   │   └── [Otros DTOs]
│   └── Protocol/
│       └── HTTPClientProtocol.swift      (Interfaz de red)
│
├── ViewModels/
│   ├── AuthenticationViewModel.swift     (Lógica de autenticación)
│   ├── CreateReportViewModel.swift       (Creación de reportes)
│   ├── DashboardViewModel.swift          (Estadísticas y alertas)
│   ├── NotificationsViewModel.swift      (Gestión de notificaciones)
│   └── NotificationSettingsViewModel.swift (Configuración de notificaciones)
│
├── Views/
│   ├── Screens/
│   │   ├── Login, Register, Welcome/
│   │   │   ├── LoginScreen.swift
│   │   │   ├── ScreenUserRegistration.swift
│   │   │   └── WelcomeScreen.swift
│   │   │
│   │   ├── DashboardScreen.swift         (Pantalla principal con estadísticas)
│   │   │
│   │   ├── Profile/
│   │   │   ├── UserAllReportsScreen.swift (Reportes del usuario)
│   │   │   ├── ProfileScreen.swift
│   │   │   └── [Otras pantallas de perfil]
│   │   │
│   │   ├── Reports/
│   │   │   ├── CreateReportScreen.swift   (Crear nuevo reporte)
│   │   │   ├── ReportDetailScreen.swift   (Detalle de reporte)
│   │   │   └── [Pantallas de reportes]
│   │   │
│   │   ├── Notifications/
│   │   │   ├── NotificationsScreen.swift
│   │   │   └── ScreenNotificationSettings.swift
│   │   │
│   │   └── Settings/
│   │       └── [Pantallas de configuración]
│   │
│   ├── Components/
│   │   ├── SecurePasswordField.swift     (Entrada segura de contraseña)
│   │   ├── SecureFieldWithToggle.swift   (Deprecated)
│   │   ├── ReportCard.swift              (Tarjeta de reporte)
│   │   ├── AlertCard.swift               (Tarjeta de alerta)
│   │   └── [Otros componentes UI]
│   │
│   └── Modifiers/
│       └── PrivacyProtectionModifier.swift (Controles de privacidad)
│
├── Resources/
│   ├── Assets.xcassets
│   ├── Colors/
│   └── Strings/
│
├── Support/
│   ├── TemplateReto451App.swift          (Punto de entrada de la aplicación)
│   ├── Info.plist
│   └── Localizable.strings
│
└── Documentation/
    ├── SECURITY_FIX_TOKEN_STORAGE.md
    ├── SECURITY_FIX_PII_LOGGING.md
    └── SECURITY_FIX_PASSWORD_MEMORY.md
```

## Flujo de Desarrollo

### Directrices de Estilo de Código

- Usar nombres de variables y funciones significativos
- Seguir las Directrices de Diseño de API de Swift
- Usar comentarios MARK para organización de código
- Agregar comentarios para código complejo relacionado con seguridad
- Usar manejo adecuado de errores con bloques try-catch

### Mejores Prácticas de Seguridad

1. Nunca registre datos sensibles directamente en la consola
2. Siempre use SecureLogger para eventos de autenticación
3. Envuelva contraseñas con MemorySecureString
4. Use bloques defer para garantizar limpieza
5. Marque vistas sensibles con .privacySensitive()
6. Almacene tokens solo en Keychain, nunca en UserDefaults
7. Valide toda la entrada del usuario
8. Use HTTPS para todas las solicitudes de red

### Agregar Nuevas Funciones

1. Cree rama de función desde main
2. Implemente función con consideraciones de seguridad
3. Agregue pruebas unitarias para rutas críticas
4. Revise el código en busca de fugas de PII y almacenamiento en texto plano
5. Cree solicitud de extracción con documentación
6. Fusione después de la aprobación de revisión

## Pruebas

### Lista de Verificación de Pruebas Manuales

#### Flujo de Autenticación
- Pruebe el registro de usuario con credenciales válidas
- Pruebe el inicio de sesión con contraseñas correctas e incorrectas
- Verifique el almacenamiento de tokens en Keychain (no en UserDefaults)
- Pruebe la actualización de tokens al expirar
- Verifique que los mensajes de error sean fáciles de usar

#### Pruebas de Seguridad
1. **Registro de PII**
   - Conecte el depurador de Xcode
   - Realice inicio de sesión/registro
   - Busque direcciones de correo electrónico en Console.app
   - Esperado: No se encuentran correos electrónicos en texto plano

2. **Memoria de Contraseña**
   - Use el Depurador de Memoria de Xcode
   - Inspeccione objetos MemorySecureString
   - Verifique que la memoria se sobrescriba después de clear()

3. **Protección de Captura de Pantalla**
   - Intente captura de pantalla en pantalla de inicio de sesión
   - Verifique app switcher - verifique que no haya datos sensibles visibles
   - Pruebe con compilaciones Debug y Release

4. **Almacenamiento de Token**
   - Verifique tokens en Keychain, no en UserDefaults
   - Pruebe en simulador de dispositivo modificado
   - Confirme que los tokens no sean accesibles a través del sistema de archivos

### Pruebas Automatizadas

Las pruebas unitarias deben cubrir:
- Cifrado/descifrado de MemorySecureString
- Patrones de sanitización de SecureLogger
- Manejo de errores de HTTPClient
- Lógica de negocio de AuthenticationViewModel
- Validación de entrada en formularios

### Pruebas en Dispositivo

- Pruebe en dispositivos iOS reales (mínimo iOS 15.0)
- Pruebe en varios modelos de iPhone
- Pruebe con condiciones de red lenta
- Pruebe con backgrounding y foregrounding de aplicación

## Problemas Conocidos y Limitaciones

1. El cifrado XOR en MemorySecureString debe actualizarse a CommonCrypto o CryptoKit para producción
2. Los puntos finales HTTP necesitan migración a HTTPS
3. La fijación de certificados aún no está implementada
4. La detección de Jailbreak no está implementada
5. La protección anti-depuración no está implementada
6. Los símbolos de depuración aún están presentes en compilaciones Release

## Mejoras de Seguridad Planeadas

1. Implementar Detección de Jailbreak (JailbreakDetectionManager)
2. Implementar Detección Anti-Depuración (AntiDebuggerManager)
3. Migrar a HTTPS con fijación de certificados
4. Eliminar símbolos de depuración de compilaciones Release
5. Implementar ofuscación de cadenas
6. Agregar mecanismo de actualización de aplicación forzada
7. Implementar mecanismos anti-tampering
8. Eliminar declaraciones print() del código de producción

## Cumplimiento

### Estándares

- Estándar de Verificación de Seguridad de Aplicaciones Móviles OWASP (MASVS)
- Guía de Pruebas de Aplicaciones Móviles OWASP (MASTG)
- GDPR (Reglamento General de Protección de Datos)
- CCPA (Ley de Privacidad del Consumidor de California)

### Historial de Auditoría

| Vulnerabilidad | Severidad | Estado | Fecha de Corrección |
|---|---|---|---|
| Tokens en UserDefaults | Crítica | CORREGIDA | 2025-10-26 |
| PII en Logs | Crítica | CORREGIDA | 2025-10-26 |
| Contraseñas en Texto Plano | Crítica | CORREGIDA | 2025-10-26 |
| Protección de Captura de Pantalla Faltante | Alta | CORREGIDA | 2025-10-26 |

## Contribuciones

### Requisitos de Revisión de Código

Todas las solicitudes de extracción deben:
1. Incluir evaluación de seguridad
2. No tener fugas de PII en logs
3. Usar SecureLogger para eventos de autenticación
4. Implementar manejo adecuado de errores
5. Incluir pruebas unitarias para rutas críticas
6. Actualizar documentación según sea necesario

### Reportar Problemas de Seguridad

Las vulnerabilidades de seguridad NO deben reportarse públicamente. Por favor, envíe reportes de seguridad al equipo de desarrollo directamente.

## Licencia

Este proyecto es propiedad intelectual. Todos los derechos reservados.

---

## Soporte y Contacto

Para problemas técnicos o preguntas sobre la implementación de seguridad, contacte al equipo de desarrollo.

**Última Actualización**: 26 de Octubre de 2025
**Versión Actual**: 1.0.0
**Estado**: Desarrollo Activo
