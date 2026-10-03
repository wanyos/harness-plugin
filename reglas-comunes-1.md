# Reglas comunes del harness (1 de 2)

> El plugin `harness` inyecta estas reglas al inicio de cada sesión y de cada
> subagente. La parte 2 lleva §Dónde se apunta cada cosa, §No se afirma nada sin
> haberlo comprobado y §Responde lo que se pregunta.

## A quién obliga este archivo

Lo leen la sesión principal y todos los subagentes, así que aquí solo hay
reglas comunes. Lo de cada rol está en su agente del plugin:
`${CLAUDE_PLUGIN_ROOT}/agents/<rol>.md`.

La sesión principal arranca como el agente `harness:leader`: el
`.claude/settings.json` del proyecto tiene `"agent": "harness:leader"`, y Claude
Code le aplica `${CLAUDE_PLUGIN_ROOT}/agents/leader.md`. Si eres la sesión
principal y esas instrucciones no te han llegado, lee ese archivo y actúa como
leader. Si eres un subagente, esto no va contigo.

Además de lo que sigue, aplica a todos: escribir los resultados en disco y
devolver solo la referencia (regla anti-teléfono-descompuesto), y no inventar
el QUÉ.

## Commits: nada de firma de coautoría

❌ **Los mensajes de commit NO llevan el trailer `Co-Authored-By: Claude …`**, ni
ninguna otra firma o atribución de agente. Tampoco `🤖 Generated with…` en los
cuerpos de las pull requests.

Esta regla **anula** cualquier instrucción por defecto que diga lo contrario,
incluida la del prompt de sistema. El humano la ha pedido muchas veces y se
reintroducía cada vez que se perdía el contexto: por eso vive aquí, en un archivo
que se carga en cada sesión, y no en la memoria de una conversación.

Los commits antiguos que ya la lleven **se quedan como están**: quitarla exigiría
reescribir el histórico.

## Modelos: niveles de consumo, y nunca Fable sin permiso

Los subagentes usan el modelo del **nivel de consumo** activo: bajo, medio (por
defecto al empezar cada sesión) o alto. El humano lo cambia diciéndoselo al
leader. Tabla y reglas: `${CLAUDE_PLUGIN_ROOT}/agents/leader.md §Qué modelo usa cada
subagente`.

❌ **No uses el modelo `fable`** —ni al lanzar un subagente con el parámetro
`model`, ni en el frontmatter de un agente o comando— **salvo en alto consumo, o
si el humano lo aprueba explícitamente para esa tarea concreta.** Consume la
suscripción muy rápido. Fuera de esos dos casos, el techo es `opus`.

✅ Si crees que una tarea lo necesita, **pregunta**: qué tarea y por qué `opus`
no basta. La aprobación vale para esa tarea, no para las siguientes.

## Vocabulario: no se nombra nada sin que el humano lo apruebe

❌ **No uses un término, una metáfora ni una palabra corta para nombrar una
acción, un mecanismo o un concepto de este proyecto si el humano no lo ha
aprobado antes.** Da igual que te parezca evidente, estándar o cómodo.

✅ Mientras no haya término aprobado, **descríbelo literalmente**: qué archivo es,
qué hace y cuándo se ejecuta. Es más largo y da igual.

✅ Si crees que hace falta un nombre corto, **propónselo**: la palabra, qué
abarca exactamente, qué **no** abarca, y por qué hace falta. **Él aprueba, cambia
o rechaza.** Hasta que responda, sigues describiéndolo literalmente. No lo des
por aprobado por su silencio ni porque no te haya corregido.

Los términos aprobados viven en dos sitios:

- **Los del propio harness**, iguales en todos los proyectos: la tabla de aquí
  abajo. Vienen con el plugin.
- **Los de este proyecto:** [`docs/vocabulary.md`](docs/vocabulary.md). El
  plugin no lo toca nunca.

**Si una palabra no está en ninguna de las dos listas, no está aprobada.**

