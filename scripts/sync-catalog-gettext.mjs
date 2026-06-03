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
  English: "Inglés",
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
