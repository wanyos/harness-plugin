
## 12. Configurar el harness para tu proyecto

> En este punto el harness ya está **instalado** (archivos copiados, exclude
> configurado, `init.sh` verde). Pero todavía es **genérico**: contiene
> plantillas con TODOs. Esta sección te explica cómo rellenarlas para que
> el harness sepa de qué va tu proyecto.
>
> Tiempo total estimado: **30-45 minutos** para un proyecto nuevo. Conviene
> hacerlo en una sesión seguida, antes de pedirle nada al agente.

### Orden recomendado de configuración

Hay un orden que minimiza idas y venidas. Conviene seguirlo:

1. `docs/stack.md` — el más rápido y el más informativo para el agente.
2. `docs/conventions.md` — segundo en importancia.
3. `docs/architecture.md` — define qué significa "buen trabajo".
4. `docs/verification.md` — cómo se demuestra que el trabajo funciona.
5. `docs/related-projects.md` — solo si hay frontend↔backend o similar.
6. `feature_list.json` — adaptar las features de ejemplo al proyecto real.

> No te saltes ninguno pensando "lo relleno luego". Si el agente lee
> `docs/conventions.md` con TODOs sin rellenar, asumirá lo que crea conveniente
> y luego tendrás que corregirle. Mejor invertir 10 minutos en cada doc al
> principio y ahorrarte horas después.

### 12.1 — `docs/stack.md`

**Qué pones aquí:** la información factual sobre el entorno técnico del
proyecto: lenguaje, framework, librerías, versiones, gestor de paquetes,
etc. No principios, no opiniones — solo datos.

**Cómo rellenarlo:**

1. Abre el archivo: `code docs/stack.md`
2. Ve a tu `package.json` / `requirements.txt` / `*.csproj` y copia las
   dependencias y versiones reales.
3. Sustituye cada `TODO:` por el valor concreto.
4. Si algo no aplica a tu proyecto (ej: "Base de datos" en un frontend
   puro), borra esa sección entera, no la dejes con "no aplica".

**Ejemplo de campo bien rellenado** (frontend Vue):

```markdown
## Framework / Runtime

- Vue 3.4 con Composition API y `<script setup>`
- Vue Router 4
- Pinia 2.1
- Runtime: Node 20+
```

**Errores típicos a evitar:**

- ❌ Dejar `TODO` sin sustituir.
- ❌ Poner versiones genéricas tipo "última" → pon la versión exacta.
- ❌ Listar todas las dependencias del `package.json` → solo las que
  forman parte del "ADN" del proyecto. Una dep transitiva como `chalk`
  no va aquí.

### 12.2 — `docs/conventions.md`

**Qué pones aquí:** las reglas de estilo y nombrado del proyecto. Cuanto
más concretas y verificables, mejor predice el agente.

**Cómo rellenarlo:**

1. Si el proyecto ya tiene código → mira cómo están escritos los archivos
   existentes y describe ese patrón. No inventes algo distinto.
2. Si el proyecto está vacío → decide tus convenciones AHORA, antes de
   que el agente las decida por ti. Una mala convención bien definida es
   mejor que ninguna convención.
3. Rellena la tabla de nombres con ejemplos reales del proyecto.
4. En "Manejo de errores", incluye un fragmento de código del patrón que
   sigues. El agente copia patrones mejor que descripciones.

**Ejemplo de regla bien escrita** (en lugar de vaga):

> ❌ Vago: "usar nombres descriptivos".
>
> ✅ Verificable: "Booleanos siempre con prefijo `is`, `has`, `should` o
> `can`. Ejemplo: `isLoading`, `hasError`, `shouldRetry`."

**Errores típicos a evitar:**

- ❌ Reglas que solo entiendes tú con contexto previo.
- ❌ "Buen sentido común" — el agente no tiene ese sentido común.
- ❌ Reglas en conflicto con el código existente. Antes de escribir una
  regla, comprueba que el código actual la cumple.

### 12.3 — `docs/architecture.md`

**Qué pones aquí:** los principios que definen "hacer un buen trabajo" en
este proyecto. Es el documento que más usa el reviewer para auditar.

**Cómo rellenarlo:**

1. **Principios** (3-7 máximo): cada uno tiene que ser ejecutable. El
   reviewer debe poder decir "esto cumple / no cumple". Si un principio es
   tan abstracto que nadie sabe verificarlo, sobra.
2. **Estructura de carpetas**: dibuja el árbol que vas a tener. No el
   genérico de `npm create vue`, sino el que TÚ decides para este
   proyecto, incluyendo dónde van features, shared, services, etc.
3. **Flujo de datos**: dibuja en ASCII cómo viajan los datos por la
   aplicación. Esto al agente le da el "mapa mental" del sistema.
