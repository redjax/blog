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

## The Solution

I started a plan to centralize all of my pipelines in 1 single repository, with the idea being I could freely move the repository around and not get tied to any 1 platform. I would store all of my pipelines (Github Actions and reusable workflows, Gitlab CI components, Concourse pipelines, etc) in this repository, and create "calling" pipeline stubs in consuming repositories to make use of the centralized pipelines. If I ever moved the centralized repository to another code forge, for example from Github to Gitlab, I could simply update the caller pipelines with the new location.

I created my [`PipelineTemplates` repository](https://github.com/redjax/PipelineTemplates) to store my pipelines, and a [`PipelineTemplates-Test` repository](https://github.com/redjax/PipelineTemplates-Test) to prototype and test them before using them in my "real" repositories. I started with a [`go-build` Action](https://github.com/redjax/PipelineTemplates/tree/main/.github/actions/go-build) and used the [`PipelineTemplates-Test` repository's `test-build-go-flat.yml` pipeline](https://github.com/redjax/PipelineTemplates-Test/blob/main/.github/workflows/test-build-go-flat.yml) to test it. I implemented component versioning using [`bump-my-version`](https://github.com/callowayproject/bump-my-version) and created some pipelines and scripts to check the pipeline component paths for changes on PR merge to `main`, and bump any version files for changed components. The pipeline uses git history and [Conventional Commit messages](https://www.conventionalcommits.org/en/v1.0.0/) to determine the version bump type (major, minor, or patch), and a script to [handle the bumps](https://github.com/redjax/PipelineTemplates/blob/main/shared/scripts/bash/versioning/bump-changed-components.sh).

These initial pipelines helped me work out the repository's structure, and taught me some things about wiring workflows and pipelines together. For instance, Github is very strict about how you structure pipelines; everything must go under either `.github/actions/` (for Github Action components) or `.github/workflows/` (for reusable workflows that encapsulate repeatable logic that other repositories consume). For Actions, you cannot call scripts from outside the `.github/actions/<action-name>/` path, which put a dent in my plan of sharing the same scripts across multiple CI platforms. I set out with a plan to write purpose-built scripts and write the pipelines that call them as simple "wrappers" that pass inputs into the script to determine behavior, so I could easily move CI platforms without significantly altering the "business logic" of a given pipeline.

Having worked with Concourse CI and Azure DevOps, this was a shift in my understanding of how I should build the `PipelineTemplates` repository. While I could still force each Action to clone the whole `PipelineTemplates` repository to make a script outside the Action's path accessible, that strategy introduces moving parts that make breakage more likely, and so I decided to embrace each platform's philosophies and treat `PipelineTemplates` as a monorepo.

{{<  notice info >}}
As of 2026-07-18, I am still evaluating [Dagger](https://dagger.io) as the solution to this problem. The appeal of Dagger is that you "write 1 pipeline and run it anywhere." The Dagger modules I write would do the same exact thing whether I ran them locally from the CLI, in a Github Action, a Concourse pipeline, or a Woodpecker CI pipeline. All of the important logic is encapsulated in the Dagger module, and the pipeline that calls it can be simplified to just passing inputs into the module.

I have not fully embraced this, but as I build out this repository the concept becomes more appealing, and I will most likely end up converting at least some of the pipelines to Dagger modules.
{{< /notice >}}

For each pipeline/workflow/component I created, I would create a "caller" pipeline in the `PipelineTemplates-Test` repository to test it. The test repository also serves as a set of example pipelines I can copy/paste into my "real" repositories to add the pipeline's functionality. For example, this blog uses [a pipeline named `hugo-main.yml`](https://github.com/redjax/blog/blob/main/.github/workflows/hugo-main.yml) to call the [`PipelineTemplates` repository's `hugo-site-main.yml` workflow](https://github.com/redjax/PipelineTemplates/blob/main/.github/workflows/hugo-site-main.yml). The centralized pipeline orchestrates version bumping for versioned Hugo sites, building the site and uploading the static files as a pipeline artifact, creating a tag and release on Github with the static site assets, and deploying to 1 or more targets such as Github Pages, Cloudflare Pages, or Netlify. After much trial and error, I now have a configurable workflow that repeats these same steps for any Hugo repository I call it from. It supports versioned and unversioned sites, building from a Hugo site stored at the repository root or in a subdirectory, and it supports the various ways I might deploy a site to another platform. If the platform watches a branch for changes to publish, the workflow supports "publishing" the site to a branch, i.e. `github-pages`, or if the platform supports uploading a raw archive, the pipeline will upload one of the release assets. For example, Cloudflare Pages supports [uploading a .zip archive of your site with the Wrangler CLI](https://developers.cloudflare.com/pages/get-started/direct-upload/), and that's exactly what the [`hugo-publish-cloudflare-pages.yml` workflow](https://github.com/redjax/PipelineTemplates/blob/main/.github/workflows/hugo-publish-cloudflare-pages.yml) does.

Keeping all of my pipelines in 1 place also makes it easier to [document them](https://github.com/redjax/PipelineTemplates/tree/main/docs). For instance, the Hugo site pipeline I described above is documented in [`docs/ci-cd/github-actions/workflows/hugo-site-main`](https://github.com/redjax/PipelineTemplates/tree/main/docs/ci-cd/github-actions/workflows/hugo-site-main).

## The Results

While I still have a lot of work to do to centralize all of the different pipelines I regularly use, the work I've done has already improved my process. I maintain a number of personal sites that are Hugo blogs, and I now have workflows to handle all of the different structures and publishing targets I use. If I ever want to publish to a new platform, or add steps (like security scanning or [Lychee link checking](https://github.com/lycheeverse/lychee)), it is easier to add a single step and have every other Hugo repository benefit from it. Updating pipeline component and CLI tool versions is much easier with the [`PipelineTemplates`'s Renovate workflow](https://github.com/redjax/PipelineTemplates/blob/main/.github/workflows/renovate.yml), which runs every day at 3am and creates pull requests to bump versions to a new release. Every repository that calls a pipeline in the central repository benefits from up-to-date versions, and as syntax changes, I only have to update in 1 place (and maybe make a slight tweak here and there to the calling pipelines).

This repository has taken the maintenance burden of keeping pipelines and versions up to date across many repositories, and turned it into a convenient one-stop-shop for all of my pipeline needs. If I ever want to use another platform, like Gitlab or Codeberg, I can easily isolate the pipelines for those forges into their own directories in the central repository, and they benefit from the automated Renovate scanning, too. The separate `PipelineTemplates-Test` repository helps me to mock and test new pipelines in a non-commital way, allowing me to make all of the mistakes I need to in a throwaway sandbox environment before converting real repositories to one of the centralized pipeline. And it makes documenting everything much easier, as whenever I make changes to the pipeline, I can just go update the pipeline's documentation in the central repository in the same commit.

## Future Plans

I still have a lot of disparate pipelines to bring into the fold in this centralized repository. I need to create centralized workflows and Actions for formatting, linting, testing, building, and deploying a variety of apps in languages I use (Python, Go, Bash, Powershell, Astro, etc). As I create new pipelines, I find more efficient ways of doing things, and I run into plenty of scenarios where the goal I set out with is impossible or infeasible. This process helps to refine the centralized pipeline into a repeatable, assembly-line style process, and forces me to write more generic and capable of pipelines, rather than customizing each workflow specifically to the repository it's running in. It forces me to be more diligent and disciplined about how I structure the consuming repositories. This rigidity is also freeing, in that I no longer have to think about when I should start automating a repository and how I should do it. If I am writing a new Hugo site, I can add the calling pipeline very early on in the process and let the repository benefit from the workflow I've ironed out for building Hugo websites, and get right back to work on building the actual site.

I need to test moving the repository around code forges, and documenting the process; a big goal with this project was to keep all of my pipelines in a single place that I could easily backup or move to other platforms, with minimal interruption in the calling repositories. Part of this test will be converting an existing workflow from one platform to another, i.e. recreating the Hugo site workflows for Github into a Gitlab-friendly version, in case I ever move my code there.

I eventually want to spend time consolidating some of the logic embedded in the pipeliens into scripts or small apps I can re-use across pipeline technologies, which will make it easier to move between platforms.
