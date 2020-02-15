# development container
FROM node:12.14.1-alpine as development

WORKDIR /app
ENV HOME /app

COPY yarn.lock package.json /app/
RUN npm install 

COPY public/ /app/public/
COPY src/ /app/src/

EXPOSE 3000
CMD ["npm", "start"]

# temp build container
FROM development as build
ARG NODE_ENV=production
ARG GENERATE_SOURCEMAP=false
RUN npm run build

# production container
FROM nginx:1.17.8-alpine as production
LABEL maintainer="Rex Roof <rexroof@gmail.com>"

COPY --from=build /app/build /usr/share/nginx/html
