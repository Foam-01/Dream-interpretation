# Production image for the DreamApp API. No secrets are baked in:
# DATABASE_URL (and optional CORS_ORIGINS) are provided at runtime.
# Pinned to the Node version the project is developed and tested with.
FROM node:24.11.1-alpine AS build
WORKDIR /app
COPY package.json package-lock.json ./
COPY prisma ./prisma
COPY prisma.config.ts ./
RUN npm ci
COPY tsconfig.json tsconfig.build.json nest-cli.json ./
COPY src ./src
RUN npm run build && npm prune --omit=dev --ignore-scripts

FROM node:24.11.1-alpine
WORKDIR /app
ENV NODE_ENV=production
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/dist ./dist
COPY --from=build /app/package.json ./
USER node
EXPOSE 3000
# Liveness only (no database). PORT may be set by the platform (e.g. 8080), so the check follows it.
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s CMD wget -qO- "http://127.0.0.1:${PORT:-3000}/api/v1/health" || exit 1
CMD ["node", "dist/src/main.js"]
