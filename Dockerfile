# --------- BUILD  STAGE  ------------------

FROM node:20-alpine AS build

WORKDIR /app

COPY package*.json ./

# ci -> Clean Install the dependencies
RUN npm ci 
COPY . .
RUN npm run build


# ---------- STAGE 2 -------------

FROM nginx:alpine

WORKDIR /app

COPY --from=build /app/dist /usr/share/nginx/html

COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]


