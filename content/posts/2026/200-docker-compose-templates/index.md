---
title: "200 Docker Compose Templates"
date: 2026-07-26T21:18:37-04:00
draft: true
slug: "/200-docker-compose-templates/"
# url: "/posts/200-docker-compose-templates/"
categories: []
tags:
  - docker
  - git
author: "me"
description: ""
showToc: false
TocOpen: false
hidemeta: false
comments: false
searchHidden: false
---

I have been maintaining a git monorepo named [`docker_templates`](https://github.com/redjax/docker_templates) since sometime in 2023, and I recently added my 200th template [(commit `7c112b7`)](https://github.com/redjax/docker_templates/tree/7c112b7222d81330c0310ec851c7b512f48347e6)! I thought back to when I started learning Docker and Docker Compose sometime in 2015, and how transformative containers are in how I use my machines. There is something very satisfying about describing a runtime you want to work with and encapsulating everything you need to run an app or service the same way each time you run it, on any machine. There are some edge cases in reality, but it's a beautiful dream.

The structure of the `docker_templates` repository continues to evolve, but it's also come a long way from how it started out.

## The Beginning: Disparate Directories with Docker Compose files

I learned to write Dockerfiles to containerize my Python programs, and quickly picked up Docker Compose so I could run things like a Postgres database or Redis message queue (for Python's Celery scheduling library). Eventually I started to find programs and apps I wanted to host myself, like a media server, document hosting, monitoring/alerting services, etc.

For years, whenever I wanted to try a new service, I would create a directory for it, write a `docker-compose.yml` file, and run it. I was hardcoding non-secret values in my Compose files for a long time (using a `.env` or environment variables to pass secrets to the template). Sometimes I would initialize a git repository and push the stack to Github, other times the directory would just sit on one of my machines wherever I originally put it. The mental overhead of deciding if the new service I wanted to try was worthy of initializing as a git repository, making sure my `.gitignore` would keep my `.env` file out of git history and ignore host volume mounts, and deciding where to put the code on my machine started to slow me down and made me hesitant to really invest time into the templates I was creating. I started to end up with a lot of different repositories and realized this was not sustainable long-term.
