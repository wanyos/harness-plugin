# Roadmap — por dónde va el proyecto

> **TEMPLATE — rellenar al iniciar el proyecto y mantener vivo después.**
>
> **Para qué sirve este archivo:** para saber en dos minutos **dónde estás**,
> **qué viene después** y **por qué en ese orden**. Es el mapa del recorrido
> completo, no el detalle de ninguna parada.
>
> **Por qué existe** (añadido el 2026-08-11): el harness ya tenía cuatro
> documentos de estado y ninguno respondía «¿por dónde voy?».
> `feature_list.json` describe una feature, `progress/current.md` una sesión,
> `progress/history.md` es una bitácora que crece, y las ideas de producto
> viven fuera. Con diez features cerradas, ninguno de los cuatro te dice en qué
> parte del camino estás — y sin eso, al abrir un spec y encontrar decisiones
> que no recuerdas, la sensación es haber perdido el control del proyecto.
>
> **Última revisión:** TODO: fecha.

## Este documento frente a los otros

| Documento | Responde a | Alcance temporal |
|---|---|---|
| **`docs/roadmap.md`** (este) | **¿Por dónde voy y qué falta?** | **Todo el recorrido** |
| `feature_list.json` | ¿Qué hace exactamente la feature N? | Una feature |
| `progress/current.md` | ¿En qué quedó la última sesión? | Una sesión |
| `progress/history.md` | ¿Qué pasó y cuándo? | Bitácora, append-only |
| *(fuera del harness)* | ¿Qué quiero que haga el producto? | Sin fecha |

**Regla de convivencia:** este archivo **no repite** el contenido de los otros,
enlaza a ellos. Si una etapa necesita más de cinco líneas aquí, es que su sitio
es el `intent` de una feature.

---

## Dónde estás ahora mismo 📍

> TODO: una o dos frases. No «vamos por la feature 9», sino **qué sabe hacer el
> proyecto y qué todavía no**. Ejemplo real:
> *«Sabes traer los ficheros del banco y sabes entenderlos. Todavía no sabes
> guardarlos: ninguna línea escribe un movimiento en la base de datos.»*

---

## El recorrido en etapas

Leyenda: ✅ hecho · 🟡 a medias · ⏸ esperando al humano · ⬜ sin empezar ·
⚠️ hecho con deuda

> Una etapa NO es una feature: es un **tramo del camino** que puede costar una
> feature o cinco. Se nombran por lo que el proyecto **sabe hacer** al
> terminarlas, no por la tecnología que usan.

| # | Etapa | Estado | Features |
|---|---|---|---|
| E0 | TODO: cimientos (arranque, config, errores, tests) | | |
| E1 | TODO: | | |
| E2 | TODO: | | |
| … | | | |

### E0 — TODO: título

> TODO: tres o cuatro líneas por etapa como mucho, con enlaces clicables al
> código (`archivo.ts:línea`) y a los docs. Si necesitas más, el detalle va en
> el `intent` de la feature.

---

## El eje que la lista de features esconde

> **Opcional, pero suele existir.** La lista de features es plana y hace parecer
> que todo pasa una vez. Si en tu proyecto hay algo que **se repite por cada X**
> (por cada banco, por cada idioma, por cada integración, por cada tipo de
> usuario), dilo aquí con su cuenta: es la diferencia entre «queda un paso» y
> «quedan siete». Anota también qué arrastra cada repetición **fuera del
> código** (dar de alta algo a mano, conseguir una muestra, pedir una clave).

---

## Cabos sueltos con dueño

> Cosas que están mal **a propósito** y dónde se arreglan. La columna «lo
> resuelve» es la que importa: **un cabo suelto sin etapa es un cabo suelto que
> se va a perder.** Que la tabla muestre «sin dueño» es información, no un
> fallo — pero es lo primero que hay que mirar al planificar.

| # | Cabo suelto | Lo resuelve |
|---|---|---|
| 1 | TODO: | |

---

## Deberes del humano pendientes (no son código)

> Lo que tiene que hacer él a mano y es facilísimo de perder entre features:
> dar de alta algo en una consola externa, conseguir una muestra real, decidir
> un valor que solo él sabe. Suele venir de los bloques 📌 de los
> `specs/<nn>-<feature>/decisions.md`.

- TODO:

---

## Cómo se mantiene este archivo

1. **Se lee al empezar** la sesión, después de `progress/current.md`
   (`proceso/AGENTS.md` §1).
2. **Se actualiza al cerrar** una feature, en el mismo paso en que se vacía
   `current.md` (`proceso/AGENTS.md` §5): cambiar el estado de su etapa y tachar el
   cabo suelto que haya resuelto. Normalmente son **dos líneas**.
3. **No crece.** Si una etapa necesita más de cinco líneas, su sitio es el
   `intent` de una feature, no aquí.

> El punto 2 no es decorativo: es lo único que impide que este archivo acabe
> como acaban los documentos de producto que nadie vuelve a tocar — pareciendo
> vigentes mientras contradicen al código.
