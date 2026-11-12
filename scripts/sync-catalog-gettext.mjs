import { readFileSync, writeFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const __dirname = dirname(fileURLToPath(import.meta.url));
const catalogPath = join(__dirname, "../priv/catalog.json");
const esPoPath = join(__dirname, "../priv/gettext/es/LC_MESSAGES/default.po");

const catalog = JSON.parse(readFileSync(catalogPath, "utf8"));

const es = {
  Home: "Inicio",
  Foundations: "Fundamentos",
  Layout: "Layout",
  Components: "Componentes",
  Forms: "Formularios",
  Feedback: "Feedback",
  "Get started": "Comenzar",
  Buttons: "Botones",
  Cards: "Tarjetas",
  "Toggle theme": "Cambiar tema",
  "Change language": "Cambiar idioma",
  Spanish: "Español",
  "Google Material Symbols Rounded icon font. Write the ligature name (snake_case, from fonts.google.com/icons) as the text of a .bt-icon span, or .bt-symbol for inline text; add --filled for the filled variant.":
    "Fuente de iconos Google Material Symbols Rounded. Escribe el nombre de la ligadura (snake_case, de fonts.google.com/icons) como texto de un span .bt-icon, o .bt-symbol para texto en línea; añade --filled para la variante rellena.",
  "Material Symbols": "Material Symbols",
  "Filled variant": "Variante rellena",
  English: "Inglés",
  "Base palette editable from CSS tokens. Each color family has 9 steps: level 50 is the Bluetab master, 10–40 mix it with white (80, 60, 40 and 20 %) and 60–90 mix it with black (20, 40, 60 and 80 %).":
    "Paleta base editable desde tokens CSS. Cada familia de color tiene 9 niveles: el 50 es el color master de Bluetab, del 10 al 40 lo mezclan con blanco (80, 60, 40 y 20 %) y del 60 al 90 lo mezclan con negro (20, 40, 60 y 80 %).",
};

function collectMsgids(payload) {
  const ids = new Set();
  for (const g of payload.group_order || []) ids.add(g);
  for (const c of payload.components || []) {
    ids.add(c.group);
    ids.add(c.title);
    if (c.description) ids.add(c.description);
    for (const ex of c.examples || []) {
      if (ex.title) ids.add(ex.title);
    }
  }
  return [...ids].filter(Boolean).sort();
}

const msgids = collectMsgids(catalog);
let po = readFileSync(esPoPath, "utf8");
const existing = new Set([...po.matchAll(/^msgid "(.*)"/gm)].map((m) => m[1]));

const blocks = [];
for (const msgid of msgids) {
  if (existing.has(msgid)) continue;
  const msgstr = es[msgid] || msgid;
  blocks.push(
    "",
    `msgid "${msgid.replace(/\\/g, "\\\\").replace(/"/g, '\\"')}"`,
    `msgstr "${msgstr.replace(/\\/g, "\\\\").replace(/"/g, '\\"')}"`,
  );
}

if (blocks.length) {
  writeFileSync(esPoPath, po.trimEnd() + blocks.join("\n") + "\n");
  console.log(`Added ${blocks.length / 3} catalog msgids to ${esPoPath}`);
} else {
  console.log("No new catalog msgids to add");
}
