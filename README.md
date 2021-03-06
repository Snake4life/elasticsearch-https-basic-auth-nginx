This solution replaces native authentication and encrypted traffic, which is circulated via the GOLD subscription https://www.elastic.co/subscriptions

This Simple docker image to run an Elasticsearch server with Basic authentication and encryption via https

Usage
-----

To create the image `{{u_project}}/elasticsearch:{{tag}}`, execute the following command on tutum-docker-influxdb folder:

    docker build -t {{u_project}}/elasticsearch:{{tag}} .

You can also pull the image from the registry:

    docker pull {{u_project}}/elasticsearch:{{tag}}


Running elasticsearch
--------------------------------

Start your image binding the external ports `9200` to your container:

    docker run -d -p 9200:9200 {{u_project}}/elasticsearch:{{tag}}

Now you can connect to Elasticsearch by:

    curl 127.0.0.1:9200

Running elasticsearch with HTTP basic authentication
----------------------------------------------------

Use environment variables `ELASTICSEARCH_USER` and `ELASTICSEARCH_PASS` to specify the username and password and activated HTTP basic authentication (HTTP basic auth is disabled by default):

    docker run -d -p 9200:9200 -e ELASTICSEARCH_USER=user -e ELASTICSEARCH_PASS=mypass {{u_project}}/elasticsearch

Now you can connect to Elasticsearch by:

    curl user:mypass@127.0.0.1:9200
