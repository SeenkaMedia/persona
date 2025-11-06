# Presentation Visuals

Esta carpeta contiene los diagramas Mermaid para la presentación de stakeholders.

## Archivos

- `01_intelligence_cycle.mmd` - Ciclo de inteligencia (Contexto)
- `02_behavioral_coherence.mmd` - Coherencia comportamental a través del tiempo (Capacidades)
- `03_timeline.mmd` - Timeline de ejecución con checkpoints (Roadmap)
- `04_vnc_control.mmd` - Control humano VNC (Capacidades - Pilar 4)

## Cómo Renderizar los Diagramas

### Opción 1: Mermaid CLI (Recomendado)

```bash
# Instalar Mermaid CLI
npm install -g @mermaid-js/mermaid-cli

# Renderizar todos los diagramas
cd visuals/
mmdc -i 01_intelligence_cycle.mmd -o renders/01_intelligence_cycle.png -w 1920 -H 1080 -b transparent
mmdc -i 02_behavioral_coherence.mmd -o renders/02_behavioral_coherence.png -w 1920 -H 1080 -b transparent
mmdc -i 03_timeline.mmd -o renders/03_timeline.png -w 1920 -H 1080 -b transparent
mmdc -i 04_vnc_control.mmd -o renders/04_vnc_control.png -w 1920 -H 1080 -b transparent
```

### Opción 2: Web Editor

1. Ir a https://mermaid.live/
2. Copiar contenido de cada archivo `.mmd`
3. Pegar en el editor
4. Descargar como PNG/SVG desde el menú

### Opción 3: VSCode Extension

1. Instalar extensión "Markdown Preview Mermaid Support"
2. Abrir archivo `.mmd`
3. Ver preview
4. Export a imagen

## Customización

Los colores están configurados para Seenka brand:
- Primary color: `#5B5FED`
- Secondary: `#F8F9FA`
- Tertiary: `#E8EAED`

Para cambiar colores, editar la línea `%%{init: {'theme':'base', 'themeVariables': {...}}}%%`

## Uso en Google Slides

1. Renderizar diagramas a PNG (fondo transparente recomendado)
2. Guardar en `renders/`
3. Insertar en Google Slides como imagen
4. Centrar y ajustar tamaño según necesites
