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

- Problem: many repos, copy/paste pipelines with slight changes
  - High maintenance burden
  - Blind spots (deprecated Actions)
- Solution: centralized 'PipelineTemplates' repository
  - Components for code forges (Github Actions, Gitlab CI, Concourse, etc)
  - Pipeline 'stubs' in each consuming repository
- Examples:
  - Renovate
  - Hugo

## Writing Notes

Github Actions message when an Action is deprecated:

```shell
Update submodules and create PR if needed
Node.js 20 is deprecated. The following actions target Node.js 20 but are being forced to run on Node.js 24: peter-evans/create-pull-request@v5.
```
