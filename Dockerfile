FROM node:20-alpine
WORKDIR /app

COPY package.json yarn.lock* package-lock.json* ./
RUN npm install --legacy-peer-deps

COPY . .

EXPOSE 9000
# Build admin at startup so it has full container memory (avoids Railway build OOM)
CMD ["sh", "-c", "NODE_OPTIONS='--max-old-space-size=4096' npm run build && npx medusa db:migrate && npx medusa start"]
