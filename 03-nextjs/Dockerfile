FROM node:20-alpine AS builder

WORKDIR /app
COPY source/package*.json ./
RUN npm ci
COPY source/ .
RUN npm run build

FROM nginx:alpine
COPY --from=builder /app/out /usr/share/nginx/html
EXPOSE 80
