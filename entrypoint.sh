#!/bin/bash
set -e

# ELASTICSEARCH auth throught NGINX
if [ "$ELASTICSEARCH_USER" == "None" ] && [ "$ELASTICSEARCH_PASS" == "None" ]; then
    echo "=> Starting Elasticsearch with no base auth ..."
    echo "========================================================================"
    echo "You can now connect to this Elasticsearch Server using:"
    echo ""
    echo "    curl localhost:9200"
    echo ""
    echo "========================================================================"
    exec set -- gosu elasticsearch /usr/share/elasticsearch/bin/elasticsearch
else
    echo "=> Starting Elasticsearch with basic auth ..."
    echo $ELASTICSEARCH_PASS | htpasswd -i -c /htpasswd $ELASTICSEARCH_USER
    echo "========================================================================"
    echo "You can now connect to this Elasticsearch Server using:"
    echo ""
    echo "    curl $ELASTICSEARCH_USER:$ELASTICSEARCH_PASS@localhost:9200"
    echo ""
    echo "========================================================================"
    exec supervisord -n
fi

echo ">> exec docker CMD"
echo "$@"
exec "$@"
