---
title: "Leaving Google Photos"
date: 2026-05-16T12:23:38-04:00
draft: true
slug: "/leaving-google-photos/"
# url: "/posts/leaving-google-photos/"
categories: []
tags: [
  "selfhost",
  "photos"
]
author: "me"
description: ""
showToc: true
TocOpen: false
hidemeta: false
comments: false
searchHidden: false
---

## Outline

- [x] Reason(s) for leaving
  - [x] Many stories about people losing access to their account due to misunderstandings or inaccurate "illicit material" detection.
  - [x] [Whole houses/families losing their account because of 1 user](https://www.pcworld.com/article/3104521/teenagers-gemini-mistake-locks-entire-family-out-of-google-accounts.html).
  - [x] [Training AI on our photos](https://www.digitalinformationworld.com/2025/08/google-gemini-will-soon-use-your.html).
    - [x] [Google Docs: Gemini features in Photos privacy hub](https://support.google.com/photos/answer/15344015?sjid=10263950563787648465-NC) states they do not use your photos to train, but the capability is there and I don't trust them to resist temptation.
- [ ] Moving to Immich
  - [ ] Run Immich in Docker Compose.
    - [ ] Resource limits to prevent runaway CPU usage.
  - [ ] (Optional) Pangolin proxy/auth.
  - [ ] Prepare a [Google Takeout](https://takeout.google.com).
  - [ ] Use [`immich-go`](https://github.com/simulot/immich-go) to upload photos from CLI.
    - [ ] API key permissions:
      - `asset.read`
      - `asset.statistics`
      - `asset.update`
      - `asset.upload`
      - `asset.copy`
      - `asset.replace`
      - `asset.delete`
      - `asset.download`
      - `album.create`
      - `album.read`
      - `albumAsset.create`
      - `server.about`
      - `stack.create`
      - `tag.asset`
      - `tag.create`
      - `user.read`
      - `job.create`
      - `job.read`
    - [ ] Show example install & upload scripts.
    - [ ] Show example of script to parse Immich upload log file for failed uploads.
  - [ ] Remove duplicates in the Immich UI.
- [ ] Future plans
  - [ ] Cloud storage mounted in Immich
  - [ ] Automated backups
    - [ ] Restic + rclone for S3/cloud, local, and NAS destinations.

---

I have been using Google Photos to backup my pictures since it was released in May of 2015. The software works great, seamlessly backing up any picture or video I take on my phone and making it simple to share photos and albums with my friends.

Like many people, I am trying to reduce my reliance on Google products. I have not gone as hard as some people, like the users of the [DeGoogle subreddit](https://reddit.com/r/degoogle), although I admire their efforts and agree with their philosophy. I have so, so many things tied to the Google/Gmail account I created in 2005. A younger me had no concept of being the product when a service is free, and I foolishly tied so much of my online life to my Gmail account. Extricating is a long, difficult process, and one I'm doing in baby steps.

The AI craze has been just the push I needed to take my privacy more seriously. Companies are changing their TOS, shoving AI hamfistedly into every corner of their product suite, trampling privacy and protection, and will not face any consequences for it in the foreseeable future. While it is too late to keep anything I've currently handed over to another entity to hold (like my pictures and personal information), I can limit further damage by pulling my most sensitive pieces of data back under my own control, and my photos felt like a good starting point.

## Reasons for Leaving

[Google Docs: Gemini features in Photos privacy hub](https://support.google.com/photos/answer/15344015?sjid=10263950563787648465-NC) states they do not use your photos to train, but the capability is there and I don't trust them to resist temptation. And whether or not they directly access my photos, enough of my life is wrapped up in Google's products that I don't believe they'd even need direct access to my pictures to abuse my privacy.

There are also horror stories, like the one where [a whole house/family lost access to their Google accounts because of 1 user's data](https://www.pcworld.com/article/3104521/teenagers-gemini-mistake-locks-entire-family-out-of-google-accounts.html). There is also the fact that [Google quietly enabled photo scanning on user devices, and made it opt-out by default](https://www.forbes.com/sites/zakdoffman/2025/02/28/google-starts-scanning-your-photos-without-any-warning/), an evil pattern we did not react strongly enough to a decade ago.

There is also the potential for losing access to your account simply because [Google decides your pictures are dangerous, without a care for context and with no recourse](https://www.koffellaw.com/blog/google-ai-technology-flags-dad-who-took-photos-o/).

With how sensitive my Google account is, and with how much I currently rely on them, anything I can do to pull my data back into my own control is worth the effort. I researched a few products (hosted and self-hosted, free and paid), and while I did find some promising options, I ultimately settled on 1 self hosted piece of software and a backup plan that I control.

## Alternatives to Google Photos

I started by looking into other hosted options, and the only one I would feel comfortable using is [Ente photos](https://ente.com). Ente is an open source company with a strong focus on privacy. They offer 10GB of free hosting (which is nowhere near enough for my library, but is a generous free tier), and the photos are end-to-end encrypted, meaning they can't see my photos even if they want to. I am comfortable with that level of control over my own data while hosting it on someone else's servers. I use some of Ente's other products and I think they do great work, and for someone who does not want to go through the effort of hosting it themselves, I think Ente is one of the best, most reasonably-priced alternatives to Google Photos there is.

I also evaluated 2 self-hosted solutions: [PhotoPrism](https://www.photoprism.app) and [Immich](https://immich.app). [This comparison between self-hosted photo apps](https://meichthys.github.io/foss_photo_libraries/) came in handy while I was looking over alternatives.

PhotoPrism is more intended for a single user, and for automated/(local) AI-assisted operations on your photos. It has great reviews, it's been around for a little while and has many users, and setup with Docker looks relatively simple.

Immich can perform many of the same functions as PhotoPrism, automatically recognizing faces and locations, tagging things, sorting by location, etc, but it's also geared more towards multiple users. And while I am currently the only user of my photo suite, the potential to allow family or friends to host their photos in my library is appealing.

## The winner: Immich

![Immich logo](/immich-logo-stacked-light.svg#center)

Immich is backed by [Futo](https://futo.tech), a company that makes local, privacy-respecting AI tools and whose [keyboard](https://keyboard.futo.org) I use and love on my phone. They have a [host of features I care about](https://github.com/immich-app/immich#features), and their [Android app](https://play.google.com/store/apps/details?id=app.alextran.immich) works great.

Moving my photos out of Google Photos and into Immich was also relatively painless. Below I detail the steps in detail, but I was able to use Google Takeout to export my photos, and the `immich-go` CLI to import them into my Immich server. After that, I merely had to install the Immich app, sign into my server, and turn on backups from my phone.

## Moving to Immich

The setup was relatively simple, I have the whole thing [running in Docker](https://github.com/redjax/docker_templates/tree/main/templates/media/docker_immich).
