FROM node:14-alpine

# Create app directory
WORKDIR /usr/src/app

RUN curl -fsSLO https://get.docker.com/builds/Linux/x86_64/docker-17.04.0-ce.tgz \
  && tar xzvf docker-17.04.0-ce.tgz \
  && mv docker/docker /usr/local/bin \
  && rm -r docker docker-17.04.0-ce.tgz

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./
RUN apk update
RUN apk add tzdata
RUN apk --no-cache add curl

ENV TZ=Asia/Singapore
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN date

RUN npm ci --only=production

COPY . .

EXPOSE 80

# HEALTHCHECK CMD curl --fail http://localhost:80/api/healthcheck || exit 1

CMD [ "node","dashboard.js" ]