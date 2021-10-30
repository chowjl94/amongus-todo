FROM node:14-alpine


# create/define a directory

WORKDIR /user/among_us/app


# copy copy packages
COPY package*.json ./

# installl packages
RUN npm install


COPY . .

ENV PORT=3000

EXPOSE 3000

CMD ["npm", "run","start"]
