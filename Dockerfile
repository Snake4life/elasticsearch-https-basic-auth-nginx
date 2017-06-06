FROM elasticsearch:latest

RUN apt-get update && apt-get install -y curl && apt-get clean && rm -rf /var/lib/apt/lists

RUN apt-get update && \
    apt-get install -y curl nginx supervisor apache2-utils openssl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV ELASTICSEARCH_USER user
ENV ELASTICSEARCH_PASS password

# RUN useradd -m -d /home/node -s /bin/bash my-user
# USER my-user

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD nginx_default.conf /etc/nginx/conf.d/nginx_default.conf
ADD nginx.conf /etc/nginx/nginx.conf
ADD ssl.conf /etc/nginx/conf.d/ssl.conf
ADD generate-tokens.sh /generate-tokens.sh
ADD dh.pem /etc/nginx/dh.pem
ADD entrypoint.sh /entrypoint.sh
ADD elasticsearch.yml /etc/elasticsearch/elasticsearch.yml

# RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN chmod a+x /*.sh
RUN /generate-tokens.sh

EXPOSE 9200

ENTRYPOINT ["/entrypoint.sh"]
