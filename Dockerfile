FROM node:carbon-alpine

# install nginx, git

RUN apk add --no-cache nginx git

EXPOSE 80
EXPOSE 443

ADD ./nginx/nginx.conf /etc/nginx/nginx.conf
ADD ./nginx/snippets /etc/nginx/snippets
ADD ./nginx/sites-enabled /etc/nginx/sites-enabled

RUN rm /etc/nginx/conf.d/default.conf

# pull, install and build the api

RUN mkdir -p /home/node/app

RUN git clone https://github.com/freecodecamp/freecodecamp.git /home/node/app

WORKDIR /home/node/app/

RUN git checkout production

RUN npm install

RUN npm run build

COPY pm2.json .

RUN npm i -g pm2

CMD [ "pm2", "start", "pm2.json", "--no-daemon" ]