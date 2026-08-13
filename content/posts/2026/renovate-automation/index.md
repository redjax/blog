---
title: "Renovate Automation"
date: 2026-08-13T11:57:46-04:00
draft: true
slug: "/renovate-automation/"
# url: "/posts/renovate-automation/"
categories: []
tags:
  - ci-cd
  - renovate
  - github
  - gitlab
  - forgejo
author: "me"
description: ""
showToc: false
TocOpen: false
hidemeta: false
comments: false
searchHidden: false
---

![Mend Renovate logo](/mend-renovate-logo.png#center)

Every now and then I test drive a new tool and find it so immediately useful, it becomes a core part of my toolkit almost overnight. I have experienced this with [Astral's `uv` for manging Python projects](https://docs.astral.sh/uv), [Atuin for shell history](https://atuin.sh/), [`chezmoi` for dotfiles management](https://www.chezmoi.io/), and so on. When I set out a few weeks ago to test drive [Renovate](https://github.com/renovatebot/renovate), I was only intending to dip my toes in with a repository or 2, see if I found it useful, and consider adding it to the repositories I spend the most time maintaining.

What happened instead is that I found the tool so immediately useful, and so simple to configure and bend to my needs, that overnight I found myself creating a centralized, re-usable version of the pipeline so I can easily add Renovate support to existing and new repositories. I even rewrote the bespoke Bash scripting I was using to automate bumping and rebuilding Docker images in [my Dockerfiles repository](https://github.com/redjax/Dockerfiles).
