# Tahap 1: Build aplication
# Menggunakan base image Node.js versi 20-slim untuk build
FROM node:20-slim AS build

# Menetapkan direktori kerja di dalam container
WORKDIR /app

# Salin file package.json dan package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Salin semua file proyek ke dalam container
COPY . .

# Build aplikasi Astro untuk produksi
RUN npm run build

# ---

# Tahap 2: Serve aplication with Nginx
# Menggunakan base image Nginx yang ringan
FROM nginx:stable-alpine AS production

# Salin hasil build dari tahap sebelumnya ke direktori serve Nginx
COPY --from=build /app/dist /usr/share/nginx/html

# Salin file konfigurasi Nginx (opsional, tapi direkomendasikan)
# COPY nginx.conf /etc/nginx/conf.d/default.conf

# Memberi tahu container untuk membuka port 80
EXPOSE 80

# Perintah untuk menjalankan Nginx saat container dimulai
CMD ["nginx", "-g", "daemon off;"]