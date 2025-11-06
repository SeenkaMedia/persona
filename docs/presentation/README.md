# Persona - Presentación para Stakeholders

**Audiencia Principal**: Pablo (CEO), Favio (Chief Customer Operations)
**También presentes**: Diego (Lead Dev), Zaca (Stream A Dev)
**Objetivo**: Conversación sobre el proyecto, validar entendimiento, identificar puntos de decisión
**Tono**: Colaborativo, no rígido, conversación distendida

**Nota**: No sé quién presenta primero o qué cubre Zaca. Estar listo para colaborar, hacer handoffs, o responder juntos.

---

## Aclaración de Terminología

**IMPORTANTE** - Para evitar confusión:
- **Usuarios internos** = Equipo de Seenka (Pablo, Favio, analistas, operadores)
- **Herramientas internas** = Dashboards, APIs, controles que Persona entrega a Seenka
- **Clientes de Seenka** = Empresas/marcas que pagan por insights (downstream, fuera del scope de Persona)
- **Flujo completo**: Persona captura datos → Herramientas internas para equipo Seenka → (proceso separado) → Insights/reportes para clientes de Seenka

---

## Estructura de la Conversación

### 1️⃣ Contexto: "¿Qué Estamos Construyendo?" (2-3 slides)

**Mensaje central**: Basándome en nuestras conversaciones, así entiendo la visión técnicamente

#### Talking Points:

**Lo que ustedes quieren lograr:**
- Inteligencia sobre cómo las plataformas targetean diferentes demografías
- Datos de anuncios que no están disponibles públicamente
- Entender patrones de targeting a través de múltiples perfiles
- Alimentar al equipo de Seenka con data para generar insights valiosos para sus clientes

**Lo que eso requiere técnicamente:**
- Personas digitales que las plataformas no puedan distinguir de usuarios reales
- Coherencia comportamental - cada acción debe tener sentido en el contexto de la "vida digital" de esa persona
- Replicar fielmente la huella digital que dejaría una persona real

**Por qué es complejo:**
- No es solo automatización - es simulación de comportamiento humano realista
- Cross-platform coherence: Si veo un anuncio de meal kit en TikTok, busco "meal prep" en Google, veo tutorial en YouTube
- Anti-detección: timing, fingerprinting, variación comportamental

**El valor único: Investigación de algoritmos de targeting**
- No solo capturamos anuncios - estudiamos POR QUÉ este perfil recibió este anuncio
- Reverse-engineering de la lógica de las plataformas
- Patrones de targeting que revelan estrategias de advertisers

#### Preguntas de Conversación:
- ¿Estoy entendiendo correctamente la visión?
- ¿Qué es más valioso: los datos crudos, los insights de targeting, o ambos?
- ¿Cómo imaginan que el equipo interno usa esta data para generar insights para sus clientes?

#### Visual: Intelligence Cycle
Diagrama mostrando: Persona comporta → Plataforma targetea → Capturamos → Analizamos patrones → Herramientas internas

---

### 2️⃣ Capacidades Técnicas: "¿Cómo Lo Hacemos?" (5-6 slides) ⭐

**Mensaje central**: Estos son los pilares técnicos necesarios - mapean a complejidad y riesgo

**NOTA**: Esta es la sección más importante - donde más hemos trabajado y donde necesito más feedback

#### Pilares Principales:

**1. Realismo Comportamental** ⭐⭐ (El diferenciador clave)

**Por qué es lo más importante:**
- Sin esto, nos detectan y banean inmediatamente
- Es lo que hace que los datos capturados sean representativos de usuarios reales
- Es la ciencia detrás de la simulación

**Qué incluye:**
- **Coherencia cross-platform**: Acciones en una plataforma afectan comportamiento en otras
  - Ejemplo detallado:
    - Lunes: Ve ad de meal kit en TikTok
    - Martes: Busca "meal prep ideas" en Google, sigue cuentas de comida en Instagram
    - Miércoles: Ve tutorial de meal prep en YouTube, interactúa con contenido de cocina en TikTok
    - Jueves: Considera compra de meal kit en Facebook
  - Cada acción es consecuencia lógica de las anteriores

- **Evolución temporal**: Intereses que cambian, eventos de vida que se reflejan
  - Ejemplo: Persona embarazada → búsquedas cambian gradualmente → recibe ads de bebés
  - No cambios abruptos - evolución natural como humanos reales

- **Dinámica de hogares**: Familia con intereses correlacionados pero distintos
  - Ejemplo: Hogar de 4 personas
    - Padre (35): deportes, finanzas, tecnología
    - Madre (33): fitness, cocina, decoración
    - Hijo (10): videojuegos, dibujos
    - Hija (7): princesas, mascotas
  - Intereses compartidos: viajes familiares, películas Disney
  - Mismo IP, dispositivos compartidos ocasionales, eventos correlacionados

