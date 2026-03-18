FROM node:20-alpine AS builder
WORKDIR /app

# Install dependencies
COPY package.json yarn.lock* package-lock.json* ./
RUN npm install --legacy-peer-deps

# Copy source and build (give Vite enough heap for admin bundle)
COPY . .
RUN NODE_OPTIONS="--max-old-space-size=4096" npm run build

# Runtime image
FROM node:20-alpine
WORKDIR /app

COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/.medusa ./.medusa
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/medusa-config.ts ./medusa-config.ts
COPY --from=builder /app/src ./src

EXPOSE 9000
CMD ["sh", "-c", "npx medusa db:migrate && npx medusa start"]
