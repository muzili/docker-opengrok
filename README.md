# docker-opengrok

## Usage

To start the OpenGrok, simply run:

```sh
docker run -d -v [source to be indexed on host]:/source -p [public port]:8080 muzili/opengrok
```

It may take a while for the indexer to finish the first-time indexing, after
that, the search engine is available at `http://host:[public port]/source/`.

## Note

The project supports dynamic index updating through `inotifywait` recursively on the source folder. However, `touch` doesn't help. You should add or delete or modify the content of some source file to make it happen.
