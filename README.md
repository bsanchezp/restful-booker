# Karate ServeRest - Módulo Usuarios

Suite de pruebas automatizadas para la API de Usuarios de [ServeRest](https://serverest.dev/), construida con [Karate DSL](https://karatelabs.github.io/karate/) sobre Maven y JUnit 5.

## 1. Requisitos previos

- Java 11 o superior
- Maven 3.6+

## 2. Estructura del proyecto

```
karate-serverest-usuarios/
├── pom.xml
├── README.md
├── INFORME.md
└── src/
    └── test/
        └── java/
            ├── karate-config.js          # Configuración global (baseUrl, timeouts)
            ├── runners/
            │   ├── UsuariosRunner.java    # Ejecuta solo el módulo usuarios
            │   └── AllFeaturesRunner.java # Ejecuta toda la suite
            ├── helpers/
            │   └── usuario-data.js        # Generador de datos de prueba dinámicos
            ├── schemas/
            │   ├── schema-usuario.json
            │   ├── schema-listar-usuarios.json
            │   ├── schema-mensage-error.json
            │   ├── schema-mensagen.json
            │   └── schema-crear-usuario.json
            └── usuarios/
                ├── listar-usuarios.feature
                ├── crear-usuario.feature
                ├── buscar-usuario-id.feature
                ├── actualizar-usuario.feature
                ├── eliminar-usuario.feature
                └── e2e-crud-usuarios.feature
```

> **Nota sobre el idioma:** los comentarios, nombres de escenarios y documentación están en español. Los nombres de los campos JSON (`nome`, `email`, `password`, `administrador`) y los mensajes devueltos por la API (por ejemplo `"Cadastro realizado com sucesso"`) están en portugués porque así los define el servicio real de ServeRest; no se pueden traducir sin romper las validaciones.

## 3. Cómo ejecutar los tests

Ejecutar toda la suite:

```bash
mvn test
```

Ejecutar solo el módulo de usuarios:

```bash
mvn test -Dtest=UsuariosRunner
```

Ejecutar un feature específico (ejemplo: solo creación de usuarios):

```bash
mvn test -Dkarate.options="classpath:usuarios/crear-usuario.feature"
```

Ejecutar solo los escenarios marcados como negativos:

```bash
mvn test -Dkarate.options="--tags @negativo"
```

Ejecutar contra un ambiente específico (por defecto es `dev`):

```bash
mvn test -Dkarate.env=qa
```

## 4. Reportes

Karate genera reportes HTML automáticamente tras cada ejecución en:

```
target/karate-reports/karate-summary.html
```

Ábrelo en el navegador para ver el detalle de escenarios, pasos y tiempos de ejecución.

## 5. Cobertura de pruebas

| Endpoint | Feature file | Casos positivos | Casos negativos |
|---|---|---|---|
| `GET /usuarios` | `listar-usuarios.feature` | ✔ | ✔ (filtro sin resultados) |
| `POST /usuarios` | `crear-usuario.feature` | ✔ | ✔ (email duplicado, campos faltantes) |
| `GET /usuarios/{_id}` | `buscar-usuario-id.feature` | ✔ | ✔ (ID inexistente) |
| `PUT /usuarios/{_id}` | `actualizar-usuario.feature` | ✔ | ✔ (ID inexistente) |
| `DELETE /usuarios/{_id}` | `eliminar-usuario.feature` | ✔ | ✔ (ID inexistente) |
| Flujo completo | `e2e-crud-usuarios.feature` | ✔ | — |

Para más detalle sobre las decisiones de diseño, ver [INFORME.md](./INFORME.md).
