# Build Flutter web, serve static files with nginx (local / Traefik stack).
FROM ghcr.io/cirruslabs/flutter:stable AS build
WORKDIR /app

RUN flutter config --enable-web

COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

COPY . .

# URLs are used by the browser (host machine), not inside this image.
ARG AUTH_BASE_URL=http://127.0.0.1:8000
ARG OAUTH_CLIENT_ID=zhuchka-market-web
ARG CATALOG_BASE_URL=http://127.0.0.1:8001
ARG COMMERCE_BASE_URL=http://127.0.0.1:8002
ARG TELEGRAM_BOT_USERNAME=

RUN flutter build web --release \
  --dart-define=AUTH_BASE_URL=${AUTH_BASE_URL} \
  --dart-define=OAUTH_CLIENT_ID=${OAUTH_CLIENT_ID} \
  --dart-define=CATALOG_BASE_URL=${CATALOG_BASE_URL} \
  --dart-define=COMMERCE_BASE_URL=${COMMERCE_BASE_URL} \
  --dart-define=TELEGRAM_BOT_USERNAME=${TELEGRAM_BOT_USERNAME}

FROM nginx:1.27-alpine
COPY docker/nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/build/web /usr/share/nginx/html
EXPOSE 80
