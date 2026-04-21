/** @type {import('next').NextConfig} */
const nextConfig = {
  // Static export — `npm run build` produces `out/` which can be zipped and
  // deployed to any static host (no Node runtime required).
  output: 'export',
  trailingSlash: true,
  images: { unoptimized: true },
  reactStrictMode: true,
};

export default nextConfig;
