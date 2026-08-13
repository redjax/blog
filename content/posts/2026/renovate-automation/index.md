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

### The Calling Pipeline

In each repository where I want to use my central Renovate pipeline, all I need to do is create a pipeline "stub" that calls the centralized template. I use the pipeline's `inputs` to change configurations between repositories. The pipeline stub can be very simple; if the repository doesn't provide a `renovate.json` configuration, all it really needs is triggers, a couple of repository-specific inputs, and access tokens added to the repository.

A simple pipeline that runs once nightly at midnight could be:

```yaml
---
name: Run Renovate

on:
  schedule:
    - cron: "0 0 * * *"

permissions:
  contents: write
  pull-requests: write
  issues: write
  actions: write

jobs:
  renovate:
    uses: redjax/pipelinetemplates/.github/workflows/renovate.yml@main
    with:
      mode: run
      log-level: info
      repository: ${{ github.repository }}
      autodiscover: true
      renovate-author-email: "0000000+gitusername@users.noreply.github.com"
    secrets:
      renovate-token: ${{ secrets.RENOVATE_TOKEN }}
      gh-api-token: ${{ secrets.GH_API_TOKEN }}
```

Renovate will automatically detect languages and package managers it supports, create a dashboard issue, and start opening PRs to bump dependencies.

For an example of a more complex pipeline, the Dockerfiles repository is configured to run the pipeline every 4 times daily (every 6 hours). It will also trigger again after merging a `renovate/*` branch into the `main` branch. This extra trigger handles closing other PRs if they depended on another auto or manually merged PR, updating the Dashboard, and re-scanning the repository after version bumps. It also has a manual trigger if I ever want to run it, maybe while testing changes on another branch, or to do a "dry run" to see what will happen the next time the pipeline runs. The Dockerfiles repository provides its own `renovate.json`, and disabled "autodiscover" to force Renovate to use it.

This version uses `if` conditionals to change the way the pipeline runs depending on the trigger, and the PR events work to trigger the pipeline that rebuilds and publishes updated Dockerfiles.

```yaml
---
name: Run Renovate

on:
  schedule:
    - cron: "0 3 * * *"
    - cron: "0 9 * * *"
    - cron: "0 15 * * *"
    - cron: "0 21 * * *"
  push:
    branches:
      - "renovate/*"
  workflow_dispatch:
    inputs:
      mode:
        description: "Renovate mode"
        required: false
        default: "lookup"
        type: choice
        options:
          - extract
          - lookup
          - run
      log-level:
        description: "Renovate log level"
        required: false
        default: "info"
        type: choice
        options:
          - info
          - debug
          - trace

permissions:
  contents: write
  pull-requests: write
  issues: write
  actions: write

jobs:
  renovate:
    uses: redjax/pipelinetemplates/.github/workflows/renovate.yml@main
    with:
      mode: >-
        ${{ github.event_name == 'schedule'
            && 'run'
            || inputs.mode || 'run' }}
      # mode: run
      log-level: ${{ inputs.log-level || 'info' }}
      repository: ${{ github.repository }}
      config-file: renovate.json
      ## Set to 'ignored' while testing renovate.json changes on a different base branch,
      #  otherwise use 'optional'
      require-config: optional
      autodiscover: false
      runner-image: ubuntu-latest
      renovate-author-email: "0000000+gitusername@users.noreply.github.com"
      base-branches: "main"
      use-base-branch-config: true
    secrets:
      renovate-token: ${{ secrets.RENOVATE_TOKEN }}
      gh-api-token: ${{ secrets.GH_API_TOKEN }}
```

### Repository Secrets

My Renovate pipeline requires consuming repositories to have 2 secrets set in their environment. On Github, you can use [repository Action secrets](https://docs.github.com/en/actions/how-tos/write-workflows/choose-what-workflows-do/use-secrets). On Gitlab you can use masked & hidden [CI/CD variables](https://docs.gitlab.com/ci/variables/#define-a-cicd-variable-in-the-ui). On Forgejo/Codeberg, use [repository secrets](https://forgejo.org/docs/next/user/actions/basic-concepts/#secrets).

- `RENOVATE_TOKEN`: A token (i.e. a Github PAT or Gitlab PAT) with read/write access to the repository's contents, issues, and the ability to open and close pull requests.
  - On Github, the required token permissions are:
    - Code quality: `Read-only`
    - Code scanning alerts: `Read-only`
    - Commit statuses: `Read and write`
    - Contents: `Read and write`
    - Dependabot alerts: `Read-only` (I'm not sure why enabling this helps, but the tools were fighting each other until I added this)
    - Issues: `Read and write`
    - Pull requests: `Read and write`
      - You also need to enable "Allow pull requests" in the repository's "General" settings
    - Repository security advisories: `Read and write`
    - Secret scanning alerts: `Read-only`
    - Workflows: `Read and write` (to allow Renovate workflow runs to make changes)
  - On Gitlab, use a "legacy" token and give it `api` access
  - On Forgejo, the token needs:
    - `read:organization`
    - `write:issue`
    - `write:repository`
    - `read:user`
- `GH_API_TOKEN`: An optional Github PAT (classic) with `public_repo` scope.
  - While the token is option, you should provide it regardless of the Git platform to allow pipelines to read the Github API for versions, tags, and releases, without getting rate-limited.
  - Most pipelines interact with Github in some way, i.e. to download a tool release asset.
  - Even if the repository is on Gitlab or Forgejo/Codeberg, it can and will use this token when making requests to Github's API, and authenticated requests to Github have a much higher threshold for rate limiting.
