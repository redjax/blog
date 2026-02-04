---
title: "Tools"
slug: "/blog-setup/tools"
date: 2026-02-03T00:00:02-05:00
draft: true
series: ["blog-setup"]
categories: []
tags: ["post", "setup", "hugo"]
author: "me"
description: ""
summary: ""
showToc: true
TocOpen: false
hidemeta: false
comments: false
searchHidden: false
---

## Tools

I am using [Mise](https://mise.jdx.dev) to handle installing all of the tools I need to develop/build the blog. The [`.mise.toml` file in the repository](https://github.com/redjax/blog/blob/main/.mise.toml) defines these tools, so I can simply clone the repository, install Mise, and run `mise trust && mise install` on a new machine to get up and running. Mise is also useful in container environments and CI/CD pipelines, it can ensure I'm installing the same tools in every environment, with version pinning for ones I want to control upgrades for like the `hugo` CLI.

[Taskfile](https://taskfile.dev) is a new tool I found that lets you write YAML files to define tasks that can be called with the `task` CLI. It's a very versatile tool, and because it uses an embedded shell, it's (pretty much) fully cross platform. This is very useful, because it means the same tasks can run on Windows, Mac, or Linux, in CI/CD pipelines, Dockerfiles, etc. I use it for simplifying some commands I run frequently, like [Docker commands](https://github.com/redjax/blog/blob/main/.tasks/dockertasks.yml) or [Hugo commands](https://github.com/redjax/blog/blob/main/.tasks/hugotasks.yml).

[Vale](https://vale.sh) is a utility that lets you define a style guide and lint text content against it. You can use predefined styles, like Microsoft or Google's, and can mix and match. When Vale runs, it will surface writing and readability issues from the chosen style guides.

[Lychee](https://lychee.cli.rs) is a fast, easy to use link checker. I found it while setting up this blog, tried it once, and immediately added it to the stack. Lychee can scan live sites/URLs, but can also be pointed at the raw Markdown files that comprise this blog, or the rendered HTML. This allows me to catch broken links on the site before deploying, or to detect [linkrot](https://en.wikipedia.org/wiki/Link_rot).
