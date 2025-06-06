FROM node:18
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
ENV NODE_ENV=production
EXPOSE 9000
CMD ["npm", "run", "start"]