4. **ADRs**: deja la sección con un ADR-001 vacío. Cada decisión
   importante que tomes durante el proyecto se anotará aquí. La primera
   sesión real probablemente añadirá uno.
5. **Qué NO hacer**: el más importante de todos. Lista los anti-patrones
   concretos de tu proyecto. Cuanto más doloroso haya sido el aprendizaje,
   más merece estar en esta lista.

**Ejemplo de principio bien escrito:**

```markdown
1. **Errores explícitos.** Las funciones que pueden fallar lanzan
   excepciones nombradas (clases que extienden `DomainError`), nunca
   devuelven `null` o `undefined` para indicar fallo. Quien llama debe
   capturar explícitamente o dejar propagar.
```

### 12.4 — `docs/verification.md`

**Qué pones aquí:** los comandos exactos y los criterios para demostrar
que una feature funciona.

**Cómo rellenarlo:**

1. **Nivel 1 — Tests unitarios**: el comando exacto. Ejemplo: `npm test`,
   `pnpm test`, `dotnet test`, `python3 -m pytest`. Pega el comando real
   que ejecutas tú.
2. **Nivel 2 — Integración**: si tu proyecto tiene tests E2E o de
   integración, describe cómo se ejecutan. Si no, escribe "Sin tests de
   integración en este momento" — eso es información válida para el agente.
3. **Nivel 3 — Smoke test manual**: opcional. Si hay un flujo manual que
   tú haces antes de cerrar, descríbelo paso a paso.
4. **Anti-patrones**: deja los del template, son útiles en cualquier
   proyecto. Añade los específicos del tuyo si los conoces.

**Tip importante:** si en este punto aún no tienes tests configurados (es
normal en un proyecto recién bootstrapped), escribe el comando que
**vas a usar** una vez los configures. Por ejemplo: "El comando será
`npm test` cuando se configure Vitest, pendiente en feature `fundamentos`."

### 12.5 — `docs/related-projects.md`

**Cuándo rellenarlo:**

- Si tu proyecto se comunica con otro proyecto que tú también controlas
  (ej: frontend↔backend) → SÍ.
- Si tu proyecto solo consume APIs públicas de terceros → NO, deja la
  casilla "Proyecto independiente".

**Cómo rellenarlo (si aplica):**

1. Marca la casilla `[x] Sí` al principio.
2. Rellena los datos del proyecto hermano (ruta local, URL, repo).
3. **Lo más importante**: el campo "Contrato / interfaz". Indica DÓNDE
   vive la fuente de verdad del contrato (un archivo OpenAPI, un schema
   GraphQL, un doc Markdown). Si no hay todavía, anota "Pendiente de
   crear, ver feature X de feature_list.json".
4. La tabla de endpoints/operaciones puedes dejarla vacía al inicio y
   llenarla a medida que añades features.

### 12.6 — `feature_list.json`

**Qué hay aquí por defecto:** dos features de ejemplo (`bootstrap` y
`fundamentos`) para que tengas un punto de partida.

**Cómo adaptarlo:**

1. **Cambia `project` y `description`** al principio del JSON con el
   nombre real del proyecto.
2. **Revisa `bootstrap`**: ajusta los criterios de aceptación a tu stack.
   Si ya hiciste el bootstrap antes de instalar el harness, marca la
   feature como `done`. Si no, déjala como `pending` para que sea la
   primera tarea.
3. **Revisa `fundamentos`**: igual. Decide qué entra exactamente en tus
   fundamentos según el proyecto (manejo de errores, env, cliente HTTP,
   etc.) y ajusta los criterios.
4. **Añade más features si tienes ya el roadmap claro**: por ejemplo,
   feature 3 podría ser "auth/login", feature 4 "perfil de usuario", etc.
   No te pases — 5 o 6 features iniciales son suficientes para arrancar.
   El resto irá apareciendo con el uso.
5. **Escribe el bloque `intent` de cada feature** (ver 12.6.1). Esto es lo
   que TÚ escribes antes de pedirle nada al agente: es el QUÉ y el POR QUÉ
   en tus palabras. El agente deriva el `acceptance` técnico de ahí.

### 12.6.1 — El bloque `intent` (lo escribes tú, no el agente)

Cada feature lleva un bloque `intent` con cinco campos. Es la pieza que hace
que entiendas lo que se va a implementar y que puedas revisar el spec con
criterio en vez de dar cosas por buenas. Referencia completa y ejemplo real
en **`docs/intent-template.md`**.

Los cinco campos:

- `que_quiero` — el comportamiento que quieres ver, sin decir cómo se hace.
- `por_que` — el problema que resuelve.
- `como_se_que_esta_bien` — situaciones concretas ("cuando pasa X, veo Y").
  Recórrelas una a una: aquí saltan los casos raros que en caliente no se te
  ocurren.