- **Digital footprint auténtico**: El rastro que dejamos debe ser indistinguible de persona real
  - Historial de búsquedas coherente
  - Patrones de uso (mañana vs noche, días laborales vs fin de semana)
  - Typos ocasionales, clicks erróneos, distracciones
  - Tiempo realista en cada actividad

**Sistema de 3 Capas** (técnico pero importante para entender flexibilidad):
- **Narrativas (AI)**: "Esta persona va a buscar recetas hoy porque vio ad de comida ayer"
  - LLM genera planes de actividad diaria/semanal
  - Valida coherencia y realismo
  - Se adapta basado en historial

- **Primitivas comportamentales**: browse_feed(), watch_video(), search()
  - Bloques reutilizables de comportamiento
  - Adaptables a cada plataforma
  - Testeables independientemente

- **Acciones atómicas**: scroll, click, wait (con variación humana)
  - Movimientos precisos del mouse
  - Timing con variación realista
  - Errores humanos ocasionales

**Por qué esta arquitectura:**
- Permite testing granular
- Fácil adaptar a nuevas plataformas
- El AI puede mejorar sin tocar el código base
- Debuggeable cuando algo falla

---

**2. Infraestructura y Anti-Detección** (La fundación)

**Componentes clave:**
- **Multi-dispositivo**:
  - Desktop (Chrome, Firefox, Safari)
  - Móvil (Android, iOS)
  - Potencialmente OTT (Smart TV) en futuro
  - Cada persona tiene múltiples dispositivos como usuario real

- **Multi-plataforma desde el inicio**:
  - TikTok (M1 - validación inicial)
  - Instagram, YouTube, Facebook (M2)
  - Expandible a Twitter/X, Snapchat, Pinterest, etc.

- **Fingerprinting sofisticado**:
  - Canvas, WebGL, audio fingerprints
  - User agent, screen resolution, timezone, language
  - Font enumeration, hardware info
  - GPS spoofing con movimiento realista (futuro)

- **Proxies residenciales**:
  - IPs residenciales, no datacenter
  - Asignación por hogar (familia comparte IP)
  - Rotación inteligente solo cuando es necesario
  - Integración con infraestructura de scraping existente

**Estrategia anti-detección:**
- No es un solo truco - es combinación de decenas de técnicas
- Timing variation (humanos no son robots)
- Rate limiting (no exceder límites de plataforma)
- Fingerprint uniqueness (cada dispositivo diferente pero consistente)
- Behavioral diversity (no dos personas iguales)

---

**3. Inteligencia de Targeting** 🆕 (La entrega de valor)

**Más allá de la captura:**
- No solo CUÁLES anuncios vio cada persona
- Sino POR QUÉ este perfil específico recibió este anuncio específico
- Qué señales de targeting activaron esta impresión

**Investigación activa de algoritmos:**
- Experimentación controlada: cambiar un factor, observar cambio en ads
- Pattern recognition entre demografías
- Identificar targeting parameters que advertisers configuraron
- Entender biases y prioridades del algoritmo de cada plataforma

**Contexto relevante (mencionar si surge):**
- Tengo experiencia con Meta Ads Manager (lado del advertiser)
- Conozco qué targeting options existen y cómo se configuran
- Esto ayuda a reverse-engineer desde perspectiva informada
- Potencial valor futuro si esto se integra con campañas de clientes de Seenka

**Output para equipo interno:**
- No solo "Persona X vio Ad Y"
- Sino "Persona X (mujer, 28, fitness) vio Ad Y porque algoritmo detectó búsquedas de Z + engagement con contenido W"
- Insights accionables sobre estrategias de targeting

---

**4. Visibilidad y Control Humano** 🔍 (Confianza y transparencia)

**El concepto clave: VNC - Ventana a la vida digital**

**Qué es:**
- Cualquier empleado de Seenka puede "abrir una ventana" y ver lo que hace una persona
- VNC (Virtual Network Computing) = acceso visual en tiempo real al navegador de la persona
- Como mirar por encima del hombro de un usuario real

**Por qué es importante:**
- **Transparencia**: No es una caja negra - pueden ver exactamente qué pasa
- **Validación**: Verificar que el comportamiento se ve realista
- **Debugging**: Si algo falla, ver exactamente qué pasó
- **Control**: En cualquier momento, pausar automation y tomar control manual
- **Confianza**: Stakeholders pueden observar sin depender solo de reportes

