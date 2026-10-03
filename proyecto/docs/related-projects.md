# Proyectos relacionados

> **TEMPLATE — rellenar si este proyecto se comunica con otros.**
> Si el proyecto es independiente (no tiene frontend/backend hermano,
> ni servicios externos críticos), deja este archivo prácticamente vacío
> con la nota "Proyecto independiente, no aplica."

## ¿Tiene proyectos hermanos?

- [ ] Sí
- [ ] No → si marcas esta opción, puedes parar de leer aquí.

---

## Proyecto hermano: TODO (nombre)

### Información básica

- **Tipo:** TODO (frontend / backend / microservicio / cliente móvil)
- **Stack:** TODO (resumen de 1-2 líneas)
- **Ruta local:** TODO (ej: `../mi-backend`)
- **Repositorio:** TODO (URL si aplica)
- **URL en local:** TODO (ej: `http://localhost:3000`)
- **URL en producción:** TODO

### Relación con este proyecto

- **TODO:** describe en una frase cómo se comunican.
  Ejemplo: "Este frontend consume la API REST que expone el backend."

### Contrato / interfaz

- **TODO:** ¿cómo está definido el contrato entre los dos?
  Opciones típicas:
  - OpenAPI / Swagger spec → ruta del archivo
  - GraphQL schema → ruta del archivo
  - Archivo Markdown manual → ruta
  - tRPC / Protobuf → cómo se comparten los tipos

- **TODO:** ¿dónde vive la fuente de verdad? (normalmente el backend la genera)
- **TODO:** ¿cómo se sincroniza este proyecto con cambios del contrato?

### Endpoints / operaciones consumidas

> Lista de los endpoints o operaciones que este proyecto consume del hermano.
> Útil para que el agente sepa qué se está usando sin leer todo el código.

| Endpoint / operación | Método | Uso en este proyecto |
|----------------------|--------|----------------------|
| TODO                 | TODO   | TODO                 |

### Reglas de oro al cambiar el contrato

- **TODO:** ¿qué pasa si cambia un endpoint del backend? ¿quién avisa a quién?
- **TODO:** ¿se permite romper el contrato sin coordinación? (normalmente no).
- **TODO:** ¿hay versionado de la API? (v1, v2...).

### Permisos del agente sobre el proyecto hermano

> Importante: el agente puede **leer** el proyecto hermano pero
> **no debe escribir** en él en una sesión que no es suya.

- ✅ Permitido: leer archivos de `../proyecto-hermano/` para entender contratos,
  modelos, tipos.
- ❌ Prohibido: modificar archivos de `../proyecto-hermano/` sin que sea
  explícitamente el objetivo de la sesión actual.
- 🟡 Si una feature requiere cambios coordinados en ambos lados, anótalo en
  `progress/current.md` y deja el cambio del proyecto hermano como
  "pendiente de hacer en su propio harness".
