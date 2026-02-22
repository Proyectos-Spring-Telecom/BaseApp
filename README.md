# Flutter - Base Project

Proyecto base Flutter con arquitectura limpia y escalable.

## Características

- Login con autenticación mock
- Menú lateral (Drawer)
- Navegación con Bottom Navigation (3 tabs)
- Perfil de usuario
- Cambio de contraseña
- Cambio de tema (claro/oscuro)
- Cierre de sesión

## Arquitectura

El proyecto sigue una arquitectura Clean Architecture / Feature-based:

```
lib/
├── core/                    # Funcionalidades transversales
│   ├── constants/           # Constantes de la app y API
│   ├── errors/              # Manejo de errores y excepciones
│   ├── network/             # Cliente HTTP y utilidades de red
│   ├── router/              # Configuración de rutas (go_router)
│   ├── theme/               # Temas y colores
│   └── utils/               # Utilidades y extensiones
│
├── data/                    # Capa de datos
│   ├── datasources/         # Fuentes de datos (local/remote)
│   ├── models/              # Modelos de datos
│   └── repositories/        # Implementación de repositorios
│
├── domain/                  # Capa de dominio
│   ├── entities/            # Entidades de negocio
│   ├── repositories/        # Contratos de repositorios
│   └── usecases/            # Casos de uso
│
├── presentation/            # Capa de presentación
│   ├── auth/                # Módulo de autenticación
│   ├── home/                # Módulo principal
│   ├── controllers/         # Controladores y providers
│   └── widgets/             # Widgets reutilizables
│
└── main.dart
```

## Tecnologías

- **Flutter** - Framework UI
- **QuickAlerts** - Alert Dialogs de pub.dev
- **Riverpod** - Gestión de estado
- **go_router** - Navegación declarativa
- **shared_preferences** - Almacenamiento local
- **http** - Cliente HTTP (preparado para REST)
- **equatable** - Comparación de objetos

## Credenciales de Demo

```
Email: admin@test.com
Password: 123456
```

## Ejecutar el proyecto

```bash
# Obtener dependencias
flutter pub get

# Ejecutar en modo debug
flutter run

# Compilar APK
flutter build apk

# Compilar iOS
flutter build ios
```

## Próximos pasos

1. Conectar con API REST real
2. Implementar autenticación con tokens JWT
3. Agregar más módulos según necesidades
4. Implementar tests unitarios y de integración
