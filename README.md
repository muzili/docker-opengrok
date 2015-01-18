# docker-opengrok

## Usage

To start the OpenGrok, simply run:

```sh
docker run -d -v [source to be indexed on host]:/source -v [grok data]:/grok -p [public port]:80 -p [public port]:443 muzili/opengrok
```

It may take a while for the indexer to finish the first-time indexing, after
that, the search engine is available at `http://host/`.

