FROM node:18-alpine3.21 AS builder

RUN apk update && apk upgrade libxml2

WORKDIR /app

COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

COPY . .
RUN yarn build


FROM nginx:stable-alpine3.21

RUN apk update && apk upgrade libxml2
RUN rm /etc/nginx/conf.d/default.conf

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=builder /app/build /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
