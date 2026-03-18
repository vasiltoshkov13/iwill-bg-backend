FROM node:20-alpine
WORKDIR /app

# Install all deps (including dev for ts-node config loading)
COPY package.json yarn.lock* package-lock.json* ./
RUN npm install --legacy-peer-deps

COPY . .

# Install deps for the pre-built compiled server
RUN cd /app/.medusa/server && npm install --legacy-peer-deps --production

EXPOSE 9000
# Copy compiled config where CLI expects it, run migrate, then start pre-built server
CMD ["sh", "-c", "cp /app/.medusa/server/medusa-config.js /app/medusa-config.js && npx medusa db:migrate && npx medusa start"]
