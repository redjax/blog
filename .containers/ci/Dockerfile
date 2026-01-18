# syntax=docker/dockerfile:1

ARG HUGOMOD_IMG_TAG=debian-exts
ARG BASEURL=${HUGO_BASEURL:-https://example.org}

## Base layer
FROM hugomods/hugo:${HUGOMOD_IMG_TAG} AS src
WORKDIR /src

ENV HUGO_CACHEDIR=/tmp/hugo_cache
ENV HUGO_ENV=production

## Download Hugo/Go modules
RUN --mount=type=cache,target=/go/pkg/mod \
    --mount=type=cache,target=/tmp/hugo_cache \
    hugo mod get

## Site builder stage
FROM src AS build
ARG HUGO_BASEURL
ENV HUGO_BASEURL=${HUGO_BASEURL}

WORKDIR /src

COPY hugo.yml ./
COPY go.mod go.sum ./

## Copy site content
COPY archetypes ./archetypes
COPY assets ./assets
COPY content ./content
COPY layouts ./layouts
COPY static ./static

## Build container with Production config
RUN --mount=type=cache,target=/tmp/hugo_cache \
    hugo --minify --gc --cleanDestinationDir \
    --environment production

## Lychee links check  
FROM lycheeverse/lychee:latest AS lychee
WORKDIR /work

COPY --from=build /src/public ./public

RUN lychee $(find public -name "*.html") \
    --root-dir /work/public \
    --exclude 'https?://techobyte\.(cc|digital).*' \
    --exclude 'https?://github\.com' \
    --exclude 'mailto:' \
    --exclude-all-private \
    --max-retries 3 \
    --verbose

## Vale content lint
FROM jdkato/vale:latest AS vale
WORKDIR /work

COPY content ./content
COPY .vale.ini ./
COPY .styles ./.styles

RUN vale --config .vale.ini content/**/*.md

## Output stage for extracting built/checked contents
FROM scratch AS output
COPY --from=build /src/public /public