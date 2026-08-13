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

## What is Renovate?

Renovate is a tool that automates dependency bumping. It supports an array of [Git platforms](https://docs.renovatebot.com/modules/platform/) and [package managers](https://docs.renovatebot.com/modules/manager/), and can read comments in your source code to check a version against [a different data source](https://docs.renovatebot.com/modules/datasource/), like a [Github release](https://docs.renovatebot.com/modules/datasource/github-releases/) or [a Docker registry](https://docs.renovatebot.com/modules/datasource/docker/). If you have used [Github's Dependabot](https://docs.github.com/en/code-security/tutorials/secure-your-dependencies/dependabot-quickstart), they serve similar purposes.

The [Renovate docs](https://github.com/redjax/PipelineTemplates/tree/main/docs/ci-cd/github-actions/workflows/renovate) do a pretty good job of explaining how and why you might use Renovate. It's a flexible tool with [many use cases](https://docs.renovatebot.com/getting-started/use-cases/) and [sensible, useful defaults](https://docs.renovatebot.com/presets-default/), and you can even create [custom managers](https://docs.renovatebot.com/presets-customManagers/) using regex to bump versions the tool doesn't find automatically. It can open an issue in your issue tracker to serve as a "dashboard," with the tool updating it after every run, and you can configure automations like "merge all patch and minor versions automatically, but don't merge major version bumps automatically."

## Adopting Renovate