**Casos de uso:**
- Demo para stakeholders: "Miren, esta persona está scrolling TikTok ahora mismo"
- QA: "¿Se ve este comportamiento como humano real?"
- Investigación: "Vamos a pausar y explorar manualmente este ad que apareció"
- Training: "Así es como la persona interactúa con la plataforma"

**Modo de operación:**
- **Por defecto**: Autonomous - personas operan solas 24/7
- **Cuando se necesita**: Human peek/control - sin interrumpir otras personas
- **Handoff suave**: Automation → Human → Automation

**Metáfora del laboratorio:**
- Imaginen un laboratorio con paredes de vidrio
- Pueden observar los experimentos en cualquier momento
- Pueden entrar y ajustar si es necesario
- Pero normalmente solo observan que todo funcione

**Implicaciones técnicas:**
- VNC server en cada container
- Access control (quién puede ver qué)
- Logging de cuándo alguien tomó control (audit trail)
- No afecta performance de otras personas

---

**5. Operaciones y Herramientas Internas** (Lo que ustedes/equipo ven)

**Para usuarios internos de Seenka:**

**Dashboards en tiempo real:**
- Estado de cada persona (activa, pausada, detectada)
- Ad capture gallery (filtros por plataforma, fecha, persona)
- Activity feed (qué hace cada persona ahora)
- Cost tracking (cuánto cuesta mantener X personas)
- Detection alerts (si algo se detecta)

**APIs para integración:**
- Query ad data capturada
- Filtrar por targeting signals
- Exportar para análisis
- Integración con Stream A de Zaca (modelo híbrido)

**Controles operacionales:**
- Crear/pausar/eliminar personas
- Ajustar comportamientos
- Configurar targeting experiments
- Ver logs y debugging info

**Reportes e insights:**
- No es scope de Persona generar los reportes finales para clientes de Seenka
- Pero sí proveer las herramientas para que el equipo interno pueda:
  - Explorar los datos
  - Identificar patrones
  - Generar sus propios insights
  - Crear sus reportes para clientes

**Claridad de roles:**
- Persona = sistema de captura e investigación
- Equipo de Seenka = analistas que usan la data para crear valor para clientes finales
- Separación limpia de responsabilidades

#### Preguntas de Conversación:
- ¿Cuáles capacidades son más críticas validar en M1?
- ¿Qué nivel de riesgo de detección es aceptable?
- ¿Cómo priorizar entre cantidad de anuncios vs calidad de insights?
- ¿Qué tan profundo queremos ir en la investigación de algoritmos?
- ¿Quién del equipo necesitaría acceso VNC para observar/controlar?
- ¿Qué herramientas internas son más urgentes para el equipo?

#### Visuales:
- **Behavioral Coherence Journey**: Cascada de comportamiento a través del tiempo y plataformas
- **VNC Control**: Diagrama mostrando autonomous operation ↔ human peek/control
- **3-Layer System**: Narrativas → Primitivas → Acciones (opcional, si preguntan)

---

### 3️⃣ Ejecución: "¿Cómo Avanzamos?" (2-3 slides)

**Mensaje central**: Tres fases que construyen una sobre otra. Necesito su input en puntos de decisión clave.

#### Fases (fechas TBD):

**M1: Foundation & Proof of Concept**
- **Objetivo**: Validar que el approach funciona
- **Scope**: TikTok como plataforma inicial, ~5-10 personas
- **Duración estimada**: [TBD]
- **Entregables**: PoC demo con VNC access, ad capture funcionando, métricas de realismo
- **Checkpoint**: ¿Funciona el realismo? ¿Capturamos lo que necesitamos? ¿Go/No-go para M2?

**M2: Multi-Platform & Intelligence**
- **Objetivo**: Expandir capacidades y plataformas
- **Scope**: Instagram, YouTube, Facebook + capacidades de IA avanzadas
- **Entregables**: Multi-platform coherence, herramientas internas básicas, investigación de algoritmos
- **Checkpoint**: ¿Coherencia funcionando? ¿Insights valiosos? ¿Escalar a producción?

**M3: Scale & Production**
- **Objetivo**: Escalar a producción con excelencia operacional
- **Scope**: [TBD] personas 24/7, herramientas internas completas
- **Entregables**: Sistema production-ready, documentación, runbooks operacionales
- **Checkpoint**: Go-live production

#### Puntos de Decisión Donde Necesito Su Input:

**Criterios de Validación:**
- ¿Qué define "éxito" en cada fase?
- ¿Qué métricas importan? (tasa de detección, volumen de ads, calidad de insights)
- ¿Cuántos false positives/negatives son aceptables en ad detection?

**Tolerancia a Riesgo:**
- Violaciones de ToS de plataformas - ¿dónde está la línea?
- Si nos detectan, ¿cuál es la estrategia de respuesta?
- Legal/compliance - ¿qué framework necesitamos establecer?
- ¿Qué porcentaje de personas detectadas es aceptable? (ej: <5%, <10%?)

