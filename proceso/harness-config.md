

## 11. Instalar el plugin

### 11.1 — Una vez por ordenador

```bash
claude plugin marketplace add wanyos/harness-plugin
#   sin clave SSH en GitHub: claude plugin marketplace add https://github.com/wanyos/harness-plugin.git
claude plugin install harness@wanyos && claude plugin disable harness@wanyos --scope user
```

**Por qué se desactiva a nivel de usuario:** con scope user el plugin se activa
en **todos** los proyectos donde abras Claude Code, también en los que no usan
el harness (o usan otra versión), y les inyecta reglas y hooks. Se activa
proyecto a proyecto con `enabledPlugins` (§11.2), que viaja con el repositorio.
Van en una sola línea para que la segunda no se olvide: sin ella, el plugin
queda activo en todos los proyectos del ordenador.

**Guarda (desde v0.2.1):** aunque el plugin quede activo por error a nivel
user, sus hooks no hacen nada en un proyecto cuyo `.claude/settings.json` no
mencione `"harness@"`: salen sin inyectar reglas ni verificar. Esa marca la
pone el esqueleto (§11.2).

Actualizar a una versión nueva:

```bash
claude plugin marketplace update wanyos
claude plugin update harness@wanyos
```

En Windows: Claude Code se arranca desde **PowerShell** (en Git Bash entra en
modo `--print`); `./init.sh` y git, desde **Git Bash**.

### 11.2 — En cada proyecto (nuevo o existente)

Desde la raíz del proyecto, en Git Bash, copiar el esqueleto de la última
versión instalada. `cp -n` no pisa lo que ya exista:

```bash
S=$(ls -d ~/.claude/plugins/cache/*/harness/*/proyecto | sort -V | tail -1)
cp -rn "$S"/. .
chmod +x init.sh
```

Esto añade `init.sh`, `.claude/settings.json`, `.gitattributes`,
`feature_list.json`, `progress/` y `docs/`. Si el proyecto **ya tenía**
`.claude/settings.json` o `.gitattributes`, no se copian: fusiónalos a mano.
`settings.json` necesita `"agent": "harness:leader"`, la regla
`Read(~/.claude/plugins/cache/*/harness/**)` y
`"enabledPlugins": { "harness@wanyos": true }`.

Añadir al `.gitignore` (así `settings.json` se versiona y lo local no):

```
.claude/*
!.claude/settings.json
```

Instalar dependencias y comprobar:

```bash
<gestor> install          # pnpm / npm / dotnet restore…
./init.sh --state         # debe salir en verde
git add -A && git update-index --chmod=+x init.sh
git commit -m "Instalar plugin harness"
```

Lo propio del proyecto que `./init.sh` no detecta solo (un lint concreto, E2E,
un paso extra) va en `init.local.sh` (ver la cabecera de `init.sh`), nunca en
el plugin.

### 11.3 — Proyecto existente: setup asistido de los docs

1. Haz commit de lo de §11.2 antes: así todo lo que escriba el agente se ve en
   un `git diff` y se puede revertir de golpe.
2. Abre Claude Code en el proyecto. La cabecera debe mostrar `harness:leader`.
3. Pídele: `haz el setup inicial del harness`. Rellena `docs/stack.md`,
   `docs/verification.md`, `docs/architecture.md` y `docs/conventions.md` como
   **borrador**, y deja en `progress/current.md` dos listas: DESCUBIERTO y
   PROPUESTO. No toca código ni `feature_list.json`.
4. Revisa lo PROPUESTO con la §12. Hasta que lo confirmes, no son reglas.

**Si el proyecto venía de harness-template** (o de un harness que no estaba en
git): antes de borrar nada, copia fuera del proyecto todo lo que no esté
versionado (`git status --short --ignored`, sin `node_modules` ni `dist`).
Ahí suelen estar el `docs/architecture.md` con los ADR originales, el
`feature_list.json` y el historial de `progress/`, que el agente no puede
reconstruir. Después se quitan los archivos del harness viejo: `CLAUDE.md`,
`AGENTS.md`, `CHECKPOINTS.md`, `VERSION`, `.harness-manifest`,
`docs/specs.md`, `docs/{intent,decisions,summary}-template.md` y
`.claude/{agents,commands,hooks}`; `init.sh` se sustituye por el de §11.2.

### 11.4 — Comprobar con un clon limpio

Al terminar, clona el repositorio en otra carpeta (u otro ordenador), instala
dependencias y lanza `./init.sh`. Destapa lo que solo existía en tu copia
local: archivos sin versionar y **dependencias fantasma** (con pnpm 11, paquetes
que se importan pero no están en `package.json`).

