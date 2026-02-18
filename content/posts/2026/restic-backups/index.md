---
title: "Restic Backups"
date: 2026-02-18T00:14:33-05:00
draft: true
url: "/posts/restic-backups/"
categories: []
tags: ["backup", "restic"]
author: "me"
description: "How I use Restic in my homelab for automated, encrypted, space-efficient backups."
showToc: false
TocOpen: false
hidemeta: false
comments: false
searchHidden: false
---

Having a good backup strategy is essential when you host your own data. If you have not experienced the dread of realizing you've lost an important file, consider yourself lucky and continue reading for why you should have a backup strategy.

I have lost important data a number of times throughout my life, and each time my backup strategy has gotten more robust. I have lost my entire music sample collection 3 times, and while I have been able to start fresh with new sounds each time, the work I had put into curating my library was gone. When I started selfhosting to reduce my reliance on solutions from companies I don't trust, I neglected coming up with a backup strategy earlier, and have learned the importance of backups a few too many times.

There are a number of great solutions out there, from [Kopia](kopia.io), [Duplicati](https://duplicati.com) and [Borg](https://www.borgbackup.org) to good ol' [rsync](https://rsync.net), and I have tried most of them.

## The Journey

For a long time, I used Bash scripts scheduled with cron to create `.tar.gz` archives of important directories in a central location, i.e. `/opt/backups`. I eventually started using the `rsync` CLI tool to copy the backups via SSH to a central machine with a few extra hard drives.

These scripts got unwieldy, and I've lost most of them because I was not yet using version control yet so they are lost to time. I also had the problem of having to write different scripts for different Linux distributions and Windows.

I eventually started looking for tools I could install, and was surprised to find a ton of different open source projects with varying approaches to backup.

### Duplicati + Wasabi

*duplicati img here*

I started with Duplicati, which I used to create scheduled backups to my NAS and [Wasabi S3 storage](https://wasabi.com). Creating the scheduled jobs was easy, and there is a management webUI that made creating and monitoring the backups pretty easy.

I was able to avert a couple of data loss events by restoring from a Duplicati backup, but I ended up running into database correction a time or 2 (a known issue with Duplicati, if you search "Duplicati database corrupted"). You can recover from this state, but after the 2nd time it happened, I started looking for a different solution.

Duplicati Pros:

- WebUI was a nice way to manage the backups graphically.
- Scheduling jobs with retry logic was easy.
- Multiple backends, from local storage to cloud buckets to webDAV.

Duplicati Cons:

- Slow backups
- Restore operations are much more hit or miss than other solutions. Database corruption was a bit too common, and the manual restore process got tiring.
- While the WebUI is convenient, it's also not winning any style awards.

*kopia img here*

I really liked being able to add a Wasabi bucket as one of the backup destinations, and my searches eventually lead me to try Kopia. I had read forum posts of people moving to Kopia from Duplicati, and I ran the 2 side-by-side for a while to get a feel for Kopia.

It did not take long to drop Duplicati entirely. It took me a little while to get used to having only 1 repository for backups, and I never got around to setting up a [Kopia server](https://kopia.io/docs/repository-server/) to allow for more. The way I used Kopia was essentially a per-machine repository.

Kopia worked well for me, and I would still recommend it as an option. The UI was the biggest pain point for me: the CLI commands were long and hard to remember, and the webUI was spartan and at times unintuitive.

Kopia Pros:

- Fairly easy to pick up and understand.
- Reliable scheduled backups, faster than Duplicati, and the resulting snapshots were smaller.
- Different apps for different needs (a CLI, an optional web interface, and a desktop app).
- Test data restores worked flawlessly every time, and Kopia allowed for restoring to a destination, or in-place (restoring directly back to the path where the original file/directory was).

Kopia Cons:

- The webUI, while better than Duplicati, still let something to be desired.
- While Kopia has a ton of features, the complexity could be difficult to navigate.

### Borg Backup

*borg image*

I will be honest, I probably didn't give Borg enough time to write an honest review about it. I started using it essentially in tandem with picking up restic, and quickly gravitated to restic.

I love Borg in theory, it's a tool known for its relative ease of use and reliability when it comes time to restore from a backup. In comparing Borg and restic, I found [a helpful Reddit thread](https://www.reddit.com/r/BorgBackup/comments/v3bwfg/why_should_i_switch_from_restic_to_borg/) comparing the 2 tools, and a few of the points were enough for me to move fully to restic. Below are the direct quotes from the post that swayed me (in case the link rots over time):

- Restic's cryptography is much better because it has been [endorsed](https://words.filippo.io/restic-cryptography/) by one of Google's cryptography experts that wrote the crypto library for Google's Go language. He ended up choosing Restic as his personal backup system after the investigation.
- Borg's cryptography has many security flaws and they're working on a rewrite of it for the next 1.3+ release named "Helium". ...*truncated*
  - *Borg 2.0 addresses these concerns, but is still in beta as of February 2026 and not recommended for production use.*
- Borg requires that the receiver runs Borg on the server, which limits it to rsync.net and borgbase.com for online cloud storage. There's also Hetzner Storage Box which since February 2022 ...*truncated*

## Restic

As I researched and tried different backup solutions, I kept seeing comments and posts about restic. I learned about people [scripting restic with Bash](https://blog.bithive.space/post/automatic-backups-with-restic/), like I had done with rsync.

Restic has powerful deduplication with their [Contend Defined Chunking (CDC) implementation](https://restic.net/blog/2015-09-12/restic-foundation1-cdc/), leading to smaller backups and better accuracy.

Restic also works with [many different backends](https://restic.readthedocs.io/en/stable/030_preparing_a_new_repo.html), and can use [rclone](https://rclone.org) to expand backup destination options even more.

[Restic](https://restic.net)
[Resticprofile](https://github.com/creativeprojects/resticprofile)
[Backrest](https://github.com/garethgeorge/backrest)
