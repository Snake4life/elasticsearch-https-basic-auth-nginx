FROM ubuntu:trusty

RUN apt-get update && apt-get install -y curl && apt-get clean && rm -rf /var/lib/apt/lists

RUN curl http://packages.elasticsearch.org/GPG-KEY-elasticsearch | apt-key add - && \
    echo 'deb http://packages.elasticsearch.org/elasticsearch/1.3/debian stable main' >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y elasticsearch openjdk-7-jre-headless && \
    apt-get install -y nginx supervisor apache2-utils openssl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV ELASTICSEARCH_USER None
ENV ELASTICSEARCH_PASS None

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD nginx_default /etc/nginx/sites-enabled/default
ADD ssl.conf /etc/nginx/conf.d/ssl.conf
ADD run.sh /run.sh

RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN chmod a+x /*.sh

EXPOSE 9200
ENTRYPOINT ["/run.sh"]
