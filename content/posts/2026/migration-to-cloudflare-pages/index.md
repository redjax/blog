---
title: "Migration to Cloudflare Pages"
date: 2026-08-02T01:53:55-04:00
draft: true
slug: "/migration-to-cloudflare-pages/"
# url: "/posts/migration-to-cloudflare-pages/"
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

I migrated my blog to [Cloudflare Pages](https://pages.dev) on August 2nd, 2026. It was originally hosted with Netlify, and while I think Netlify's service is good and I don't have any real complaints, the potential to run up my bill and get my site disabled until the next billing cycle is a motivator to try something else. This situation happened as I was setting up the CI/CD pipeline for deploying the blog, which I describe in the [Blog Setup series: Choices Made post](/posts/blog-setup/choices-made#hosting).

I have used Github Pages for static site hosting in the past (i.e. my [RedKB personal knowledgebase site](https://redkb.fyi)), but I wanted to give Cloudflare Pages a try. They offer unlimited deployments, and setup was very simple. The [Hugo deployment pipeline I built](https://github.com/redjax/PipelineTemplates/blob/main/.github/workflows/hugo-site-main.yml) already supports [publishing to Cloudflare Pages](https://github.com/redjax/PipelineTemplates/blob/main/.github/workflows/hugo-publish-gh-pages.yml), I just had to give it some new values and set secret values in the repository.

As I discuss in my [blog setup series](/posts/blog-setup/), I built my repository around the concept of portability. I wanted to be able to move around Git forges and hosting providers, and support a variety of deployment/publishing destinations. I have read posts from other bloggers I follow who have moved platforms (i.e. Wordpress to Hugo) and hosting providers/deployment methods, and I hope writing about my experience migrating from Netlify to Cloudflare Pages can save someone some time in the future.

## Migration

### Github Preparation

The Hugo publshing pipeline also requires a secret named `RELEASE_BOT_PAT`. This is a [Github Personal Access Token (PAT)](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens) that has the following permissions:

- Actions: Read and write
- Contents: Read and write
- Workflows: Read and write

### Cloudflare Preparation

A [Cloudflare API token](https://developers.cloudflare.com/fundamentals/api/get-started/create-token/) with `Pages: Edit` permissions is required. In Github, I created the following repository secrets and pasted my values from Cloudflare:

- `CLOUDFLARE_ACCOUNT_ID`: My global [Cloudflare Account ID](https://developers.cloudflare.com/fundamentals/account/find-account-and-zone-ids/).
- `CLOUDFLARE_API_TOKEN`: The secret token value with permission to write to Cloudflare Pages.

The Hugo deployment pipeline automatically creates a Pages app if one does not exist with the given project name. I gave the `cloudflare-pages-project` a value of `techobyte-blog`, which automatically created an app in Cloudflare and deployed the site to `https://techobyte-blog.pages.dev` when the pipeline ran. My domain's DNS is already managed by Cloudflare, so setting up my `techobyte.cc` domain was pretty simple. I had DNS records pointing the domain to the site deployed to Netlify, but all I had to do to switch it was open the Pages app, go to the "Custom domains" page, and type my domain into the input box. Cloudflare prompted me to overwrite my existing DNS records, which I let it do, and it removed my Netlify records and set a CNAME for `techobyte-blog.pages.dev`. I had to manually change the `www.techobyte.cc` CNAME record to the same value.

## Pipeline Changes

In the blog's CI/CD pipeline, I changed the default value of the `publish-targets` input for manual runs from `'["netlify"]'` to `'["cloudflare-pages"]'`, which disabled publishing to Netlify:

```yaml
publish-targets:
  description: 'JSON array of publish targets, e.g. ["netlify","cloudflare-pages"]'
  required: false
  type: string
  default: '["cloudflare-pages"]'  # Change default publish target to Cloudflare Pages
```

I also added inputs for `cloudflare-pages-project` and `cloudflare-pages-branch`, which the pipeline uses for [deploying to Cloudflare Pages with Wrangler CLI](https://developers.cloudflare.com/workers/wrangler/):

```yaml
cloudflare-pages-project:
  type: string
  required: false
  default: "techobyte-blog"
cloudflare-pages-branch:
  type: string
  required: false
  default: "main"
```

After making these changes, I ran the pipeline manually and my site published to Cloudflare Pages successfully! Any time I make changes to the site's files (i.e. adding or updating a page, deleting a page, updating custom CSS or Hugo config, etc) and merge them into the `main` branch successfully, the pipeline triggers and rebuilds the site, then publishes it to Cloudflare.

## Outcome

A reader of my blog shouldn't notice any difference now that I've switched hosts. If you were to do an `nslookup` or ping `techobyte.cc`, the response already had a Cloudflare IP and routed through Cloudflare's networks. For maintenance and ongoing development, I can freely merge changes into `main` without worrying about exceeding a quota, or test changes to a pipeline repeatedly without hitting a CPU cycle/build minutes limit, and I am no longer concerned with my site going offline in the middle of a billing cycle because I went over the limits of a free plan. Who knows if Cloudflare Pages will keep its free offering so generous forever, but for now I am happy with the switch.
