# Verificación — Cómo demostrar que el trabajo funciona

> **TEMPLATE — rellenar al iniciar el proyecto.**
> Regla de oro: **el agente no dice "funciona", lo demuestra**.
> Toda feature termina con evidencia ejecutable, no con afirmaciones.

## Niveles de verificación

### Nivel 1 — Tests unitarios (obligatorio)

Toda función / módulo público en `src/` tiene al menos un test que:

1. Cubre el camino feliz.
2. Cubre al menos un camino de error si la función puede fallar.

**Comando para ejecutar todos los tests:**

```bash
TODO: comando concreto, ej:
  pnpm test
  dotnet test
  python3 -m pytest
```

### Nivel 2 — Test de integración (obligatorio para features de UI / API)

> **TODO:** describe cómo se prueban las features que cruzan capas.

Ejemplo (CLI / API):

```bash
TODO: ejemplo concreto de integración end-to-end ligera
```

Ejemplo (frontend):

```bash
TODO: ¿hay tests E2E? ¿con qué herramienta? (Playwright, Cypress)
```

### Nivel 3 — Smoke test manual (opcional pero recomendado)

> **TODO:** un flujo end-to-end manual que validas tú antes de cerrar la sesión.

```bash
TODO: secuencia de comandos / pasos
```

### Nivel 4 — Trazabilidad de requirements (obligatorio para features con `"sdd": true`)

Cada `R<n>` de `specs/<nn>-<name>/requirements.md` debe poder mapearse a al
menos un test concreto. El reviewer rechaza si falta cobertura.

El implementer documenta el mapa en `progress/implementations/<name>.md`:

```markdown
## Trazabilidad
- R1 → `test_xxx`
- R2 → `test_yyy`
- R3 → `test_zzz`
```

Ver `proceso/specs.md (plugin harness)` para el proceso SDD completo y la notación EARS.

## Anti-patrones (no hacer)

- ❌ "He añadido la feature, debería funcionar." → falta test ejecutable.
- ❌ Test que solo verifica que la función no lanza excepción. → tiene que
  comprobar el resultado concreto.
- ❌ Mocks excesivos del entorno cuando un recurso real (tempdir, sqlite
  in-memory) es viable.
- ❌ Marcar la feature como `done` sin pasar `./init.sh`.
- ❌ Añadir tests que solo se llaman a sí mismos (espejos del código).

## Los tres modos de `init.sh`

| Comando | Qué hace | Cuándo |
|---|---|---|
| `./init.sh --state` | Valida `feature_list.json` y la presencia de specs | Comprobar coherencia sin pagar tests |
| `./init.sh --fast` | Estado + type check, **sin** suite | Lo lanza el hook tras tocar código |
| `./init.sh` | Todo: estado, tipos, lint y formato (si el proyecto los tiene configurados) y la suite | Arranque, antes de cerrar, y el reviewer |

El hook `PostToolBatch` corre `--fast` **solo si el lote tocó código fuente**:
editar `.md`, `progress/`, `specs/` o `docs/` no dispara nada. La suite completa
la lanza el hook `SubagentStop` cuando el implementer termina.

## Verificación final antes de cerrar

```bash
./init.sh           # debe terminar con [OK] Entorno listo
```

Si `./init.sh` está rojo, **no** marques nada como `done`. Anota el bloqueo
en `progress/current.md` con estado `blocked` en `feature_list.json`.

## Criterios mínimos por feature

> Plantilla mental al cerrar una feature:

- [ ] La feature cumple TODOS los criterios de su `acceptance` en `feature_list.json`.
- [ ] Hay tests que cubren los criterios de aceptación (no solo el "happy path").
- [ ] `./init.sh` termina verde.
- [ ] El reviewer ha emitido veredicto `APPROVED`.
- [ ] `progress/current.md` describe lo que se hizo.
