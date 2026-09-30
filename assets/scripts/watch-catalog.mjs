import { watch } from "node:fs";
import { spawn } from "node:child_process";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const scriptsDir = dirname(fileURLToPath(import.meta.url));
const assetsDir = join(scriptsDir, "..");
const catalogPaths = [join(assetsDir, "src/catalog.js"), join(assetsDir, "src/color-families.js")];
const exportScript = join(scriptsDir, "export-catalog.mjs");

let timer = null;
let running = false;
let queued = false;

const exportCatalog = () => {
  if (running) {
    queued = true;
    return;
  }

  running = true;
  const child = spawn(process.execPath, [exportScript], {
    cwd: assetsDir,
    stdio: "inherit"
  });

  child.on("exit", () => {
    running = false;
    if (queued) {
      queued = false;
      exportCatalog();
    }
  });
};

exportCatalog();
for (const catalogPath of catalogPaths) {
  watch(catalogPath, { persistent: true }, () => {
    clearTimeout(timer);
    timer = setTimeout(exportCatalog, 120);
  });
}

console.log(`Watching ${catalogPaths.join(", ")}`);
