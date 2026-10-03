#!/usr/bin/env bash
# init.sh — envoltorio. La verificación de verdad está en el plugin `harness`
# (bin/harness-init); este archivo solo la busca y le pasa los argumentos.
# Lo propio de este proyecto va en init.local.sh, no aquí.
#
# Dentro de Claude Code, el plugin pone su bin/ en el PATH. Fuera (tu terminal),
# se busca la última versión instalada en la caché de plugins de Claude Code.

cd "$(dirname "$0")" || exit 1

H=$(command -v harness-init 2>/dev/null)
[ -z "$H" ] && H=$(ls -d "$HOME"/.claude/plugins/cache/*/harness/*/bin/harness-init 2>/dev/null | sort -V | tail -n 1)

if [ -z "$H" ]; then
  echo "[FAIL]  No encuentro harness-init: ¿está instalado y activo el plugin harness?" >&2
  exit 1
fi

exec bash "$H" "$@"