**Priorización de Plataformas:**
- Después de TikTok, ¿cuáles plataformas son más valiosas para el equipo/clientes?
- ¿Priorizar por volumen de anuncios o por tipo de insights?
- ¿Hay plataformas específicas que los clientes de Seenka piden más?

**Herramientas Internas:**
- ¿Qué formato necesita el equipo interno?
- ¿Dashboards, reportes, APIs, todo lo anterior?
- ¿Qué tan personalizable debe ser?
- ¿Quiénes son los usuarios principales de estas herramientas?

**Coordinación con Stream A (Zaca):**
- ¿Cómo integramos los dos approaches (synthetic vs automated)?
- ¿Cómo presentamos el modelo híbrido internamente y a clientes?
- ¿Qué datos compartimos entre streams?
- ¿Hay overlap que debemos evitar o aprovechar?

**Investigación de Algoritmos:**
- ¿Cuánto esfuerzo invertir en entender la lógica de cada plataforma?
- ¿Es esto algo que documentamos y vendemos como expertise?
- ¿O solo lo usamos internamente para mejorar targeting?

**Recursos y Constraints:**
- ¿Hay restricciones de presupuesto que deba conocer ahora?
- ¿Limitaciones de equipo/headcount?
- ¿Timelines driven por needs de clientes o internos?

#### Preguntas de Conversación:
- ¿Este phasing tiene sentido o deberíamos priorizar diferente?
- ¿Cómo prefieren que les traiga estas decisiones? ¿Reuniones regulares? ¿Por demanda?
- ¿Qué tan hands-on quieren estar en la investigación de algoritmos?
- ¿Hay algo crítico que no estoy considerando?

#### Visual: Timeline con Checkpoints
Timeline horizontal con 3 milestones, mostrando input necesitado y output esperado en cada fase

---

## Notas para la Conversación

**Lo que NO hacer:**
- ❌ Leer slides como script
- ❌ Ser demasiado técnico/usar jargon innecesario
- ❌ Presentar como decisiones ya tomadas
- ❌ Estructura rígida que no permite pivotear
- ❌ Competir o contradecir a Diego/Zaca si presentan primero

**Lo que SÍ hacer:**
- ✅ Usar visuales como anchors para conversación
- ✅ Hacer preguntas genuinas
- ✅ Escuchar y adaptar basado en sus reacciones
- ✅ Validar entendimiento constantemente
- ✅ Ser específico sobre qué necesitas de ellos
- ✅ Colaborar con Diego/Zaca - somos un equipo
- ✅ Si no sabes algo, decir "buena pregunta, dejame investigar eso"

**Posibles derivaciones de conversación:**
- **Si preguntan sobre costos**: Tengo estimados preliminares pero necesito validar supuestos (proxies, compute, LLM calls)
- **Si preguntan sobre timeline**: Fechas TBD, depende de su urgencia y recursos disponibles
- **Si preguntan sobre equipo**: Equipo pequeño, roles claros pero flexible, colaboración con Diego/Zaca
- **Si preguntan sobre Stream A**: Enfatizar complementariedad, no competencia. Zaca puede explicar mejor su approach.
- **Si preguntan sobre clientes específicos**: Enfocarme en capabilities generales, ellos saben mejor qué necesitan sus clientes
- **Si cuestionan factibilidad**: Mostrar confianza pero realismo - es complejo, por eso approach iterativo

**Cierres posibles:**
- "¿Qué preguntas tienen ustedes?"
- "¿Qué les preocupa más de este approach?"
- "¿Cuál sería el next step ideal desde su perspectiva?"
- "¿Hay algo que no cubrí que debería?"
- "¿Cómo quieren que coordinemos con Diego y Zaca?"

**Si Diego/Zaca presentan primero:**
- Tomar notas de lo que cubren
- Identificar dónde Persona se conecta
- Resaltar complementariedad
- No repetir lo que ya dijeron
- Referirse a sus puntos: "Como mencionó Diego/Zaca..."

---

## Materiales de Apoyo

**En el repo:**
- `planning/MILESTONES.tsv` - Hoja resumen de milestones
- `planning/01-05_*.tsv` - Detalles por capacidad (5 páginas)
- `planning/es/` - Todo en español
- `CLAUDE.md` - Documentación técnica completa del sistema

**Externos:**
- Miro diagram de Diego (como contexto histórico)
- Google Sheets formateado con milestone planning

**Durante presentación:**
- Tener milestone sheets a mano (si preguntan detalles)
- CLAUDE.md abierto (reference rápida si necesario)
- VNC demo preparado (si es posible mostrar en vivo)
