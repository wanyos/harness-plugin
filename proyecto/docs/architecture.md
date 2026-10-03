# Arquitectura — Qué significa "hacer un buen trabajo"

> **Guía de relleno — este documento es TUYO (humano).** El agente puede
> proponer un borrador en el setup, pero las decisiones de arquitectura las
> posees tú: son las que, si las decide el agente en silencio, no reconocerás
> dentro de tres semanas. Revisa cada `PROPUESTA — confirmar` antes de darla
> por buena.
>
> Nivel de detalle esperado (ejemplo para un backend Fastify + Prisma):
>
> - **Principio:** "La capa HTTP (rutas) no contiene lógica de negocio: solo
>   valida entrada, llama a un servicio y formatea la salida. La lógica vive
>   en `services/`." Un principio es una regla que permite decir si un PR
>   está bien o mal, no una buena intención vaga.
> - **Estructura de carpetas:** un árbol real, no genérico. Ej:
>   `src/routes/` (endpoints), `src/services/` (lógica), `src/db/` (Prisma
>   client y queries), `src/schemas/` (validación Zod/Typebox).
> - **Flujo de datos:** "Request → ruta valida con schema → servicio aplica
>   lógica → repositorio habla con Prisma → respuesta formateada." En una
>   línea se ve por dónde entra y sale un dato.
> - **Qué NO hacer:** prohibiciones concretas y verificables. Ej: "No llamar
>   a Prisma directamente desde una ruta", "No devolver el modelo de Prisma
>   tal cual en la respuesta; mapéalo a la forma del contrato de la API".

> **TEMPLATE — rellenar al iniciar el proyecto, ampliar con cada decisión.**
> Este documento define el estándar de calidad. Los agentes revisores
> evalúan código contra este archivo. Si no está aquí, no es un requisito.

## Principios

> Lista entre 3 y 7 principios. Demasiados se vuelven ruido. Cada uno debe
> ser ejecutable: un revisor tiene que poder decir "esto cumple / no cumple".
>
> **Un principio que se puede comprobar mirando los archivos del repositorio se
> comprueba con un test** que, al fallar, dice archivo y línea (qué carpeta
> importa a cuál, dónde se lee la configuración, qué no puede aparecer en un
> archivo). Una regla que los agentes tienen que recordar se incumple en cuanto
> uno no la lee. Un hook de git no sustituye a ese test: no corre en
> `./init.sh` y se salta con `--no-verify`.

1. **TODO: Principio 1.**
   Ejemplo: "Capas claras. Solo existen las capas X, Y, Z. No introducir
   capas nuevas sin documentar la decisión aquí."

2. **TODO: Principio 2.**
   Ejemplo: "Errores explícitos. Las funciones que pueden fallar lanzan
   excepciones nombradas, no devuelven null/undefined."

3. **TODO: Principio 3.**
   Ejemplo: "Sin estado global mutable salvo en stores designados."

4. **TODO: Principio 4.** (opcional)

5. **TODO: Principio 5.** (opcional)

## Estructura de carpetas

```
TODO: árbol de carpetas que describe la estructura esperada.

Ejemplo (frontend Vue):
src/
  features/<feature>/
    components/
    composables/
    views/
    store.ts
    service.ts
  shared/
  services/
  router/
```

## Flujo de datos

> **TODO:** describe cómo viajan los datos a través del sistema. Un diagrama
> en ASCII suele bastar.

```
TODO: Ejemplo
usuario → componente → composable → service → API
                    ↑                          ↓
                    └──────── store ←──────────┘
```

## Decisiones de arquitectura (ADRs)

> Cada decisión importante se anota aquí en formato ADR mínimo. Al volver
> al proyecto en un mes, agradeces que esté escrito.

### ADR-000: TODO — Plantilla de ADR

- **Fecha:** YYYY-MM-DD
- **Estado:** propuesta / aceptada / superada
- **Contexto:** qué problema/decisión teníamos delante.
- **Decisión:** qué se decidió.
- **Alternativas consideradas:** qué se descartó y por qué.
- **Consecuencias:** qué implica esta decisión a futuro.
- **Lo que NO cubre:** qué casos quedan fuera a sabiendas, para que nadie tome
  el verde de los tests por una garantía que la decisión no da.

Cuando una feature posterior cambia la decisión, **no se reescribe el ADR**: se
añade arriba una línea «**Revisado el YYYY-MM-DD por la feature N `<name>`:** qué
cambió y por qué», y se corrige el apartado afectado. Si la decisión se sustituye
entera, el ADR pasa a `Estado: superada por ADR-NNN`.

## Qué NO hacer

> Anti-patrones específicos de este proyecto. Lista lo que ya hayas visto
> que el agente tiende a hacer mal y quieres evitar.

- **TODO:** ejemplo: "No usar console.log para errores. Usar el logger
  configurado y devolver el error normalizado."
- **TODO:** ejemplo: "No mezclar lógica de negocio con componentes UI."
- **TODO:** ejemplo: "No añadir librerías nuevas sin discutir el trade-off
  primero (cambio de status a `blocked` en feature_list.json)."
