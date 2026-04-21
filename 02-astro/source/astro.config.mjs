import { defineConfig } from 'astro/config';

// Static bundle: `npm run build` produces dist/ which can be zipped and
// dropped onto any static host (Netlify, Cloudflare Pages, S3, nginx).
export default defineConfig({
  output: 'static',
  site: 'https://alsaifgallery.com',
  trailingSlash: 'ignore',
  build: {
    assets: '_assets',
    inlineStylesheets: 'auto',
  },
  compressHTML: true,
});
