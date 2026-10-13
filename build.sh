#!/bin/sh
# Genera index.html a partir de los markdown. Requiere pandoc.
set -e
cd "$(dirname "$0")"

section() {
  id="$1"; file="$2"
  printf '<section id="%s">\n' "$id"
  pandoc "$file" -f gfm -t html
  printf '</section>\n'
}

{
cat <<'HEAD'
<!doctype html>
<html lang="es">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Rutina</title>
<style>
  :root { --ink: #1d1d1b; --muted: #6b6b66; --line: #e4e2dc; --paper: #fbfaf7; --accent: #b4532a; }
  * { box-sizing: border-box; }
  html { font-size: 16px; }
  body { margin: 0; background: var(--paper); color: var(--ink); font-family: -apple-system, "Helvetica Neue", Helvetica, Arial, sans-serif; line-height: 1.5; }
  nav { position: sticky; top: 0; background: var(--paper); border-bottom: 1px solid var(--line); padding: 0 1.5rem; display: flex; gap: 1.5rem; overflow-x: auto; z-index: 1; }
  nav a { padding: 0.9rem 0; color: var(--muted); text-decoration: none; font-size: 0.9rem; letter-spacing: 0.02em; text-transform: uppercase; white-space: nowrap; border-bottom: 2px solid transparent; }
  nav a:hover, nav a.active { color: var(--ink); border-color: var(--accent); }
  main { max-width: 64rem; margin: 0 auto; padding: 2rem 1.5rem 6rem; }
  section { padding: 2.5rem 0; border-bottom: 1px solid var(--line); }
  section:last-child { border-bottom: 0; }
  h1 { font-size: 2rem; margin: 0 0 1rem; letter-spacing: -0.02em; }
  h2 { font-size: 1.25rem; margin: 2.25rem 0 0.75rem; letter-spacing: -0.01em; }
  h3 { font-size: 1rem; margin: 1.5rem 0 0.5rem; color: var(--muted); text-transform: uppercase; letter-spacing: 0.04em; }
  p, li { max-width: 46rem; }
  table { border-collapse: collapse; width: 100%; font-size: 0.92rem; margin: 0.75rem 0 1.25rem; }
  th, td { text-align: left; vertical-align: top; padding: 0.45rem 0.6rem; border-bottom: 1px solid var(--line); }
  th { font-weight: 600; color: var(--muted); font-size: 0.8rem; text-transform: uppercase; letter-spacing: 0.04em; }
  td:first-child { white-space: nowrap; }
  strong { font-weight: 650; }
  code, pre { font-family: ui-monospace, "SF Mono", Menlo, monospace; font-size: 0.88rem; }
  pre { background: #f1efe9; padding: 0.9rem 1rem; border-radius: 6px; overflow-x: auto; }
  code { background: #f1efe9; padding: 0.1rem 0.3rem; border-radius: 3px; }
  pre code { background: none; padding: 0; }
  /* Grilla semanal: scroll horizontal y celdas compactas */
  #semana table:first-of-type { font-size: 0.8rem; display: block; overflow-x: auto; }
  #semana table:first-of-type th, #semana table:first-of-type td { min-width: 7.5rem; padding: 0.4rem 0.5rem; }
  #semana table:first-of-type td:first-child { min-width: 3.5rem; color: var(--muted); }
  @media print {
    nav { display: none; }
    body { background: #fff; }
    main { max-width: none; padding: 0; }
    section { page-break-before: always; border: 0; padding: 0; }
    section:first-child { page-break-before: auto; }
    a { color: inherit; text-decoration: none; }
  }
</style>
</head>
<body>
<nav>
  <a href="#semana">Semana</a>
  <a href="#gym">Gimnasio</a>
  <a href="#nutricion">Nutrición</a>
  <a href="#cuerpo">Cuerpo</a>
</nav>
<main>
HEAD
section semana semana.md
section gym gym.md
section nutricion nutricion.md
section cuerpo cuerpo.md
cat <<'TAIL'
</main>
<script>
  const links = [...document.querySelectorAll('nav a')];
  const sections = links.map(a => document.querySelector(a.getAttribute('href')));
  const io = new IntersectionObserver(entries => {
    entries.forEach(e => {
      if (!e.isIntersecting) return;
      links.forEach(a => a.classList.toggle('active', a.getAttribute('href') === '#' + e.target.id));
    });
  }, { rootMargin: '-40% 0px -55% 0px' });
  sections.forEach(s => io.observe(s));
</script>
</body>
</html>
TAIL
} > index.html
echo "index.html generado"