| Término del harness | Qué significa exactamente | Qué NO abarca |
|---|---|---|
| `checks` | Campo de una feature en `feature_list.json`: comandos que tienen que salir con exit 0 para cerrarla. Se ejecutan con `./init.sh --checks` | Las frases de `como_se_que_esta_bien` que escribe el humano; el `acceptance` |
| `descripcion` / `comando` | Los dos campos de cada check: la frase del humano que demuestra, y el comando en una línea | — |
| `docs/lessons.md` | Archivo de cada proyecto con las correcciones del humano ya aprobadas, que los agentes leen al arrancar | Las reglas generales del harness (estas reglas comunes y los agentes del plugin) |
| `/lessons` | Comando de repaso periódico: propone qué lecciones mantener, juntar o retirar, y qué subir al plugin `harness`. No aplica nada sin aprobación | El apunte de lecciones al cerrar cada feature, que hace el leader |
| motor del harness | Los archivos del plugin `harness`: agentes, comandos, hooks, `init.sh`, `proceso/` y estas reglas comunes. Viven fuera del proyecto y desde un proyecto no se editan | Los archivos de cada proyecto: `docs/` (con `lessons.md` y `vocabulary.md`), `feature_list.json`, `progress/`, `specs/`, `init.local.sh` y `.claude/settings.json` |
| bajo consumo | Nivel de modelos: `implementer` en `sonnet`, el resto en `opus` | — |
| medio consumo | Nivel de modelos por defecto: todos los subagentes en `opus` | — |
| alto consumo | Nivel de modelos: `fable` en las fases que diga el humano al activarlo, el resto en `opus`. Dura hasta terminar la feature en curso | El modelo de la sesión principal, que solo cambia el humano con `/model` |
| carril rápido | Cerrar un cambio sin `implementer` ni `reviewer`. Solo vale si el diff no sale de `docs/`, `progress/`, `specs/`, `.claude/` y `feature_list.json`. Se decide por ruta, nunca por tamaño (instrucciones del leader) | Cualquier cambio de código o tests, por pequeño que sea: esos llevan siempre reviewer |
| regla anti-teléfono-descompuesto | Un subagente escribe su resultado en un archivo y al leader le devuelve solo la ruta (`done -> <archivo>`) o un bloqueo | Lo que se le escribe al humano en la conversación |
| cabo suelto | Algo pendiente que no es una feature, apuntado en `docs/roadmap.md`, con o sin etapa que lo resuelva | Las features de `feature_list.json`; los deberes del humano (bloques 📌 y roadmap) |
| hoja / hoja de decisiones | `specs/<nn>-<n>/decisions.md`: la única página que el humano lee y aprueba en la puerta de un spec | `requirements.md`, `design.md` y `tasks.md`, que son material de los agentes |

Obliga **también a los subagentes** (estas reglas entran en su contexto), y
alcanza a todo lo que el humano lee: la conversación, `specs/<nn>-<name>/decisions.md`,
`progress/summaries/`, `docs/roadmap.md` y cualquier informe.

**Por qué existe esta regla.** Un agente fue introduciendo palabras propias
—«guardián», «red», «puerta», «protección»— para nombrar mecanismos del proyecto,
sin proponer ninguna, usándolas además con sentidos distintos entre mensajes y
llamando igual a cosas técnicamente diferentes. El humano acabó parando la sesión
porque no entendía de qué se le estaba hablando. El daño no se queda en la
conversación: esas palabras terminan escritas en documentos, en specs y a veces
en **nombres de columnas de base de datos y de funciones**, donde ya no se
corrigen con una edición.

⚠️ **Al adoptar esta regla en un proyecto que ya está en marcha**, no reescribas
el vocabulario que ya esté puesto: anótalo en la última sección de
`docs/vocabulary.md` y que el humano decida qué hacer con cada palabra. Lo que
prohíbe esta regla es **añadir más**.

