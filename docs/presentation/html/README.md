# Persona Presentation - HTML Version

HTML presentation for stakeholder meeting built with vanilla HTML/CSS/JS.

## Quick Start

**Open the presentation:**
```bash
# Option 1: Use the serve script (recommended)
cd /home/mariano/wdir/snk/digital/persona/docs/presentation/html
./serve.sh
# Then navigate to: http://localhost:8000/html/

# Option 2: Run server from presentation directory
cd /home/mariano/wdir/snk/digital/persona/docs/presentation
python3 -m http.server 8000
# Then navigate to: http://localhost:8000/html/

# Option 3: Open directly in browser (images might not load)
xdg-open /home/mariano/wdir/snk/digital/persona/docs/presentation/html/index.html
```

## Features

- **14 slides** following the presentation structure
- **Seenka brand styling** (colors, fonts, logo)
- **Custom SVG icons** for 5 capability pillars
- **Integrated diagrams** from `../visuals/renders/`
- **Speaker notes** with detailed talking points (toggle with `S` key)
- **Keyboard navigation** for smooth presentation flow

## Navigation

### Keyboard Shortcuts

- `←` / `→` - Previous/Next slide
- `Space` - Next slide
- `Home` - Jump to first slide
- `End` - Jump to last slide
- `S` - Toggle speaker notes (hidden panel at bottom)
- `?` - Show keyboard shortcuts help

### Mouse/Click

- **Click anywhere on slide** - Advance to next slide
- **Navigation buttons** - Bottom right corner (← →)
- **Slide counter** - Shows current position (e.g., "5 / 14")

## Speaker Notes

Press `S` to toggle speaker notes that slide up from the bottom. Each slide has:
- Context and framing for that slide
- Key talking points
- Questions to ask stakeholders
- Things to emphasize or be prepared for

**Tip:** Keep notes visible on external monitor while presenting on main screen.

## Presentation Structure

1. **Title Slide** - Full-screen gradient, Seenka branding
2. **Agenda** - Sets conversational tone
3. **El Desafío y el Valor** - Context and unique value proposition
4. **5 Pilares (Intro)** - Overview with large icons
5-10. **Individual Pillars** - Deep dive on each capability
11. **Timeline** - 3-phase execution plan
12. **Puntos de Decisión** - Where you need stakeholder input
13. **Next Steps** - Collaborative closing
14. **Materiales de Apoyo** - Reference to full documentation

## Design Notes

**Colors:**
- Primary: `#5B5FED` (Seenka purple/blue)
- Secondary: `#FF7F6A` (coral/orange for accents)
- Background: White with light gray elements

**Typography:**
- Font: Lato (Google Fonts) - clean, modern sans-serif
- Headings: Bold, large (48-56px)
- Body: 24px for readability

**Layout:**
- Minimal text (4-5 lines max per slide)
- Lots of whitespace
- Seenka logo top-left
- Tagline top-right
- Content centered

## Technical Details

**Self-contained:**
- Single HTML file with embedded CSS/JS
- No external dependencies except:
  - Google Fonts (Lato) - loaded via CDN
  - Diagram images (relative paths to `../visuals/renders/`)

**Browser Compatibility:**
- Modern browsers (Chrome, Firefox, Safari, Edge)
- Uses CSS Grid, Flexbox, CSS Variables
- SVG for icons and Seenka logo

## Customization

### Changing Content

Edit the HTML directly - each `<section class="slide">` is one slide.

### Adjusting Diagrams

Update image paths in `<img>` tags if diagrams are moved:
```html
<img src="../visuals/renders/02_behavioral_coherence.png" alt="..." class="diagram">
```

### Modifying Speaker Notes

Each slide has a `.speaker-notes` div - edit the content there.

### Updating Icons

The 5 pillar icons (Slide 4) are inline SVG - edit the `<svg>` paths to change appearance.

## Exporting to PDF

To create a PDF version for distribution:

1. **Open in browser** (Chrome/Chromium recommended)
2. **Print to PDF** (`Ctrl+P` or `Cmd+P`)
3. **Settings:**
   - Layout: Landscape
   - Paper size: Custom (16:9 ratio, e.g., 10" x 5.625")
   - Margins: None
   - Background graphics: Yes
   - Headers/Footers: No

**Tip:** Hide speaker notes (`S` key) before printing.

## Troubleshooting

**Images not loading:**
- Check that `../visuals/renders/*.png` files exist
- Use a local web server instead of opening file directly
- Verify relative paths are correct

**Fonts not loading:**
- Requires internet connection for Google Fonts CDN
- Or download Lato and embed as base64 data URLs

**Keyboard shortcuts not working:**
- Click on the presentation area to ensure focus
- Check browser console for JavaScript errors

## Files Structure

```
html/
├── index.html          ← Main presentation file (this is it!)
└── README.md           ← This file

../visuals/renders/
├── 01_behavioral_system.png
├── 02_behavioral_coherence.png
├── 03_timeline.png
└── 04_vnc_control.png
```

## Tips for Presenting

1. **Practice with notes visible** first to get familiar with talking points
2. **Hide notes during actual presentation** (unless on external monitor)
3. **Use conversational questions** (in italics) to engage stakeholders
4. **Don't read slides verbatim** - they're conversation anchors
5. **Be ready to skip slides** if conversation flows differently
6. **Have milestone sheets handy** for detailed questions

## Next Steps

After reviewing the presentation:
- Test in actual presentation environment
- Practice timing (aim for ~30-40 min with discussion)
- Prepare for Q&A based on speaker notes
- Consider printing key diagrams as handouts
