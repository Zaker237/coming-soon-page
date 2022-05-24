# build stage
FROM node:14-alpine as build-stage
WORKDIR /app
ENV CHOKIDAR_USEPOLLING=true
COPY . .
RUN npm install
RUN npm run build

# deploy stage
FROM nginx:stable-alpine as deploy-stage
RUN ls -la
COPY ./nginx/nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build-stage /app/dist /usr/share/nginx/html
ENV API_BASE_ENDPOINT https://testapi.winexam.help/

EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]