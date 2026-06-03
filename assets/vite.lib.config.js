import { defineConfig } from 'vite';
import { resolve } from 'node:path';

export default defineConfig({
  build: {
    outDir: 'dist',
    emptyOutDir: true,
    lib: {
      entry: resolve(__dirname, 'src/lib/index.js'),
      formats: ['es'],
      fileName: 'bds',
      cssFileName: 'bds'
    }
  }
});
