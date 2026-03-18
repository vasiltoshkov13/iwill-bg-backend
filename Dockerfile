FROM node:20-alpine
WORKDIR /app

# Install all deps (including dev for ts-node config loading)
COPY package.json yarn.lock* package-lock.json* ./
RUN npm install --legacy-peer-deps

COPY . .

# Install deps for the pre-built compiled server
RUN cd /app/.medusa/server && npm install --legacy-peer-deps --production

# Copy admin to where medusa start expects it (rootDir/public/admin)
RUN mkdir -p /app/public && cp -r /app/.medusa/server/public/admin /app/public/admin

EXPOSE 9000
CMD ["sh", "-c", "cp /app/.medusa/server/medusa-config.js /app/medusa-config.js && npx medusa db:migrate && npx medusa start"]
