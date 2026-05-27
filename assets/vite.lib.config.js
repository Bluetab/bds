import { defineConfig } from 'vite';
import { resolve } from 'node:path';

export default defineConfig({
  build: {
    outDir: 'dist',
    emptyOutDir: true,
    lib: {
      entry: {
        index: resolve(__dirname, 'src/lib/index.js'),
        interactions: resolve(__dirname, 'src/lib/interactions.js')
      },
      formats: ['es'],
      fileName: (_format, entryName) => (entryName === 'index' ? 'bds.js' : 'interactions.js'),
      cssFileName: 'bds'
    }
  }
});
