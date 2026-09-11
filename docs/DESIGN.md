---
name: MobX.dart documentation
description: White and blue technical documentation with interactive Flutter examples.
colors:
  paper: "#ffffff"
  surface: "#ffffff"
  ink: "#173b63"
  muted: "#536e8b"
  line: "#e0e5e9"
  line-strong: "#bfccd8"
  soft: "#f0f3f6"
  soft-band: "#f7faff"
  halo: "#f3f8ff"
  code: "#f8fafc"
  accent: "#1974c7"
  heading-accent: "#1974c7"
  green: "#438b73"
  button-hover: "#405872"
  peach: "#fff0e5"
  peach-edge: "#edc5ab"
  peach-ink: "#9c482a"
  blue: "#eaf2ff"
  blue-edge: "#bad0ed"
  blue-ink: "#386ca6"
  mint: "#e8f5ee"
  mint-edge: "#b8d9c7"
  mint-ink: "#367560"
  violet: "#efebfa"
  violet-ink: "#72629b"
  pink: "#fbeaf0"
  pink-ink: "#a45d76"
  dark-paper: "#15212d"
  dark-surface: "#1b2a39"
  dark-ink: "#e9eff4"
  dark-muted: "#afbfce"
  dark-line: "#344454"
  dark-line-strong: "#52677b"
  dark-soft: "#243545"
  dark-soft-band: "#192b38"
  dark-halo: "#273540"
  dark-code: "#172532"
  dark-accent: "#f2ac87"
  dark-heading-accent: "#95bce8"
  dark-green: "#7ac2a9"
  dark-button-hover: "#cbddec"
  dark-peach: "#422f29"
  dark-peach-edge: "#745142"
  dark-peach-ink: "#f2b490"
  dark-blue: "#233a52"
  dark-blue-edge: "#426487"
  dark-blue-ink: "#a1c6ef"
  dark-mint: "#233f35"
  dark-mint-edge: "#456b5c"
  dark-mint-ink: "#9fd6bf"
  dark-violet: "#38324b"
  dark-violet-ink: "#c4b8e7"
  dark-pink: "#462f3b"
  dark-pink-ink: "#e7b0c5"
  brand-1: "#376ba5"
  brand-2: "#5082bb"
  brand-3: "#2e5b8c"
  dark-brand-1: "#95bce8"
  dark-brand-2: "#a9c9ee"
  dark-brand-3: "#81afe2"
typography:
  display:
    fontFamily: "Chakra Petch, sans-serif"
    fontSize: "clamp(3.3rem,5.7vw,5.7rem)"
    fontWeight: 750
    lineHeight: 1.08
    letterSpacing: "-.04em"
  headline:
    fontFamily: "Chakra Petch, sans-serif"
    fontSize: "clamp(2.2rem,3.5vw,3.5rem)"
    fontWeight: 700
    lineHeight: 1.16
    letterSpacing: "-.04em"
  body:
    fontFamily: "Poppins, sans-serif"
    lineHeight: 1.85
  gallery-title:
    fontFamily: "Chakra Petch, sans-serif"
    fontSize: "21px"
  gallery-description:
    fontFamily: "Poppins, sans-serif"
    fontSize: "14px"
rounded:
  badge: "5px"
  filter: "7px"
  control: "8px"
  home-button: "10px"
  flutter-frame: "12px"
  segmented-group: "13px"
  workbench: "18px"
spacing:
  compact: "8px"
  control: "12px"
  content: "24px"
components:
  home-button:
    backgroundColor: "{colors.ink}"
    textColor: "{colors.paper}"
    rounded: "{rounded.home-button}"
    padding: "16px 22px"
  home-button-hover:
    backgroundColor: "{colors.button-hover}"
    textColor: "{colors.paper}"
  gallery-cta:
    backgroundColor: "{colors.accent}"
    textColor: "white"
    rounded: "{rounded.control}"
    padding: "12px 20px"
  gallery-filter-selected:
    backgroundColor: "{colors.accent}"
    textColor: "white"
    rounded: "{rounded.filter}"
    padding: "8px 14px"
  flutter-frame:
    backgroundColor: "{colors.paper}"
    rounded: "{rounded.flutter-frame}"
---

# Design System: MobX.dart documentation

## Overview

The approved identity uses white and light backgrounds, blue text, techno headings in Chakra Petch, and Poppins body copy. It is a technical learning site whose code, diagrams, and working examples supply the visual interest. Optional dark mode maps the same semantic roles to the existing dark palette.

This document records the incumbent implementation; it does not establish a new creative metaphor. The CSS and Vue components remain the implementation authority, including their cascade. The gallery extends the existing reading and hands-on experience.