- `que_no_quiero` — lo que queda fuera y lo que no se debe tocar.
- `delego_en_agente` — dudas técnicas que no sabes responder. El agente las
  decide PERO te las marca y explica en el spec, no en silencio.

**Regla clave:** el leader tiene prohibido inventarse el QUÉ. Si una feature
no tiene `intent`, el agente se para y te lo pide. Tú eres dueño del QUÉ; el
agente, del CÓMO. Cuando el spec llegue a la puerta de aprobación, revisas
que cada requirement salga de tu `intent` (trazabilidad) y miras con lupa lo
que el agente marcó como `(añadido)` o `(delegado)` (procedencia).

**Estados válidos:**
- `pending` — la feature está definida pero nadie la ha empezado.
- `spec_ready` — solo features con `"sdd": true`: el spec está redactado y
  espera tu aprobación. No se toca código. Lees `specs/<nn>-<name>/decisions.md`
  —una página— y dices "aprobado" o pides cambios.
- `in_progress` — alguien la está trabajando AHORA. Solo puede haber UNA
  feature `in_progress` a la vez (el harness lo verifica).
- `done` — completada y revisada.
- `blocked` — empezada pero detenida por algún problema. Anótalo en
  `progress/current.md`.

### 12.7 — Verificación final

Después de rellenar los 6 archivos, ejecuta:

```bash
./init.sh
```

Tienes que ver:

- `[OK] Stack detectado: <tu stack>`
- `[OK] Existe` para todos los archivos base.
- `[OK] feature_list.json valido (N features)`
- `[OK] Entorno listo. Puedes empezar a trabajar.`

Si todo está verde, el harness ya está **listo y configurado** para
empezar a trabajar con Claude Code.

---

## 13. Primera sesión con Claude Code

Una vez configurado el harness, tu primera sesión debería seguir este
patrón para verificar que todo funciona y para que el agente "se aclimate"
al proyecto.

### Paso 1 — Abrir Claude Code

```bash
cd /ruta/al/proyecto
claude
```

### Paso 2 — Pedirle al agente que verifique el contexto

Tu primer mensaje al agente debe ser algo así:

> "Eres el `leader` de este proyecto. Antes de empezar a planificar nada,
> haz lo siguiente:
>
> 1. Lee `AGENTS.md`.
> 2. Lee los archivos de `docs/` (stack, conventions, architecture,
>    verification, related-projects si tiene contenido).
> 3. Lee `feature_list.json` y `progress/current.md`.
> 4. Ejecuta `./init.sh`.
>
> Después dime: (a) qué entiendes que tienes que hacer en este proyecto,
> (b) si hay información ambigua o incompleta en los docs, (c) si te
> faltan datos que yo deba aportar antes de empezar."

> ⚠️ Este paso es CRÍTICO. Si el agente arranca planificando sin haber leído
> el contexto, todo lo que produzca va a estar desalineado. Forzar este
> "warm-up" te ahorra horas después.

### Paso 3 — Iterar sobre los docs si hace falta

Es probable que el agente te diga "en `docs/conventions.md` no queda claro
si los componentes de Vue van como `.vue` con `<script setup>` o como
`.tsx`". Si te lo dice, **es información valiosa**: significa que tu doc
no era lo suficientemente concreto. Vuelve al doc, aclara, y dile al
agente que vuelva a leerlo.

Repite este ciclo hasta que el agente diga algo equivalente a "tengo todo
el contexto, dime qué tarea quieres que aborde".

### Paso 4 — Pedir el plan de la primera feature

Una vez el contexto está claro:

> "Procede con la feature `bootstrap` de `feature_list.json`. Como
> `leader`, dame el plan en fases y tareas. Identifica decisiones que
> requieran mi input. NO escribas código todavía."

El leader te debería devolver un plan desglosado. Lo revisas, lo
apruebas o ajustas, y solo entonces le permites lanzar al `implementer`.

### Paso 5 — Cierre de sesión

Cuando termines una feature (o cuando vayas a cerrar la sesión aunque no
esté terminada):

> "Antes de cerrar la sesión:
>
> 1. Ejecuta `./init.sh` y verifica que está verde.
> 2. Si la feature está completada, marca su estado como `done` en
>    `feature_list.json`.
> 3. Mueve el resumen de `progress/current.md` al final de
>    `progress/history.md` con la fecha de hoy.
> 4. Vacía `progress/current.md` dejando solo la plantilla."

### Lo que debes esperar de la primera sesión

- **No esperes magia inmediata.** La primera sesión suele descubrir huecos
  en los docs. Es normal y útil.
