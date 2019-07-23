#!/bin/bash

for i in {30..0}; do
    if curl es:9200; then
curl -XPUT 'es:9200/messages' -H 'Content-Type: application/json' -d $'{
    "settings":{
        "index" : {
            "number_of_shards" : 1 
        },
        "analysis": {
            "filter": {
                "english_stop": {
                "type":       "stop",
                "stopwords":  "_english_" 
                },
                "english_stemmer": {
                "type":       "stemmer",
                "language":   "english"
                },
                "english_possessive_stemmer": {
                "type":       "stemmer",
                "language":   "possessive_english"
                }
            },
            "analyzer": {
                "default":{
                    "tokenizer":  "standard",
                    "filter": [
                        "english_possessive_stemmer",
                        "lowercase",
                        "english_stop",
                        "english_stemmer"
                    ]
                },
                "r_english": {
                    "tokenizer":  "standard",
                    "filter": [
                        "english_possessive_stemmer",
                        "lowercase",
                        "english_stop",
                        "english_stemmer"
                    ]
                }
                ,
                "default_search":{
                    "tokenizer":  "standard",
                    "filter": [
                        "english_possessive_stemmer",
                        "lowercase",
                        "english_stop",
                        "english_stemmer"
                    ]
                }
            }
            }
        },
    "mappings": {
        "messages": {
            "properties": {
                
                "body": {
                    "type": "text",
                },
                "uuid": {
                        "type": "keyword"
                },
                 "chat_id   ": {
                        "type": "keyword"
                },
                "number": {
                    "type": "long"
                },
            }
        }
    }
  
}';


            break;
    fi
    sleep 2
done
