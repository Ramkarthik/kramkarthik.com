# Design System

## Color Palette

### Primary Colors
- **Dark Text**: `#2c2c2c` (almost black, used for body text)
- **Darker Text**: `#1a1a1a` (used for headings)
- **Medium Gray**: `#3a3a3a` (used for paragraph text)
- **Light Gray**: `#666` (used for subtitles)
- **Accent Color**: `#c8956f` (warm burnt sienna/tan - used for borders, dividers, email highlights)

### Background
- **Gradient Background**: `linear-gradient(135deg, #fafaf8 0%, #f5f5f0 100%)` (subtle off-white to cream gradient at 135 degrees)
- **Highlight Box Background**: `#fdf8f3` (very light warm cream)
- **Contact/Content Box Background**: `#fff` (white)

### Borders & Dividers
- **Light Border**: `#e0e0d8` (subtle light gray for borders)
- **Accent Border**: `#c8956f` (burnt sienna for left-side section borders and accent dividers)
- **Very Light Border**: `1px solid #e0e0d8` (footer top border)

## Typography

### Font Families
- **Body & Paragraphs**: `'Merriweather', serif` (elegant, editorial serif font from Google Fonts)
- **UI Elements & Accents**: `'IBM Plex Sans', sans-serif` (clean, professional sans-serif)

### Font Import
```html
<link href="https://fonts.googleapis.com/css2?family=Merriweather:ital,wght@0,400;0,700;1,400&family=IBM+Plex+Sans:wght@400;500;600&display=swap" rel="stylesheet">
```

### Font Sizes & Weights
- **H1 (Page Title)**: `3.5rem`, `font-weight: 700`, `letter-spacing: -1px`
- **Subtitle**: `1.25rem`, `font-style: italic`, `font-weight: 400`
- **H2 (Section Headings)**: `2rem`, `font-weight: 700`
- **Body Paragraphs**: `1.05rem`, `font-weight: 400`
- **Highlighted/Callout Text**: `1rem`, `font-style: italic`
- **Footer**: `0.95rem`, `font-family: 'IBM Plex Sans'`

### Line Height
- **Body**: `1.7` (generous spacing for readability)

## Layout & Spacing

### Container
- **Max Width**: `720px`
- **Padding**: `60px 24px` (top/bottom 60px, left/right 24px)
- **Margin**: `0 auto` (centered on page)

### Section Spacing
- **Sections**: `margin-bottom: 60px`
- **Divider Lines (large)**: `margin: 40px 0` with `margin-bottom: 20px` for headings

### Dividers
- **Large Divider** (under header):
  - Width: `60px`
  - Height: `3px`
  - Background: `linear-gradient(90deg, #c8956f, transparent)`
  - Margin: `40px 0`

- **Small Divider** (between sections):
  - Height: `2px`
  - Background: `linear-gradient(90deg, #e0e0d8, transparent)`
  - Margin: `40px 0`

## Animations

### Page Load Animation
All sections fade in and slide up on page load with staggered timing.

**Animation Name**: `fadeInUp`
```css
@keyframes fadeInUp {
    from {
        opacity: 0;
        transform: translateY(20px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}
```

### Section Animation Delays
- **Section 1 (Who I Am)**: `animation-delay: 0.1s`
- **Section 2 (What is Blogosphere)**: `animation-delay: 0.2s`
- **Section 3 (Why I Started It)**: `animation-delay: 0.3s`

**Duration**: `0.8s`
**Timing Function**: `ease-out`

## Special Elements

### H1 Gradient Text
- **Background Gradient**: `linear-gradient(135deg, #1a1a1a 0%, #4a4a4a 100%)`
- **Text Effect**: `-webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text;`
- This creates a subtle dark gradient effect on the main title

### Highlight Box (Callout)
- **Background**: `#fdf8f3`
- **Padding**: `20px`
- **Border Radius**: `8px`
- **Border Left**: `4px solid #c8956f`
- **Font Style**: `italic`
- **Color**: `#4a4a4a`

### Section Borders
- **Left Border**: `4px solid #c8956f` (on H2 headings)
- **Padding Left**: `16px` (on H2 headings)

## Responsive Design

### Mobile Breakpoint: 600px and below
- **H1**: `2.5rem` (from 3.5rem)
- **H2**: `1.5rem` (from 2rem)
- **Container Padding**: `40px 20px` (from 60px 24px)
- **Header Margin Bottom**: `50px` (from 80px)

## Visual Aesthetic

### Overall Tone
- Warm, nostalgic, refined aesthetic
- Evokes the golden era of blogging with modern simplicity
- Subtle elegance through typography and spacing rather than decorative elements
- Minimal but intentional use of color—accent color used sparingly for impact

### Key Design Principles
1. **Generous whitespace** - breathing room between sections
2. **Serif typography** - editorial, thoughtful quality
3. **Warm color palette** - inviting, not cold or corporate
4. **Subtle gradients** - gradient background, gradient text, gradient dividers
5. **Staggered animations** - brings content to life without being flashy
6. **Clear visual hierarchy** - headings clearly distinguish sections

### Atmosphere
This design should feel like settling in to read a well-written article—comfortable, intentional, and focused on content over flash.
