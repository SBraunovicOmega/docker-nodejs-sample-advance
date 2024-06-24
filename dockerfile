FROM node:14-alpine AS development

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 3000

USER node

CMD ["npm", "run", "dev"]

FROM node:14-alpine AS production

WORKDIR /app

COPY package*.json ./

RUN npm install --only=production

COPY . .

EXPOSE 3000

USER node

CMD ["node", "src/index.js"]
