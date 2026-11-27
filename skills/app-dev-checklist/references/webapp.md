# Web Application & PWA Checklist

Applies to **SPAs, SSR/Full-Stack Web Apps, Static Sites, and Progressive Web Apps (PWAs)** (Next.js, React, Vue, Svelte, Astro, Vite, or Vanilla HTML/CSS/JS).

## 1. Favicons, App Icons & Web Manifest

- [ ] **Complete Modern Icon Set (No 404 `/favicon.ico`!)**:
  - `favicon.svg` — scalable vector icon with embedded `@media (prefers-color-scheme: dark)` styling so browser tabs stay legible on both light and dark tab strips.
  - `favicon.ico` (`32x32` or `16/32`) — fallback for legacy tools, RSS readers, and browser `/favicon.ico` probes.
  - `apple-touch-icon.png` (`180x180`, **opaque background**, ~15–20% padding — iOS fills transparency with solid black!).
  - `icon-192.png` (`192x192`) & `icon-512.png` (`512x512`) with `"purpose": "any"`.
  - `icon-maskable-512.png` (`512x512`) with `"purpose": "maskable"` keeping all critical artwork inside the central **80% safe circle** (never combine `"purpose": "any maskable"` on one unpadded icon — it either clips on Android or shrinks on desktop!).
- [ ] **HTML `<head>` Icon & Theme Links**:
  ```html
  <link rel="icon" href="/favicon.ico" sizes="32x32">
  <link rel="icon" href="/favicon.svg" type="image/svg+xml">
  <link rel="apple-touch-icon" href="/apple-touch-icon.png">
  <link rel="manifest" href="/manifest.webmanifest">
  <meta name="theme-color" content="#ffffff" media="(prefers-color-scheme: light)">
  <meta name="theme-color" content="#09090b" media="(prefers-color-scheme: dark)">
  ```
- [ ] **Web App Manifest (`manifest.webmanifest`)**:
  - Include `name`, `short_name` (`<= 12` chars), `description`, `id`, `start_url` (respecting subpath deployments like GitHub Pages `/repo-name/`!), `scope`, `display` (`standalone` or `minimal-ui`), `background_color`, `theme_color`, `lang`, `dir` (`ltr` / `rtl` / `auto`), and `icons`.

## 2. Metadata, SEO & Social Sharing Previews

- [ ] **Document Semantics**:
  - `<html lang="en" dir="ltr">` (or `lang="fa" dir="rtl"`), `<meta charset="utf-8">`, unique descriptive `<title>` per route, `<meta name="description">`, and `<link rel="canonical" href="...">`.
- [ ] **Open Graph & Social Card Tags** (Telegram, Slack, Discord, X/Twitter, LinkedIn, iMessage):
  - `og:title`, `og:description`, `og:type` (`website`), `og:url`, `og:site_name`, and **`og:image`** (`1200x630` PNG/JPG/WebP using an **absolute HTTPS URL** + `og:image:width`, `og:image:height`, `og:image:alt`).
  - `twitter:card` (`summary_large_image`), `twitter:title`, `twitter:description`, `twitter:image`.
- [ ] **Crawlability Control**:
  - Public apps/sites: valid `robots.txt` + `sitemap.xml` + JSON-LD structured data where relevant.
  - Private dashboards / staging environments: `noindex, nofollow` (`X-Robots-Tag` or `<meta name="robots">`) so internal routes never leak into search engines.

## 3. Viewport, Theme, RTL & Accessibility

- [ ] **Mobile & Standalone PWA Viewport**:
  - `<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">` (never disable pinch-zoom with `maximum-scale=1, user-scalable=no` unless building a fixed-canvas game/instrument).
  - Respect notch / home-indicator insets via `env(safe-area-inset-top)`, `env(safe-area-inset-bottom)`, etc., and prefer `100dvh` / `100svh` over `100vh` so mobile browser toolbars don't clip bottom controls.
  - Keep form inputs `font-size >= 16px` on mobile to prevent iOS Safari forced auto-zoom on focus.
- [ ] **Zero-FOUC Dark / Light Theme**:
  - Declare `color-scheme: light dark;` on `:root` so native scrollbars, form controls, and browser background match the active theme, and resolve saved user theme in a tiny blocking inline `<script>` inside `<head>` before first paint to prevent white flashes.
- [ ] **Logical CSS & BiDi / RTL Support**:
  - Prefer CSS logical properties (`margin-inline`, `padding-inline`, `inset-inline-start`, `border-inline-start`, `text-align: start`) over `left`/`right` so switching `dir="rtl"` works cleanly; keep `<pre>`, `<code>`, URLs, emails, and numeric readouts explicitly `dir="ltr"`.
- [ ] **Accessibility & Polish**:
  - Semantic HTML landmarks (`<header>`, `<main>`, `<nav>`, `<dialog>`), visible `:focus-visible` outlines, `aria-label` on icon-only buttons, WCAG AA contrast (`>= 4.5:1`), and `@media (prefers-reduced-motion: reduce)` handling.
  - Custom `404` page, route Error Boundary / fallback UI, empty states, loading skeletons, and double-submit prevention on forms/mutations.

## 4. Performance, Service Worker & Security

- [ ] **Core Web Vitals & Assets**:
  - Set explicit `width` and `height` (or `aspect-ratio`) on images/media to eliminate Cumulative Layout Shift (`CLS = 0`).
  - Use `fetchpriority="high"` + eager loading on the hero/LCP asset, `loading="lazy"` + `decoding="async"` below the fold, and modern formats (`WebP`/`AVIF`, `WOFF2` fonts with `font-display: swap`).
- [ ] **Service Worker (`sw.js`) Safety (If PWA / Offline-Capable)**:
  - Version cache names cleanly, purge obsolete caches in `activate`, use network-first (or stale-while-revalidate + update toast) for navigation HTML so deployments **never trap users on a permanently cached broken shell**, and confirm subpath asset URLs work when hosted under `/repo-name/`.
- [ ] **Security & Bundle Hygiene**:
  - Audit `NEXT_PUBLIC_*` / `VITE_*` variables to confirm **zero** server secrets, DB URLs, or private API tokens enter client bundles.
  - Sanitize any untrusted HTML before rendering, set `rel="noopener noreferrer"` on external `target="_blank"` links (or verify modern defaults), and configure security headers (`Content-Security-Policy`, `X-Content-Type-Options: nosniff`, `Referrer-Policy: strict-origin-when-cross-origin`, `Permissions-Policy`).
  - Run production build + typecheck + lint (`npm run build` / `pnpm build`) and verify zero broken asset paths or console errors before shipping.
