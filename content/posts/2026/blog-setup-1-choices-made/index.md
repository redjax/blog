---
title: "Choices Made"
slug: "/blog-setup/choices-made"
date: 2026-02-03T00:00:01-05:00
draft: true
series: ["blog-setup"]
summary: ""
categories: []
tags: ["post", "setup", "hugo"]
author: "me"
description: "The setup & hosting choices I made for creating this blog."
showToc: true
TocOpen: false
hidemeta: false
comments: false
searchHidden: false
---

## CI/CD

I spent time planning the structure of [the git repository for the blog](https://github.com/redjax/blog) to make it portable. I have seen a number of blogs switch platforms over the years, and the posts they write at the end of a migration have inspired some of the choices made for this blog. For example, while this project is hosted on Github and I am using Github Actions to do things like lint the content and publish new pages, I also recreated the functionality in [Concourse CI pipelines](https://concourse-ci.org) so I am not tied to a specific git platform. I could move the blog's repository to any other remote, like [Gitlab](https://gitlab.com) or [Codeberg](https://codeberg.org) without breaking my CI/CD. At some point I will probably try writing the pipelines in [Dagger](https://dagger.io) to make them truly portable.

## Hosting

As of 01/24/2026, this blog is hosted on [Netlify](https://netlify.com), a platform I have been looking for a reason to try. I disabled Netlify's automated rebuilds on merges to main so I could [write a deployment pipeline of my own](https://github.com/redjax/blog/blob/main/.github/workflows/hugo-deploy.yml), mainly for the experience, but also to ensure I don't break the site when I'm trying new things. I hit Netlify's free tier limit in 2 days because of all the pipeline failures...I mean "tests" that I ran...but the team was generous enough to refresh my credits when I reached out for support. +1 to Netlify!

Because the site is just static HTML/JS/CSS, I leave the option open to move the site's hosting to basically anywhere. I build a [production Docker image](https://github.com/redjax/blog/tree/main/.containers/prod), so I could deploy a container somewhere and route the `techobyte.cc` domain to it, or simply copy the static files to any host that can serve files via a web server. This ensures I won't get "stuck" with a specific host, or with a specific deployment method. I have heard of many bloggers who run their blogs off a Raspberry Pi they have in their house, and there's really nothing stopping me from doing the same!

## Theme

This was a tough one... Hugo has [a lot of themes](https://themes.gohugo.io). Most of them look good, some of them look great, but I had a few requirements in mind:

- Optimized for text-based posts. Most of my posts will be text-heavy, so optimizing layout for reading was an important factor.
- Simplicity, I didn't want to use a highly customizable theme that would require a lot of configuration and tweaks.
  - I am aware of my tendency to find [yaks to shave](https://en.wiktionary.org/wiki/yak_shaving), and want to focus on writing.
  - Limiting myself to themes that are opinionated and rigid narrowed the selection pretty significantly.
- As generic as possible. Themes like [Blowfish](https://themes.gohugo.io/themes/blowfish/) are amazing, but you have to go all-in to really take advantage.
  - I am building this blog for the long term. The ability to switch themes/site generators is highly appealing.
  - The more customization I need to do to the blog, the more I am building the site around the theme rather than the content.
- Content is front and center, no landing pages or superflous sections.
- Support RSS (this is [officially supported by Hugo](https://gohugo.io/templates/rss/), but some themes handle revealing the functionality to readers better than others).

I decided to start with [PaperMod](https://themes.gohugo.io/themes/hugo-papermod/) as my theme. While it is kind of opinionated and has some theme-specific configurations, they seem easy enough to "rip out" if I ever want to change it later. It has a light and dark mode, and center-aligns the content for distraction-free reading. RSS setup was easy, and the icon is very obvious on pages that support it.
