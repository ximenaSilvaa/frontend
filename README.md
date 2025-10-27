# TemplateReto451 - Aplicación iOS de Autenticación

## Descripción General del Proyecto

TemplateReto451 es una aplicación iOS segura de autenticación construida con SwiftUI, implementando medidas de seguridad comprehensivas alineadas con el Estándar de Verificación de Seguridad de Aplicaciones Móviles OWASP (MASVS). La aplicación proporciona funcionalidad de registro de usuarios, inicio de sesión y gestión de perfiles con protecciones de seguridad de nivel empresarial.

## Tabla de Contenidos

1. [Requisitos del Sistema](#requisitos-del-sistema)
2. [Instalación](#instalación)
3. [Arquitectura](#arquitectura)
4. [Implementación de Seguridad](#implementación-de-seguridad)
5. [Integración de API](#integración-de-api)
6. [Estructura del Proyecto](#estructura-del-proyecto)
7. [Flujo de Desarrollo](#flujo-de-desarrollo)
8. [Pruebas](#pruebas)
9. [Contribuciones](#contribuciones)
10. [Licencia](#licencia)

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
│   └── Models/
│       ├── UserLoginResponse.swift
│       ├── RegisterResponse.swift
│       └── [Otros DTOs]
│
├── ViewModels/
│   └── AuthenticationViewModel.swift     (Lógica de autenticación)
│
├── Views/
│   ├── Screens/
│   │   └── Login, Register, Welcome/
│   │       ├── LoginScreen.swift
│   │       ├── ScreenUserRegistration.swift
│   │       └── WelcomeScreen.swift
│   │
│   ├── Components/
│   │   ├── SecurePasswordField.swift     (Entrada segura de contraseña)
│   │   ├── SecureFieldWithToggle.swift   (Deprecado)
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
    └── SECURITY_FIX_PII_LOGGING.md
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
