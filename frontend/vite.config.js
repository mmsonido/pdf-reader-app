import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  server: {
    port: 5173,
    proxy: {
      '^/(upload-url|status|text)': {
        target: 'http://127.0.0.1:8080', // force IPv4
        changeOrigin: true,
        secure: false,
      },
    },
  },
})