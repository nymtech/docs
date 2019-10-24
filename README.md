# Nym Documentation

Documentation for the Nym privacy platform. Built docs eventually make their way to https://nymtech.net/docs.

## Contributing

Contributions to our documentation are very welcome! Please shoot us a pull request if you can see a way that they can be improved.

## Building

Requirements:

* Hugo (get it from https://gohugo.io/getting-started/installing/)

Clone the docs from Github and `cd docs`.

The docs are built using Hugo, a go-based static site generator. To build static HTML just do:

```
hugo
```

Alternately, to start a webserver, run:

```
hugo server -D
```

This will start up an HTTP server. View docs at http://localhost:1313/docs/.

Edit the markdown content in the `/content/` directory, and your changes will be automatically shown in your browser. Happy editing!
