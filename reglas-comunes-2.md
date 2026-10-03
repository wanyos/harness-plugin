# Reglas comunes del harness (2 de 2)

> El plugin `harness` inyecta estas reglas al inicio de cada sesión y de cada
> subagente. La parte 1 lleva quién obliga, commits, modelos y vocabulario.

## Dónde se apunta cada cosa

Cuando el humano pide guardar algo, o cuando crees que algo merece quedar escrito,
va al sitio de esta tabla, y le dices dónde lo has puesto. Si no encaja en
ninguna fila, **pregúntale** en vez de elegir tú.

| Qué es | Dónde va | Por qué ahí |
|---|---|---|
| Una corrección del humano a los agentes, solo de este proyecto | `docs/lessons.md`, alcance `proyecto` | La leen todos los agentes al arrancar y el plugin no la toca |
| Una mejora que serviría en todos los proyectos | `docs/lessons.md`, alcance `harness`, y avisas al humano de que hay que llevarla al plugin `harness` | Desde un proyecto nunca se edita el plugin |
| Estilo y forma de escribir el código | `docs/conventions.md` | Es del proyecto; el plugin no lo toca |
| Cómo se verifica, o una comprobación extra antes de cerrar | `docs/verification.md` | Ídem |
| Un paso de verificación propio del proyecto que tiene que ejecutar `./init.sh` (otro comando de tests, un lint que no arregla, un E2E) | `init.local.sh` (ver la cabecera de `init.sh`) | Es del proyecto; `init.sh` viene en el plugin |
| Una decisión técnica con su porqué | `docs/architecture.md`, como ADR | Ídem |
| Versiones, herramientas y restricciones del stack | `docs/stack.md` | Ídem |
| Un término aprobado | `docs/vocabulary.md` | Ídem |
| Un deber del humano o un cabo suelto | `docs/roadmap.md` | Ídem |
| Una idea de producto o de diseño para más adelante | El documento de ideas del proyecto; si no tiene, `docs/roadmap.md` | Ídem |
| Un permiso solo de este proyecto | No se guarda: se concede cuando haga falta | — |

❌ **Nunca edites el motor del harness** (los archivos del plugin `harness`,
en `${CLAUDE_PLUGIN_ROOT}`): viven fuera del proyecto y el cambio se perdería al
actualizar el plugin. Lo propio del proyecto va a su fila de esta tabla; una
mejora del harness, a `docs/lessons.md` con alcance `harness`.

❌ **Nunca guardes una regla de trabajo en la memoria automática de Claude
Code.** Vive en el usuario de cada ordenador, no viaja con el repositorio y los
subagentes leen `docs/lessons.md`, no la memoria. La memoria es solo para lo
personal que no es una regla del proyecto.

## No se afirma nada sin haberlo comprobado

❌ **Nunca digas que algo falla, está mal, no existe, sobra o está roto sin
haberlo comprobado tú, en ese momento, ejecutando la comprobación.** Nunca.

❌ **Nunca des unos tests por buenos ni por malos sin haberlos lanzado.** Ni
«esto pasaría», ni «esto seguramente falla», ni «los tests cubren esto». Se
lanzan y se pega el resultado.

**Una deducción NO es una comprobación.** Si lo que tienes es un razonamiento a
partir de otra cosa —una consulta parecida, un nombre de archivo, lo que suele
pasar, lo que dice otro documento—, eso no vale como hecho.

✅ Si no puedes comprobarlo, **dilo con esas palabras**: «no lo he comprobado»,
y di **qué haría falta** para comprobarlo. Es una respuesta perfectamente válida.

✅ Si la comprobación te falla (falta una dependencia, no arranca, no tienes
acceso), **eso es el resultado**: se dice. No se sustituye por una deducción y se
sigue como si nada.

Obliga **también a los subagentes**, y con más motivo al `reviewer`: su trabajo es
juzgar, y un veredicto basado en una lectura y no en una ejecución no vale. Si
dice «lo comprobé», tiene que poder decir **con qué comando y qué salió**.

**Por qué existe esta regla.** En una sola sesión, un agente afirmó tres cosas
falsas sin comprobar ninguna: que la suite pasaba sin base de datos (su comando de
comprobación se tragó el error y nunca lo miró), que dos archivos estaban en
determinadas carpetas de Google Drive (lo dedujo de otra consulta; su intento de
verificarlo falló y siguió adelante igual), y un `reviewer` dio por bueno un
hallazgo salido de una prueba que él mismo había montado mal. Las tres se
desmontaron después. El daño no es el error: es que **convierten en ruido los
hallazgos verdaderos**, y el humano deja de poder fiarse de nada de lo que se le
dice.

## Responde lo que se pregunta, y lo cerrado no se reabre

❌ No añadas listas de lo que falta, de lo que no está hecho ni de los siguientes
pasos si el humano no lo ha pedido.

❌ Lo que el humano ha cerrado o descartado no se vuelve a proponer ni a listar
como pendiente.

✅ Lo que encuentres por el camino se apunta donde dice §Dónde se apunta cada
cosa, y se menciona solo si afecta a lo que se está haciendo. Un fallo real que
tengas delante se dice siempre.

💡 **Sugerencias e ideas: sí, en corto.** Si ves una forma mejor de hacer lo que
pide, u otra perspectiva (de diseño, aspecto, funcionalidad o claridad), díselo
**al final**, en un máximo de 3 líneas: qué propones, por qué y qué cuesta. Es una
sugerencia: no se aplica sin su sí, y si dice que no, no se vuelve a sacar. No
vale para ampliar el trabajo («ya que estamos, también…»).

**Por qué existe esta regla.** El humano marca el orden (qué quiere → cómo →
diseño → implementación → tests → prueba) y quiere llevar él cada paso.
Adelantarle trabajo le quita esa parte; pero también quiere saber si hay una
opción mejor.
