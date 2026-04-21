FROM ghcr.io/cirruslabs/flutter:3.24.5 AS builder

WORKDIR /app
COPY . .
RUN flutter pub get
RUN flutter build web --release --web-renderer html

FROM nginx:alpine
COPY --from=builder /app/build/web /usr/share/nginx/html
EXPOSE 80
