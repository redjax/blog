---
title: "Blog Setup"
date: 2026-01-24T23:27:35-05:00
draft: true
categories: []
tags: []
author: "me"
description: "The experience so far."
showToc: true
TocOpen: false
hidemeta: false
comments: false
searchHidden: false
---

Starting a blog has been an interest of mine for a long time. I have always envied people who began writing their tech blogs decades ago and still post to them today. I have written articles on Medium and other platforms over the years, but have never centralized them or made them "portable" in a meaningful way.

I decided to finally start my blog, becaause each year that passes where I haven't joined the ranks of nerd bloggers is another year I can't look back on in this format. I decided to go with [Hugo](https://hugo.io), a static site generator that renders Markdown files into static HTML, Javascript, and CSS, allowing it to be hosted essentially anywhere. I chose Hugo primarily for its speed, I can run a development version of the server with hot reloading, and see changes as I edit them nearly instantaneously.

A new project is a great way to try new things. In the spirit of novelty in starting this blog, I decided to use some new tools, like:

- [Mise](https://mise.jdx.dev) to handle installation of the tools needed to build and run the blog
- [Taskfile](https://taskfile.dev) for automations that can be run anywhere
- [Vale](https://vale.sh) for checking my post's readability
- [Lychee](https://lychee.cli.rs) for checking the site for dead/broken links

What better way to kick off a new blog than with a post about creating the blog (very original, right?)

## Choices Made

### CI/CD

I spent time planning the structure of [the git repository for the blog](https://github.com/redjax/blog) to make it portable. I have seen a number of blogs switch platforms over the years, and the posts they write at the end of a migration have inspired some of the choices made for this blog. For example, while this project is hosted on Github and I am using Github Actions to do things like lint the content and publish new pages, I also recreated the functionality in [Concourse CI pipelines](https://concourse-ci.org) so I am not tied to a specific git platform. I could move the blog's repository to any other remote, like [Gitlab](https://gitlab.com) or [Codeberg](https://codeberg.org) without breaking my CI/CD. At some point I will probably try writing the pipelines in [Dagger](https://dagger.io) to make them truly portable.

### Hosting

As of 01/24/2026, this blog is hosted on [Netlify](https://netlify.com), a platform I have been looking for a reason to try. I disabled Netlify's automated rebuilds on merges to main so I could [write a deployment pipeline of my own](https://github.com/redjax/blog/blob/main/.github/workflows/hugo-deploy.yml), mainly for the experience, but also to ensure I don't break the site when I'm trying new things. I hit Netlify's free tier limit in 2 days because of all the pipeline failures...I mean "tests" that I ran...but the team was generous enough to refresh my credits when I reached out for support. +1 to Netlify!

Because the site is just static HTML/JS/CSS, I leave the option open to move the site's hosting to basically anywhere. I build a [production Docker image](https://github.com/redjax/blog/tree/main/.containers/prod), so I could deploy a container somewhere and route the `techobyte.cc` domain to it, or simply copy the static files to any host that can serve files via a web server. This ensures I won't get "stuck" with a specific host, or with a specific deployment method. I have heard of many bloggers who run their blogs off a Raspberry Pi they have in their house, and there's really nothing stopping me from doing the same!

### Tools

I am using [Mise](https://mise.jdx.dev) to handle installing all of the tools I need to develop/build the blog. The [`.mise.toml` file in the repository](https://github.com/redjax/blog/blob/main/.mise.toml) defines these tools, so I can simply clone the repository, install Mise, and run `mise trust && mise install` on a new machine to get up and running. Mise is also useful in container environments and CI/CD pipelines, it can ensure I'm installing the same tools in every environment, with version pinning for ones I want to control upgrades for like the `hugo` CLI.

[Taskfile](https://taskfile.dev) is a new tool I found that lets you write YAML files to define tasks that can be called with the `task` CLI. It's a very versatile tool, and because it uses an embedded shell, it's (pretty much) fully cross platform. This is very useful, because it means the same tasks can run on Windows, Mac, or Linux, in CI/CD pipelines, Dockerfiles, etc. I use it for simplifying some commands I run frequently, like [Docker commands](https://github.com/redjax/blog/blob/main/.tasks/dockertasks.yml) or [Hugo commands](https://github.com/redjax/blog/blob/main/.tasks/hugotasks.yml).

[Vale](https://vale.sh) is a utility that lets you define a style guide and lint text content against it. You can use predefined styles, like Microsoft or Google's, and can mix and match. When Vale runs, it will surface writing and readability issues from the chosen style guides.

[Lychee](https://lychee.cli.rs) is a fast, easy to use link checker. I found it while setting up this blog, tried it once, and immediately added it to the stack. Lychee can scan live sites/URLs, but can also be pointed at the raw Markdown files that comprise this blog, or the rendered HTML. This allows me to catch broken links on the site before deploying, or to detect [linkrot](https://en.wikipedia.org/wiki/Link_rot).

## Challenges

I also faced some difficulties getting started with the blog. I spent way too much time creating the Github Action that deploys my content to Netlify. I failed so many times before getting it right, I exceeded Netlify's free tier 🤡. Most of the difficulty actually came from the "extra" functionality with Lychee link checking and Vale linting. Although I was able to get both of these tools running well locally on my machine, I ran into challenges getting them to run in the pipeline.

Linting with Vale was very difficult to nail down. I was able to get it to work reliabily in the local repository, but struggled with containerizing it and running in a pipeline. I also had invalid syntax in my Lychee link scanning for a while. I resolved both issues, but definitely got caught up in the weeds and did not write any new blog posts in the meantime.
