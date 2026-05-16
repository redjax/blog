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
showToc: false
TocOpen: false
hidemeta: false
comments: false
searchHidden: false
---

## Outline

- [ ] Reason(s) for leaving
  - [ ] Many stories about people losing access to their account due to misunderstandings or inaccurate "illicit material" detection.
  - [ ] [Whole houses/families losing their account because of 1 user](https://www.pcworld.com/article/3104521/teenagers-gemini-mistake-locks-entire-family-out-of-google-accounts.html).
  - [ ] [Training AI on our photos](https://www.digitalinformationworld.com/2025/08/google-gemini-will-soon-use-your.html).
    - [ ] [Google Docs: Gemini features in Photos privacy hub](https://support.google.com/photos/answer/15344015?sjid=10263950563787648465-NC) states they do not use your photos to train, but the capability is there and I don't trust them to resist temptation.
  - [ ] Only [15GB of free storage](https://www.bgr.com/2055598/is-google-photos-storage-free-price-explained/).
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
  - [ ] Remove duplicates in the Immich UI.
- [ ] Future plans
  - [ ] Cloud storage mounted in Immich
  - [ ] Automated backups
    - [ ] Restic + rclone for S3/cloud, local, and NAS destinations.
