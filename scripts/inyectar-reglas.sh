#!/usr/bin/env bash
# inyectar-reglas.sh — pasa a Claude una parte de las reglas comunes del harness.
#
# Uso (desde hooks/hooks.json):
#   inyectar-reglas.sh <SessionStart|SubagentStart> <archivo dentro del plugin>
#
# WHY: un plugin no puede traer CLAUDE.md (Claude Code no lo carga). Las reglas
# comunes llegan con este hook: SessionStart para la sesión principal y
# SubagentStart para cada subagente. Claude Code corta en 10.000 caracteres el
# texto de cada hook, por eso las reglas van en dos archivos y dos hooks.
#
# Sustituye ${CLAUDE_PLUGIN_ROOT} por la ruta real del plugin, para que las
# reglas puedan citar archivos del plugin (agents/leader.md, proceso/...).

set -u

EVENTO="${1:-}"
ARCHIVO="${CLAUDE_PLUGIN_ROOT:-}/${2:-}"

cat > /dev/null   # el JSON del evento no hace falta; se consume para no dejar la tubería abierta

if [ -z "$EVENTO" ] || [ -z "${CLAUDE_PLUGIN_ROOT:-}" ] || [ ! -f "$ARCHIVO" ]; then
  echo "[harness] inyectar-reglas.sh: no encuentro '$ARCHIVO' (evento '$EVENTO')" >&2
  exit 1
fi

# Texto → cadena JSON sin depender de jq, Node ni Python: sustituye la variable,
# quita \r y caracteres de control, pasa tabuladores a espacio, escapa \ y ",
# y une las líneas con \n.
JSON_TEXTO=$(sed -e "s#\${CLAUDE_PLUGIN_ROOT}#${CLAUDE_PLUGIN_ROOT}#g" "$ARCHIVO" \
  | tr -d '\r' \
  | tr '\t' ' ' \
  | tr -d '\000-\010\013-\037' \
  | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g' \
  | awk 'NR > 1 { printf "\\n" } { printf "%s", $0 }')

printf '{"hookSpecificOutput":{"hookEventName":"%s","additionalContext":"%s"}}\n' "$EVENTO" "$JSON_TEXTO"
exit 0