- **El agente puede pedirte aclaraciones constantemente.** Es lo correcto
  — significa que está respetando las reglas. Cada respuesta tuya hace
  los docs más sólidos para sesiones futuras.
- **Si el agente intenta saltarse el flujo** (ej: empieza a editar código
  siendo `leader`), recuérdale el rol citando `.claude/agents/leader.md`. Es un
  recordatorio que suele funcionar.
- **Anota en el cheatsheet** los aprendizajes que vayan surgiendo. Lo que
  hoy es un descubrimiento, mañana es procedimiento.

---

## 14. Mantenimiento del harness

A medida que el proyecto crece, el harness debe evolucionar con él. Una
vez al mes (o cuando notes fricción), revisa:

- **`docs/conventions.md`**: ¿hay nuevas convenciones implícitas que el
  equipo (o tú) ha empezado a seguir y no están escritas?
- **`docs/architecture.md`**: ¿hay decisiones recientes que merecen un
  ADR? ¿hay anti-patrones nuevos que añadir a "Qué NO hacer"?
- **`feature_list.json`**: ¿quedan features `done` muy antiguas que ya
  podrían archivarse? (puedes sacarlas a `feature_list.archive.json`).
- **Plantilla maestra**: si descubres algo que mejora el harness en este
  proyecto y aplica a todos, **actualiza la plantilla maestra** y luego propaga
  con `upgrade-harness.sh` a los proyectos en marcha. El comando `/lessons`
  hace esta búsqueda por ti a partir de `docs/lessons.md` y de los rechazos del
  reviewer, y te deja las propuestas para la plantilla ya redactadas.

**Al aplicar en la plantilla una propuesta de `/lessons`:** cámbiala en el
archivo del motor que dice la propuesta (no en `CLAUDE.md` salvo que afecte a
todos los agentes), sube `VERSION`, y tras propagar, en el proyecto de origen la
lección pasa a `en plantilla v<versión>` (el siguiente `/lessons` lo propone).

### Reglas que NO se relajan

Estas se pagaron caras: son la respuesta a dos problemas concretos que costaron
semanas. Al simplificar el harness, son justo las que más apetece quitar porque
parecen burocracia. No lo son.

**Contra la deriva del agente** (el agente construyendo lo que nadie pidió):

- El bloque `intent` escrito por el humano, y **la parada del leader si falta**.
- La **sección de procedencia** `(humano)` / `(delegado)` / `(añadido)` en
  `requirements.md`. Es lo único mecánico que hace visible el alcance colado, y
  es barata de producir.
- La **puerta de aprobación humana** entre `spec_ready` e `in_progress`.
- Trazabilidad `R<n>` ↔ test como condición para aprobar.
- Una sola feature en `in_progress`.

**Contra las specs ilegibles** (días para aprobar una):

- `decisions.md` obligatorio, una página, bloque 🔴 de máximo 6 puntos **cada
  uno con su alternativa**.
- El tope de ~15 requirements **con el comportamiento de parar y proponer el
  corte**. Ojo: son *requirements*, no tasks — un requirement puede necesitar
  varias tasks.
- El changelog en vez de reemitir el documento.
- No escribir el spec sin las entradas reales delante.
- Prohibido mandar al humano a leer `requirements.md`, `design.md` o `tasks.md`.

Regla general al recortar: **se recorta lo que se escribe, nunca lo que se
comprueba.**

### Si añades una plantilla nueva, cablearla es parte de añadirla

Una plantilla que no está enlazada desde el agente que la usa **no la lee nadie**:
el agente escribe el artefacto a su aire y la plantilla queda de adorno. Hay que
nombrarla en la lista de lectura de su protocolo *y* en la regla que la exige.

Comprobación: `grep -rn "<nombre>-template" .` debe devolver, además del propio
archivo, su agente y el doc de proceso que la menciona.

### Cómo saber si el harness te está frenando

Sin medir no se sabe. Tres números baratos en cualquier feature:

1. **Reloj de la implementación** — de aprobar el spec al veredicto del reviewer.
2. **Cuántas veces corre la suite completa** —
   `grep -c "Ejecutando:" "${TMPDIR:-/tmp}/harness_init.log"`. Debe ser un puñado,
   no decenas: la suite entera solo la lanzan el implementer al terminar y el
   reviewer.
3. **Líneas de andamiaje frente a líneas de código** — `wc -l` de
   `progress/implementations/<feature>.md` + `specs/<nn>-<feature>/*` contra el diff real. Si el
   andamiaje gana por mucho, hay dónde recortar.

Señal de alarma distinta: si una spec vuelve a costarte días de idas y venidas,
el problema no suele ser el proceso sino **el tamaño de la feature**. Comprueba
si el `spec-author` te propuso el corte; si no lo hizo debiendo hacerlo, eso es
lo que hay que apretar.
