FROM node:20-alpine
WORKDIR /app

COPY package.json yarn.lock* package-lock.json* ./
RUN npm install --legacy-peer-deps --omit=dev

COPY . .

EXPOSE 9000
CMD ["sh", "-c", "npx medusa db:migrate && npx medusa start"]
