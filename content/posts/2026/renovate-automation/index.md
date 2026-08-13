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

What happened instead is that I found the tool so immediately useful, and so simple to configure and bend to my needs, that overnight I found myself creating a centralized, re-usable version of the pipeline so I can easily add Renovate support to existing and new repositories. I even rewrote the bespoke Bash scripting I was using to automate bumping and rebuilding Docker images in [my Dockerfiles repository](https://github.com/redjax/Dockerfiles) because Renovate made managing all of the different versions much simpler.

## What is Renovate?

Renovate is a tool that automates dependency bumping. It supports an array of [Git platforms](https://docs.renovatebot.com/modules/platform/) and [package managers](https://docs.renovatebot.com/modules/manager/), and can read comments in your source code to check a version against [a different data source](https://docs.renovatebot.com/modules/datasource/), like a [Github release](https://docs.renovatebot.com/modules/datasource/github-releases/) or [a Docker registry](https://docs.renovatebot.com/modules/datasource/docker/). If you have used [Github's Dependabot](https://docs.github.com/en/code-security/tutorials/secure-your-dependencies/dependabot-quickstart), they serve similar purposes.

The [Renovate docs](https://docs.renovatebot.com/) do a pretty good job of explaining how and why you might use Renovate. It's a flexible tool with [many use cases](https://docs.renovatebot.com/getting-started/use-cases/) and sensible, useful defaults, and you can even create [custom managers](https://docs.renovatebot.com/presets-customManagers/) using regex to bump versions the tool doesn't find automatically. It can open an issue in your issue tracker to serve as a "dashboard," with the tool updating it after every run, and you can configure automations like "merge all patch and minor versions automatically, but don't merge major version bumps automatically."

## Adopting Renovate

I have a Github repository named [PipelineTemplates](https://github.com/redjax/PipelineTemplates), where I centralize my CI/CD workflows into reusable components & workflows. I keep my pipelines for Github, Gitlab, Forgejo, Concourse, etc in this central repository to reduce my bad habit of copying, pasting, and slightly tweaking pipelines to do the same task. I wrote about the impetus for this repository and the adoption process in [my "Centralized CI/CD Pipelines" post](/posts/centralized-pipelines). My interest in Renovate originally started as an exercise to create a centralized, re-usable workflow to run Renovate across a couple of my Hugo site repositories, like [RedKB](https://github.com/redjax/redkb) and [this blog](https://github.com/redjax/blog).

I created the [Renovate pipeline file](https://github.com/redjax/PipelineTemplates/blob/main/.github/workflows/renovate.yml) in my central repository, and gave it inputs a consuming repository can use to configure Renovate runs. The POC pipeline came together very quickly, I was surprised by how quickly the pipeline came together, Renovate is relatively easy to setup and configure, especially considering how many different configurations it supports.

I also added a [default Renovate configuration](https://github.com/redjax/PipelineTemplates/blob/main/config/renovate/default.json) that consuming repositories can use, if they do not provide their own. This configuration is my personal preferences for a "standard" Renovate run; it extends the actual Renovate [default configurations](https://docs.renovatebot.com/presets-default/), and supports my mose used languages and managers.

My default configuration enables the [dashboard issue](https://docs.renovatebot.com/key-concepts/dashboard/), allows automated PR merges for minor and patch bumps, but requires approval for major bumps, and supports some custom regular expressions to monitor my Gitlab pipelines and Dockerfile images. This centralized configuration file makes it really easy to enroll one of my repositories; I just have to create a `renovate.json` at the root of the repository with this:

```json
{
    "$schema": "https://docs.renovatebot.com/renovate-schema.json",
    "extends": [
        "github>redjax/PipelineTemplates//config/renovate/default#main"
    ]
}
```

The centralized pipeline also allows repositories to provide their own `renovate.json` configuration. This feature gives me greater control over Renovate's behavior; for most repositories, the defaults are perfectly fine and "set it and forget it." Some of my repositories have package manager files in subdirectories, or use the `customManagers` config block to provide Renovate with regular expressions of files to monitor. For example, [my Dockerfile repository's `renovate.json`](https://github.com/redjax/Dockerfiles/blob/main/renovate.json) is much different from most of my other repositories. The Dockerfiles repo consolidates my Docker images into subdirectories in the `dockerfiles/` directory, and uses a [Github action to rebuild the container nightly and whenever an image has changed (i.e. a version bumps)](https://github.com/redjax/Dockerfiles/blob/main/.github/workflows/build-publish.yml). Each template also has an `image.yml` "manifest" file that tracks versions for the build script to inject.

I had to provide instructions to Renovate for how to handle this repository, but the centralized pipeline automatically uses whatever Renovate config file I pass from a consuming repository in `config-file:`.
