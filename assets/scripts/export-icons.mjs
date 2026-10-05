// Writes every Material Symbols ligature name to priv/material_symbols.json so
// Phoenix apps (e.g. the Storybook icon picker) can list the full library.
// The names come from the same package as the self-hosted font in src/fonts.
import { readFileSync, writeFileSync, mkdirSync } from "node:fs";
import { createRequire } from "node:module";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const __dirname = dirname(fileURLToPath(import.meta.url));
const require = createRequire(import.meta.url);
const typingsPath = join(dirname(require.resolve("@material-symbols/font-400/package.json")), "index.d.ts");
const outPath = join(__dirname, "../../priv/material_symbols.json");

const names = [...readFileSync(typingsPath, "utf8").matchAll(/"([a-z0-9_]+)"/g)].map((match) => match[1]);
const unique = [...new Set(names)].sort();

mkdirSync(dirname(outPath), { recursive: true });
writeFileSync(outPath, `${JSON.stringify(unique)}\n`);
console.log(`Wrote ${outPath} (${unique.length} icons)`);
