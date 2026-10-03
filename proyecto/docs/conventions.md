# Convenciones de código

> **Guía de relleno — este documento es TUYO (humano).** Parte es descubrible
> (si ya hay linter/formatter configurado, el agente lo refleja en el setup),
> pero las preferencias —nombres, manejo de errores, comentarios— las decides
> tú. Revisa cada `PROPUESTA — confirmar`.
>
> Nivel de detalle esperado (ejemplo para TypeScript estricto):
>
> - **Estilo:** concreto y verificable. Ej: "TypeScript strict, comillas
>   simples, sin punto y coma, 2 espacios, máx. 100 cols. Formatea Prettier."
>   Si hay `.prettierrc`, que estas líneas coincidan con él, no lo contradigan.
> - **Nombres:** una regla por tipo de cosa. Ej: "Componentes Vue en
>   PascalCase; composables `useXxx`; tipos e interfaces en PascalCase sin
>   prefijo `I`; variables y funciones en camelCase."
> - **Manejo de errores:** el patrón concreto del proyecto, con un mini
>   ejemplo. Ej: "Errores de dominio extienden `AppError` con un `code`
>   string; la capa HTTP los traduce al formato de error del contrato de la
>   API. Nunca `throw` de strings sueltos."
> - **Comentarios:** política clara. Recomendación: "Por defecto NO se
>   comenta el qué (el código lo dice); se comenta el por qué cuando una
>   decisión no es obvia." Define si se permiten `TODO:` en código y con
>   qué formato.

> **TEMPLATE — rellenar al iniciar el proyecto.**
> Homogeneidad extrema. La IA predice mejor cuando el repositorio se parece
> a sí mismo en todas partes.

## Estilo del lenguaje

- **TODO:** versión del lenguaje (ej: "TypeScript estricto, target ES2022").
- **TODO:** linter / formatter usado (ej: ESLint + Prettier, Black, dotnet format).
- **TODO:** longitud máxima de línea.
- **TODO:** comillas (simples / dobles / contexto).
- **TODO:** punto y coma (sí / no, si aplica).
- **TODO:** indentación (2 espacios / 4 espacios / tabs).

## Imports / Usings

- **TODO:** orden de imports (ej: vendor → alias `@/` → relativos).
- **TODO:** ¿se usan paths absolutos con alias? ¿cuál es el alias raíz?
- **TODO:** ¿una línea por import o agrupados?

## Nombres

| Tipo                    | Convención        | Ejemplo               |
|-------------------------|-------------------|-----------------------|
| Archivos                | TODO              | TODO                  |
| Clases / tipos          | TODO              | TODO                  |
| Funciones / variables   | TODO              | TODO                  |
| Constantes              | TODO              | TODO                  |
| Booleanos               | TODO (ej: prefijo `is`, `has`) | `isLoading`, `hasError` |

## Estructura de archivo

> **TODO:** ¿cómo empieza un archivo? ¿hay un patrón estándar?

Ejemplo (frontend TypeScript):

```typescript
// Imports vendor
import { ref, computed } from 'vue'

// Imports alias
import { useAuth } from '@/features/auth/composables/useAuth'

// Imports relativos
import type { User } from './types'
```

## Tests

- **TODO:** nombre y ubicación de los archivos de test.
- **TODO:** convención de nombres de test (descriptivos en inglés / español).
- **TODO:** ¿cómo se manejan los recursos? (tempfile, in-memory db, mocks).
- **TODO:** estructura: `describe` / `test`, AAA, etc.

## Manejo de errores

- **TODO:** tipo base de errores del dominio.
- **TODO:** ¿qué tipos de error existen? ¿cuándo lanzar cada uno?
- **TODO:** ¿cómo se propagan al usuario / API consumer?
- **TODO:** ¿qué se loguea y qué no?

Ejemplo:

```typescript
// TODO: ejemplo del patrón de errores del proyecto
class DomainError extends Error { ... }
class NotFoundError extends DomainError { ... }
```

## Estructura de carpetas (recordatorio)

> Coherente con `docs/architecture.md`. Si hay conflicto, manda architecture.md.

## Comentarios

- **TODO:** política sobre comentarios. Recomendación: "Por defecto NO se
  escriben. Solo cuando explican un POR QUÉ no obvio. Los nombres deben
  hacer el resto."
- **TODO:** ¿se permiten TODOs en código? ¿con qué formato?

## Estilos / UI (si es frontend)

- **TODO:** sistema de estilos (Tailwind utility-first, CSS-in-JS, módulos).
- **TODO:** ¿se permite `@apply`? ¿en qué casos?
- **TODO:** convención de nombres de clases / variables CSS.
- **TODO:** dark mode / accesibilidad / responsive.
