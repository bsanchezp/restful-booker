# Informe de Estrategia de Automatización

## 1. Objetivo

Automatizar la validación funcional del módulo de Usuarios de la API pública ServeRest, cubriendo las cinco operaciones CRUD solicitadas (listar, registrar, buscar por ID, actualizar y eliminar), con casos positivos y negativos, validación de esquemas JSON y datos de prueba generados dinámicamente.

## 2. Herramientas y stack

- **Karate DSL 1.4.0** sobre **Maven** y **JUnit 5**, por su capacidad de combinar sintaxis Gherkin legible con aserciones potentes de JSON sin necesidad de código de aplicación adicional.
- Ejecución vía `mvn test`, con reportes HTML generados automáticamente por Karate.

## 3. Organización del proyecto

Se adoptó una organización **por dominio/entidad** en lugar de por tipo de archivo:

- `usuarios/`: todos los feature files del módulo, agrupados por operación.
- `schemas/`: contratos JSON desacoplados de los features, reutilizables entre escenarios.
- `helpers/`: generación de datos de prueba en JavaScript, separada de la lógica de los tests.
- `runners/`: un runner específico por módulo (`UsuariosRunner`) y uno general (`AllFeaturesRunner`), lo que permite ejecutar subconjuntos de la suite sin modificar configuración.

Esta separación facilita la escalabilidad: agregar un nuevo módulo (por ejemplo, "productos" o "carrinhos" de ServeRest) implicaría replicar la misma carpeta `usuarios/` sin tocar el resto del proyecto.

## 4. Patrones aplicados

- **Background reutilizable**: cada feature define en su `Background` la URL base y las lecturas de schemas/helpers necesarias, evitando repetición dentro de los escenarios.
- **Generación dinámica de datos**: `usuario-data.js` crea un usuario con email único (basado en UUID) en cada llamada, evitando colisiones por duplicidad de email —una restricción real de la API— y eliminando dependencia de datos fijos/hardcodeados.
- **Validación de esquema, no solo de valores puntuales**: se usa `match response == schema` para verificar la forma completa de la respuesta (tipos y presencia de campos), además de aserciones puntuales sobre valores de negocio.
- **Scenario Outline** para cubrir múltiples variantes de "campo faltante" en la creación de usuarios sin duplicar escenarios.
- **Tags** (`@positivo`, `@negativo`, `@e2e`) para poder ejecutar subconjuntos de la suite según necesidad (por ejemplo, correr solo negativos en un pipeline de smoke test).
- **Feature end-to-end independiente**: además de los tests unitarios por endpoint, se incluye un escenario que recorre el ciclo de vida completo de un usuario (crear → listar → buscar → actualizar → eliminar → confirmar eliminación), simulando el flujo real de un administrador.
- **Aislamiento de datos entre corridas**: cada escenario crea sus propios datos de prueba y no depende de estado dejado por ejecuciones previas.

## 5. Cobertura de casos negativos

Se priorizaron los errores de negocio más representativos de la API:

- Registro con email duplicado.
- Registro con campos obligatorios faltantes (nombre, email, password, administrador).
- Búsqueda, actualización y eliminación sobre IDs inexistentes.
- Filtro de listado sin resultados.

## 6. Limitaciones y consideraciones

- ServeRest es un servicio público compartido; los tests no controlan el estado inicial de la base de datos, por lo que se evita depender de datos fijos y se generan usuarios propios en cada corrida.
- El comportamiento de `PUT` sobre un ID inexistente (si crea un registro nuevo y con qué código de estado) puede variar según la versión del servicio; el escenario correspondiente usa una aserción flexible.

