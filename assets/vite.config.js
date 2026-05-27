import { defineConfig } from "vite"

// Component catalog (index.html + src/main.js). Library build uses vite.lib.config.js.
export default defineConfig({
  root: import.meta.dirname,
  server: {
    host: true,
    port: 5173,
    watch: {
      ignored: ["**/node_modules/**", "**/dist/**", "**/dist-docs/**"]
    }
  }
})