## 12. Configurar el harness para tu proyecto

> En este punto el harness ya está **instalado** (§11: plugin activo en el
> proyecto, esqueleto copiado, `./init.sh --state` verde). Pero todavía es **genérico**: contiene
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
en **`proceso/intent-template.md`** del plugin.

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

Con el harness instalado (§11) y los docs configurados (§11.3 y §12), la
primera sesión sirve para comprobar que todo funciona y que el leader entiende
el proyecto.

### Paso 1 — Abrir Claude Code

En Windows, desde **PowerShell** (en el Mac, la terminal), en la raíz del
proyecto:

```powershell
claude
```

La cabecera debe mostrar `@harness:leader`. Si no aparece, revisa `"agent"` y
`enabledPlugins` en `.claude/settings.json` (§11.2) y que el plugin esté
instalado en este ordenador (`claude plugin list`).

### Paso 2 — Comprobar que el leader tiene el contexto

No hace falta decirle qué leer: su protocolo de arranque (`agents/leader.md`
del plugin) ya lee `proceso/AGENTS.md`, `docs/stack.md`, `docs/roadmap.md`,
`docs/related-projects.md` (si tiene contenido), `docs/lessons.md`,
`feature_list.json` y `progress/current.md`, y ejecuta `./init.sh`. Comprueba
que lo ha hecho:

> "¿Has recibido las reglas comunes del harness? Dime el título de cada parte.
> Después dime: (a) qué entiendes que tienes que hacer en este proyecto,
> (b) si hay información ambigua o incompleta en los docs, (c) si te faltan
> datos que yo deba aportar antes de empezar."

Debe citar las dos partes de las reglas comunes (1 de 2 y 2 de 2). Si no las
cita, el plugin no está activo en el proyecto o el hook de reglas ha fallado.

> ⚠️ Este paso es CRÍTICO. Si el agente arranca sin haber leído el contexto,
> todo lo que produzca va a estar desalineado. Comprobarlo te ahorra horas
> después.

### Paso 3 — Iterar sobre los docs si hace falta

Es probable que el agente te diga "en `docs/conventions.md` no queda claro
si los componentes de Vue van como `.vue` con `<script setup>` o como
`.tsx`". Si te lo dice, **es información valiosa**: significa que tu doc
no era lo suficientemente concreto. Vuelve al doc, aclara, y dile al
agente que vuelva a leerlo.

Repite este ciclo hasta que el agente diga algo equivalente a "tengo todo
el contexto, dime qué tarea quieres que aborde".

### Paso 4 — La primera feature

Antes, comprueba que la feature tiene su bloque `intent` (§12.6.1): sin él,
el leader para y te lo pide. Después:

> "Implementa la siguiente feature pendiente."

Lo que pasa depende de la feature:

- **Con `"sdd": true`:** el `spec-author` redacta el spec y el leader **para**
  en la puerta de aprobación. Lees solo `specs/<nn>-<n>/decisions.md` (una
  página) y dices "aprobado" o qué cambiar. Hasta entonces no se escribe código.
- **Sin `sdd`:** el leader te enseña los `checks` derivados del `intent`, una
  línea por comando, y lanza al `implementer`. No hay puerta, pero los ves antes.

En los dos casos, al terminar el `implementer` el leader lanza al `reviewer`.

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
  siendo `leader`), recuérdale el rol citando el agente `harness:leader` (`agents/leader.md` del plugin). Es un
  recordatorio que suele funcionar.
- **Las correcciones quedan apuntadas.** Cuando corrijas al agente, el leader
  lo apunta en `docs/lessons.md`. De vez en cuando, `/harness:lessons` repasa
  los fallos recientes y propone qué conviene subir al plugin.
- **Para saber por dónde vas** sin preguntar: `/harness:project-status`.

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
- **El plugin**: si descubres algo que mejora el harness en este proyecto y
  aplica a todos, cámbialo en el repositorio `harness-plugin`, sube `version` en
  `.claude-plugin/plugin.json` y haz push. Cada ordenador lo recibe con
  `claude plugin update harness@wanyos` (§11.1). El comando `/harness:lessons`
  hace esta búsqueda por ti a partir de `docs/lessons.md` y de los rechazos del
  reviewer, y te deja las propuestas para el plugin ya redactadas.

**Al aplicar en el plugin una propuesta de `/harness:lessons`:** cámbiala en el
archivo del plugin que dice la propuesta (no en `reglas-comunes-*.md` salvo que
afecte a todos los agentes), sube `version`, y tras actualizar, en el proyecto de
origen la lección pasa a `en plantilla v<versión>` (el siguiente `/harness:lessons` lo propone).

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
