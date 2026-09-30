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
  "Base palette editable from CSS tokens. Each color family has 10 steps: level 60 is the Bluetab master, 10–50 are tints toward white and 70–100 are shades toward black.":
    "Paleta base editable desde tokens CSS. Cada familia de color tiene 10 niveles: el 60 es el color master de Bluetab, del 10 al 50 son tintes hacia blanco y del 70 al 100 son sombras hacia negro.",
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