**Key Characteristics:**

- White surfaces and blue typography in light mode.
- Chakra Petch headings paired with Poppins body copy.
- Quiet borders, gently rounded controls, and restrained shadows.
- Real MobX SVG identity and Lucide icons for custom interface controls.

## Colors

### Primary

Use ink for primary text, muted for supporting text, accent for highlighted homepage words and gallery actions, and the brand scale for VitePress links and focus. Heading accent has its own dark-mode role. Gallery selected filters and run buttons currently use the fixed light accent and white text in both modes; they do not inherit the peach dark accent.

### Secondary

Peach, blue, and mint each have a fill, border, and ink role for the action/observable/reaction illustration and example states. Violet and pink provide supporting API-family accents. Green marks active or successful state. These existing supporting colors do not replace the blue-and-white identity.

### Neutral

Paper and surface define page and container backgrounds. Soft, soft-band, halo, and code distinguish controls, section bands, diagrams, and source panels. Line and line-strong separate content and outline controls. The dark-prefixed tokens document the corresponding dark-mode overrides; use semantic CSS properties so theme switching remains coherent.

## Typography

Chakra Petch is used for homepage headings, navigation identity, and documentation h1–h3. Poppins is the global body family. Code retains VitePress's mono family. Imported font files provide Poppins weights 400/500/600 and Chakra Petch 600/700; some existing CSS requests intermediate or heavier weights, as captured above, which the browser resolves from those faces.

The homepage display and headline roles are fluid. The hero is overridden at the observed tablet and mobile breakpoints; gallery titles become smaller on narrow screens. Documentation retains VitePress hierarchy with local heading letter-spacing and body line-height overrides. Do not infer an additional global body size from a page-specific paragraph rule.

## Layout

The homepage uses page layout without a sidebar. Documentation and gallery articles retain the normal VitePress sidebar. Navigation is 72px high with a 1440px maximum container. Homepage sections use max(5vw, calc((100vw - 1320px)/2)) inline padding and 24px mobile gutters.

The homepage hero and source/result workbench use two columns; API-family links use three columns, reducing to two at 1050px and one at 760px. Hero, workbench, learning, and quotation layouts stack at 760px. Gallery filters wrap; gallery examples are divider-separated rows with a leading icon, title and description, and trailing arrow. Their gap and title size reduce at 600px.

Embedded Flutter views occupy explicit per-example heights inside a full-width frame. Preserve local horizontal scrolling for source blocks and avoid page-level horizontal overflow.

## Elevation & Depth

White surfaces, pale section bands, and thin borders establish most depth. The existing workbench uses a diffuse shadow; selected segmented controls use a small shadow; the homepage triad uses a short solid offset. Exact shadow expressions are recorded in the sidecar. These are incumbent treatments, not a mandate to add shadows to gallery rows.

## Shapes

Controls use modest rounded corners; badges are tighter, while framed examples and the homepage workbench have larger rounding. Gallery rows rely on separators rather than individual floating cards. Circular status indicators and the MobX illustration retain their existing geometry.

## Components

### Buttons and links

Homepage primary buttons use ink on paper-inverted colors and lift slightly on hover. Gallery run/retry controls use blue with white text. CTA arrows move right on hover and keyboard focus; reduced-motion preference suppresses this translation and its transition. Global keyboard focus uses a visible brand outline; gallery run/retry controls have their own lighter-blue focus outline.

### Filters and navigation

Gallery filters expose their selected state with aria-pressed and a blue fill. Homepage example choices use a pale grouped container and a white selected segment. VitePress owns normal navigation and article sidebars. Keep the homepage sidebar-free and use the actual /mobx.svg asset for identity.

### Examples and source

A Flutter frame contains idle, loading, ready, and retry states, with a caption and an Open app link. Idle frames explain that Run loads the runtime; loading uses a status announcement and failures use an alert. These are real Flutter widgets with MobX, not visual simulations. Source is rendered from local Dart includes; there is no live source editor.

### Icons and diagrams

Use Lucide for custom interface icons, with decorative icons hidden from assistive technology. The action/observable/reaction diagram and colored API-family markers remain explanatory illustrations. Do not substitute an invented mark for the MobX SVG.

## Do's and Don'ts

### Do:

- Do preserve white and blue as the default identity and keep the optional dark theme coherent.
- Do retain Chakra Petch headings and Poppins body copy.
- Do preserve visible keyboard focus, semantic state, and reduced-motion behavior.
- Do build gallery extensions from the incumbent documentation and example patterns.

### Don't:

- Don't introduce a homepage sidebar or a live source editor.
- Don't replace the MobX SVG with an invented logo.
- Don't turn the gallery into an unrelated visual redesign.
