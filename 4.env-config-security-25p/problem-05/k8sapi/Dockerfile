FROM alpine
RUN apk update && apk add curl 
COPY . .
RUN chmod +x script.sh
RUN ls
CMD ["sh","-c","/script.sh"]