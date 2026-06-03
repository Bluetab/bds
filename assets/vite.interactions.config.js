import { defineConfig } from 'vite';
import { resolve } from 'node:path';

/** Standalone interactions bundle (no shared chunks with bds.js). */
export default defineConfig({
  build: {
    outDir: 'dist',
    emptyOutDir: false,
    lib: {
      entry: resolve(__dirname, 'src/lib/interactions.js'),
      formats: ['es'],
      fileName: 'interactions'
    }
  }
});
