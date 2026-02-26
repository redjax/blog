---
title: "Comparing backup solutions (why I picked Restic)"
date: 2026-02-25T22:00:00-05:00
draft: true
url: "/posts/comparing-backup-solutions/"
categories: []
tags: ["backup", "story"]
author: "me"
description: "My thoughts on backup managers I've tried throughout the years, and why I think Restic is the perfect tool for many backup scenarios."
showToc: true
TocOpen: false
hidemeta: false
comments: false
searchHidden: false
---

Having a good backup strategy is essential, especially when you host your own data. If you have not experienced the dread of realizing you've lost an important file, consider yourself lucky and keep reading to learn why you should have a backup strategy for your data. I have lost important data due to lack of sufficient backups a number of times in my life. It never gets any less devastating, but each time it's happened I have inched closer to a sufficient backup strategy.

There are a number of great solutions out there, from [Kopia](kopia.io), [Duplicati](https://duplicati.com) and [Borg](https://www.borgbackup.org), to good ol' [rsync](https://rsync.net) and a remote share, and I have tried most of them. Let's talk about them, and why I ended up using Restic for all of my backups.

## The Problem

For a long time, I used Bash scripts scheduled with cron to create `.tar.gz` archives of important directories in a directory on my machine, i.e. `/opt/backups`. I eventually started using the `rsync` CLI tool to copy the backups via SSH to a central machine with a few extra hard drives.

These scripts got unwieldy, and I've lost most of them because I was not using version control yet. I also use both Windows and Linux, and translating my backup scripts to Powershell from Bash was good practice, but tedious.

## The Journey

I eventually started looking for tools I could install, and was pleased to find a ton of different open source projects with varying approaches to backups. I tried a bunch of them, feeling more and more like Goldilocks as I found one solution too resource intensive, another too complicated, some were too unreliable and others difficult to navigate. In my quest to find the perfect solution for my needs, the following utilities felt closest to my nebulous idea of the perfect solution for my homelab.

### Duplicati + Wasabi

![Duplicati logo](duplicati-logo.png#center)

I started with Duplicati, which I used to create scheduled backups to my NAS and [Wasabi S3 storage](https://wasabi.com). Creating the scheduled jobs was easy, and there is a management webUI that made creating and monitoring the backups pretty easy.

I was able to avert a couple of data loss events by restoring from a Duplicati backup, but I ended up running into database corruption a time or 2 (a known issue with Duplicati, if you search "Duplicati database corrupted"). You can recover from this state, but after the 2nd time it happened, I started looking for a different solution.

{{< notice tip >}}
Duplicati Pros:

- WebUI was a nice way to manage the backups graphically.
- Scheduling jobs with retry logic was easy.
- Multiple backends, from local storage to cloud buckets to webDAV.

Duplicati Cons:

- Slow backups
- Restore operations are much more hit or miss than other solutions. Database corruption was a bit too common, and the manual restore process got tiring.
- While the WebUI is convenient, it's also not winning any style awards.
{{< /notice >}}

### Kopia

![Kopia logo](kopia-logo.svg#center)

I really liked being able to add a Wasabi bucket as one of the backup destinations, and my searches for an alternative to Duplicati eventually lead me to try Kopia. I had read forum posts of people moving to Kopia from Duplicati, and I ran the 2 side-by-side for a while to get a feel for Kopia.

It did not take long to drop Duplicati entirely. It took me a little while to get used to having only 1 repository for backups, and I never got around to setting up a [Kopia server](https://kopia.io/docs/repository-server/) to allow for more. The way I used Kopia was essentially a per-machine repository.

Kopia worked well for me, and I would still recommend it as an option. The UI was the biggest pain point for me: the CLI commands were long and hard to remember, and the webUI was spartan and at times unintuitive.

{{< notice tip >}}
Kopia Pros:

- Fairly easy to pick up and understand.
- Reliable scheduled backups, faster than Duplicati, and the resulting snapshots were smaller.
- Different apps for different needs (a CLI, an optional web interface, and a desktop app).
- Test data restores worked flawlessly every time, and Kopia allowed for restoring to a destination, or in-place (restoring directly back to the path where the original file/directory was).

Kopia Cons:

- The webUI, while better than Duplicati, still left something to be desired.
- While Kopia has a ton of features, the complexity could be difficult to navigate.

{{< /notice >}}

### Borg Backup

![Borg Backup](borg-logo.svg#center)

I will be honest, I probably didn't give Borg enough time to write an honest review about it. I started using it essentially in tandem with picking up restic, and quickly gravitated to restic.

I love Borg in theory, it's a tool known for its relative ease of use and reliability when it comes time to restore from a backup. In comparing Borg and restic, I found [a helpful Reddit thread](https://www.reddit.com/r/BorgBackup/comments/v3bwfg/why_should_i_switch_from_restic_to_borg/) comparing the 2 tools, and a few of the points were enough for me to move fully to restic. Below are the direct quotes from the post that swayed me (in case the link rots over time):

- Restic's cryptography is much better because it has been [endorsed](https://words.filippo.io/restic-cryptography/) by one of Google's cryptography experts that wrote the crypto library for Google's Go language. He ended up choosing Restic as his personal backup system after the investigation.
- Borg's cryptography has many security flaws and they're working on a rewrite of it for the next 1.3+ release named "Helium". ...*truncated*
  - *Borg 2.0 addresses these concerns, but is still in beta as of February 2026 and not recommended for production use.*
- Borg requires that the receiver runs Borg on the server, which limits it to rsync.net and borgbase.com for online cloud storage. ...*truncated*
  - *Hetzner storage boxes are also supported now, but the number of available backends for Borg is still limited.*

## Arriving at Restic

![Restic icon](restic-logo.png#center)

As I researched and tried different backup solutions, I kept seeing comments and posts about restic. I learned about people [scripting restic with Bash](https://blog.bithive.space/post/automatic-backups-with-restic/), like I had done with rsync.

Restic has powerful deduplication with their [Content Defined Chunking (CDC) implementation](https://restic.net/blog/2015-09-12/restic-foundation1-cdc/), leading to smaller backups and better accuracy.

Restic also works with [many different backends](https://restic.readthedocs.io/en/stable/030_preparing_a_new_repo.html), and can use [Rclone](https://rclone.org) to expand backup destination options even more.

With restic, you [create a repository](https://restic.readthedocs.io/en/stable/030_preparing_a_new_repo.html) (it's easy to create and use multiple repositories stored in different backends), point the program at a path, give it an [excludes file](https://restic.readthedocs.io/en/stable/040_backup.html#excluding-files) (or an ["includes" file](https://restic.readthedocs.io/en/stable/040_backup.html#including-files)), and [let it rip](https://restic.readthedocs.io/en/stable/040_backup.html). It's pretty much that easy.

I have tested Restic with an external SSD, a directory on another machine (via SSH, facilitated by Rclone), pCloud (also via Rclone), and a Wasabi S3 bucket. Restic does a great job of making all of this feel insignificant and simple, it doesn't matter if your backup is on the same machine or a cloud bucket in another region of the world, what matters is the contents and integrity of the backup, which Restic handles gracefully.

Restic makes it easy to [explore your snapshots](https://restic.readthedocs.io/en/stable/045_working_with_repos.html), and in my tests [restoring data](https://restic.readthedocs.io/en/stable/050_restore.html) is quick, simple, and "just works." You can also [script Restic operations](https://restic.readthedocs.io/en/stable/075_scripting.html), although I never dove too deep into this.

Instead, I found 2 other tools that cemented my choice to use restic for my backups: [Resticprofile](https://github.com/creativeprojects/resticprofile) and [Backrest](https://github.com/garethgeorge/backrest).

{{< notice tip >}}

Restic pros:

- Backup speed, especially during incremental backups
- Powerful deduplication saves space
- Great 3rd party tools like resticprofile and backrest
- Good mix of security and usability

Restic cons:

- There is a slight learning curve, and the command chains can feel unnatural at first, especially if you're coming from a GUI/webUI application
- Restic on its own can feel cumbersome, with long commands and a lot of args. Extra tooling like Resticprofile or Backrest helps significantly with this

{{< /notice >}}

### Resticprofile

Resticprofile is a wrapper for restic that works by reading backup [configurations from a file](https://creativeprojects.github.io/resticprofile/configuration/index.html). You can define defaults, the file supports [inheritance](https://creativeprojects.github.io/resticprofile/configuration/inheritance/index.html), [templates](https://creativeprojects.github.io/resticprofile/configuration/templates/index.html), and [template variables](https://creativeprojects.github.io/resticprofile/configuration/templates/index.html); you can "group" individual profiles which you can call with `resticprofile -n <profile-name>`. After defining your backups, you can run `resticprofile schedule install` to add scheduled tasks (systemd on Linux, Task Scheduler on Windows, Launchd on macOS), which fully automates your backups. It can monitor backup status using [a JSON file](https://creativeprojects.github.io/resticprofile/monitoring/status/index.html) or by [sending metrics to Prometheus](https://creativeprojects.github.io/resticprofile/monitoring/prometheus/index.html).

Restic and Resticprofile being cross-platform, with support for Linux, Windows, and macOS, meant I could use the same app and portions of the same configuration file across my machines. Automating the backups meant I did not have to write custom, per-platform scripts to run the backups on a schedule.

### Backrest

I also add Backrest to some of my servers, which provides a webUI I can use instead of logging into the machine directly. Backrest can import and use existing repositories, and the UI allows for the same level of orchestration as resticprofile or the restic CLI. You can browse snapshots and restore files in the webUI, add notifications to Discord, Slack, Gotify, etc, and it has pre/post command hooks to execute shell scripts. I generally use either Backrest *or* resticprofile on a given machine, as they both serve essentially the same function. But since they can both use the same backend repository, it's easy to switch them out on-demand if I decide I want to manage backups using one or the other.

Backrest also has [a Docker container](https://github.com/garethgeorge/backrest?tab=readme-ov-file#running-with-docker-compose), which makes it a great addition to Docker Compose stacks for automating container data backup.

## Conclusion

I was aware of restic for a while before I actually decided to try it, and I can say I wish I had tried this tool sooner. While there's a slight learning curve, once you get your first backup running, and especially after using a tool to automate the complexity like resticprofile or backrest, it's clear to me that restic is the perfect combination of user friendliness, security, reliability, and simplicity for a backup solution. I will write another post or 2 describing how I actually use restic, with examples of a resticprofile configuration file and some dos/don'ts.
