---
title: "Centralized Pipelines"
date: 2026-07-15T01:07:19-04:00
draft: true
slug: "/centralized-pipelines/"
# url: "/posts/centralized-pipelines/"
categories: []
tags: []
author: "me"
description: ""
showToc: false
TocOpen: false
hidemeta: false
comments: false
searchHidden: false
---

## Outline

- [x] Problem: many repos, copy/paste pipelines with slight changes
  - [x] High maintenance burden
  - [x] Blind spots (deprecated Actions)
- Solution: centralized 'PipelineTemplates' repository
  - Components for code forges (Github Actions, Gitlab CI, Concourse, etc)
  - Pipeline 'stubs' in each consuming repository
- Examples:
  - Renovate
  - Hugo

## Writing Notes

Example Github Actions message when an Action is deprecated:

```shell
Update submodules and create PR if needed
Node.js 20 is deprecated. The following actions target Node.js 20 but are being forced to run on Node.js 24: peter-evans/create-pull-request@v5.
```

I recently began centralizing my CI/CD pipelines in [a Github repository named "PipelineTemplates"](https://github.com/redjax/PipelineTemplates). For years, I have copied/pasted and slightly modified pipelines, workflows, and configurations between repositories. These pipelines handled tasks like linting and formatting my Python and Go code on PR open to the `main` branch, building/compiling code, creating Github tags and releases, deploying artifacts, and most of them were performing the same larger role, but in ways that were tailored to each individual repository.

## The Problems

The practice of copy/pasting pipelines worked for a while, especially for smaller, more repeatable and predictable patterns, but over time became difficult for me to maintain. I've used tools like [Renovate](https://github.com/renovatebot/renovate) and [Dependabot](https://docs.github.com/en/code-security/tutorials/secure-your-dependencies/dependabot-quickstart) to help to keep my pipeline references up to date and secure, but it meant merging many of the same PRs as Github Actions and CLI tooling versions change upstream. When I would create a new repository, I would have to go back to the last repository I remembered having the pipeline(s) I wanted to use, copied updated everything, and tweaked them specifically for the new repository. My pipelines became more like a genetic lineage than a cohesive strategy; each new repository got a pipeline with some of its DNA from the parent pipeline, and then passed any new modifications onto the next iteration.

One of the biggest challenges I had with this pattern was staying on top of updates for components like Github Actions. Every time the [`actions/checkout` Action](https://github.com/actions/checkout) would change, for example, I would have to go back to every repository's pipeline that used that Action and bump the version. As I approached, and eventually exceeded, 100 code repositories, it became increasingly obvious that this pattern would not work forever. And to make matters worse, Github Actions isn't the only CI platform I use! I self-host [Concourse CI](https://concourse-ci.org/), [Woodpecker CI](https://woodpecker-ci.org), and [Jenkins](https://www.jenkins.io/), I have tinkered with [Dagger](https://dagger.io/) and [Taskfile](https://taskfile.dev/) pipelines, and I have used [Gitlab CI](https://docs.gitlab.com/ci/) for code repositories I host on Gitlab.

The problems I wanted to solve were:

- Code duplication from copying between repositories
- Central creation and maintenance of pipelines, workflows, and versioned components
- Keeping dependencies and pipeline components up to date
- Consolidating functionality like linting and formatting, builds, releases, and deployments
