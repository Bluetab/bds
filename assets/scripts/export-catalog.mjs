import { writeFileSync, mkdirSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";
import { COMPONENTS, GROUP_ORDER, snippets } from "../src/catalog.js";

const __dirname = dirname(fileURLToPath(import.meta.url));
const outPath = join(__dirname, "../../priv/catalog.json");

const payload = {
  group_order: GROUP_ORDER,
  tokens_snippet: snippets.tokens,
  components: COMPONENTS.map((component) => ({
    id: component.id,
    group: component.group,
    icon: component.icon,
    title: component.title,
    description: component.description,
    intro: component.intro ?? false,
    examples: component.examples.map((example) => ({
      title: example.title,
      block: example.block ?? false,
      note: example.note ?? null,
      html: example.html
    }))
  }))
};

mkdirSync(dirname(outPath), { recursive: true });
writeFileSync(outPath, JSON.stringify(payload, null, 2));
console.log(`Wrote ${outPath} (${payload.components.length} components)`);
