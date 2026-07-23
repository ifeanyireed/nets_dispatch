/** @type {import('next').NextConfig} */
const nextConfig = {
  images: {
    remotePatterns: [
      {
        protocol: 'https',
        hostname: 'cdn.antifake.ng',
        port: '',
        pathname: '/**',
      },
    ],
  },
};

export default nextConfig;
