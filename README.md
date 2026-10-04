# harness — plugin de Claude Code

Harness de desarrollo con agentes: un **leader** que habla contigo y reparte el
trabajo, y tres subagentes (**spec-author**, **implementer**, **reviewer**).
Incluye reglas comunes, proceso (specs, plantillas, checkpoints), hooks de
verificación y el script `harness-init`.

El plugin se instala **una vez por ordenador**. Cada proyecto que lo use solo
guarda lo suyo (docs, estado y su `.claude/settings.json`), que se copia del
**esqueleto** que trae el plugin.

> En Windows: `claude` se arranca desde **PowerShell** (en Git Bash entra en modo
> `--print` y termina). Todo lo demás (`./init.sh`, git, copiar archivos), desde
> **Git Bash**. En el Mac, todo desde la terminal.

Detalle completo: [`proceso/harness-config.md`](proceso/harness-config.md) (§11 instalación, §12 configuración, §14 mantenimiento).

---

## 1. Instalar en un ordenador (una vez)

**Git Bash** (Windows) o **terminal** (Mac), desde cualquier carpeta:

```bash
claude plugin marketplace add wanyos/harness-plugin
#   sin clave SSH en GitHub: claude plugin marketplace add https://github.com/wanyos/harness-plugin.git
claude plugin install harness@wanyos && claude plugin disable harness@wanyos --scope user
```

**Por qué el `disable --scope user`:** `claude plugin install` activa el plugin
por defecto en **todos** los proyectos del ordenador. El harness solo tiene
sentido donde está su esqueleto, así que se desactiva a nivel user y cada
proyecto lo activa en su propio `.claude/settings.json` (lo trae el esqueleto).
Van en una sola línea para que no se olvide la segunda parte.

**Red de seguridad (desde v0.2.1):** si aun así quedara activo a nivel user, sus
hooks no hacen nada en un proyecto cuyo `.claude/settings.json` no mencione
`"harness@"`.

Comprobar: `claude plugin list` debe mostrar `harness@wanyos` desactivado a nivel user.

---

## 2. Poner el harness en un proyecto

**Git Bash**, desde la **raíz del proyecto**:

```bash
S=$(ls -d ~/.claude/plugins/cache/*/harness/*/proyecto | sort -V | tail -1)
cp -rn "$S"/. .
chmod +x init.sh
printf '.claude/*\n!.claude/settings.json\n' >> .gitignore
```

- La primera línea busca el esqueleto de la versión más alta instalada.
- `cp -n` no pisa nada que ya exista. Añade: `.claude/settings.json`, `init.sh`,
  `.gitattributes`, `feature_list.json`, `progress/` y `docs/`.
- **Si el proyecto ya tenía `.claude/settings.json` o `.gitattributes`, no se
  copian: fusiónalos a mano.** `settings.json` necesita
  `"agent": "harness:leader"`, la regla `Read(~/.claude/plugins/cache/*/harness/**)`
  y `"enabledPlugins": { "harness@wanyos": true }`. Esta última línea es la que
  activa el plugin en el proyecto.

Instalar dependencias del proyecto y comprobar:

```bash
<gestor> install       # pnpm / npm / dotnet restore…
./init.sh --state      # debe salir en verde
```

Versionar:

```bash
git add -A && git update-index --chmod=+x init.sh
git commit -m "Instalar plugin harness"
```

---

## 3. Comprobar que funciona y primer arranque

**PowerShell** (Windows) o **terminal** (Mac), desde la raíz del proyecto:

```powershell
claude
```

1. En la cabecera debe aparecer **@harness:leader**.
2. Pregúntale: *"¿Has recibido las reglas comunes del harness? Dime el título
   de cada parte."* Debe citar las dos partes (1 de 2 y 2 de 2).
3. Pídele: **"haz el setup inicial del harness"**. El leader lee el proyecto y
   prepara un borrador de `docs/stack.md`, `architecture.md`, `conventions.md` y
   `verification.md`, con listas **DESCUBIERTO** (lo que vio en el código) y
   **PROPUESTO** (lo que sugiere) en `progress/current.md`.
4. Revisa el borrador: lo DESCUBIERTO, que sea cierto; lo PROPUESTO, decídelo tú.
   En un proyecto vacío habrá poco que descubrir y más que decidir.
5. Escribe las primeras features en `feature_list.json`, cada una con su bloque
   `intent` (guía: `proceso/intent-template.md`). Sin `intent`, el leader no arranca.
6. `./init.sh` en verde y commit.

---

## 4. Cómo se trabaja con el plugin

**Tú eres dueño del QUÉ; los agentes, del CÓMO.** Escribes el `intent` de cada
feature (qué quieres, por qué, cómo sabrás que está bien, qué no quieres y qué
delegas). El leader nunca se lo inventa.

Para avanzar: abre `claude` en el proyecto y pide
**"implementa la siguiente feature pendiente"**. El leader mira el estado de la
primera feature no terminada y sigue uno de dos caminos:

- **Con spec** (`"sdd": true`): el spec-author escribe `specs/<nn>-<nombre>/` →
  el leader **para** y te enseña solo `decisions.md` (una página) → dices
  **"aprobado"** o pides cambios → implementer(s) → reviewer → `done`.
- **Simple** (sin `sdd`): el leader te enseña los criterios derivados del
  `intent` → implementer → reviewer → `done`.

Estados de una feature: `pending` → `spec_ready` → `in_progress` → `done`.
Solo una puede estar `in_progress` a la vez.

Al cerrar una sesión, pide al leader que deje el estado al día
(`feature_list.json` y `progress/`) con `./init.sh` en verde: la siguiente
sesión arranca leyendo esos archivos.

Comandos del plugin dentro de `claude`:

- `/harness:project-status` — por dónde va el proyecto, en 20 líneas.
- `/harness:lessons` — repasa los fallos recientes y propone lecciones.

---

## 5. Cuándo lanzar `./init.sh`

Verifica, no instala. Lo usan los agentes y los hooks solos; tú, desde
**Git Bash**, cuando quieras comprobar:

| Comando | Qué hace | Cuándo |
|---|---|---|
| `./init.sh --state` | Valida `feature_list.json` y specs (instantáneo) | Tras instalar el esqueleto o tocar el estado a mano |
| `./init.sh --fast` | Estado + type check, sin tests | Comprobación rápida |
| `./init.sh` | Verificación completa con tests | Antes de un commit o al cerrar una feature |
| `./init.sh --checks <id>` | Los `checks` de una feature | Para verificar una feature concreta |

---

## 6. Actualizar el plugin en un ordenador

**Git Bash** o **terminal**, una vez por ordenador (no por proyecto):

```bash
claude plugin marketplace update wanyos
claude plugin update harness@wanyos
```

Cierra las sesiones de `claude` abiertas: la versión nueva la cargan las sesiones nuevas.

## 7. Publicar un cambio del plugin

Desde el repo del plugin: cambia, sube `version` en `.claude-plugin/plugin.json`
(sin eso `update` no detecta nada), valida y sube:

```bash
claude plugin validate .
git add -A && git commit -m "..." && git push
```
