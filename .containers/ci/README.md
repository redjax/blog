# CI Container

Multi-stage Dockerfile that builds the site, lints posts with Vale, and checks links with Lychee. You can target individual stages, i.e. to only check links, with `--target <stage-name>`.

## Commands

*Run these commands from the `.containers/ci` directory*

Lint content with Vale

```shell
docker build --progress=plain --target vale -f Dockerfile ../..
```

Check links with Lychee

```shell
docker build --progress=plain --build-arg HUGO_BASEURL=https://techobyte.cc --target lychee -f Dockerfile ../..
```

Build the site

```shell
docker build --progress=plain --build-arg HUGO_BASEURL=https://techobyte.cc --target build -f Dockerfile ../..
```

Build site & output to host mount, i.e. `./site/public`:

```shell
DOCKER_BUILDKIT=1 docker build --build-arg HUGO_BASEURL=https://techobyte.cc --target output -o type=local,dest=./site/public -f Dockerfile ../..
```
