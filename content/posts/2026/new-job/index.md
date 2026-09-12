---
title: "New Job"
date: 2026-09-11T00:56:49-04:00
draft: true
slug: "/new-job/"
# url: "/posts/new-job/"
categories: []
tags:
  - life
  - career
author: "me"
description: "Bittersweet endings, new beginnings"
showToc: false
TocOpen: false
hidemeta: false
comments: false
searchHidden: false
---

I started a new job recently as a DevSecOps Engineer for a company in the financial services industry. The company is mature, the coworkers are great, and the work is exhilerating!

I was overall happy with my old job, having worked my way into my dream role: DevOps Engineer. But as with any story where private equity is involved, the ending was swift, sudden, and shitty. The company I worked for was a bit of a unicorn, having entered a niche market at the right time and experiencing explosive growth the whole time I worked there. I met many wonderful, intelligent, talented, compassionate, fun people, many of whom I will make an effort to stay in touch with. The collaborative environment and general good vibes were truly a rarity, and I grew immensely during my tenure.

I may write another post at some point going into more detail about the demise of a once-great employer, but this post is supposed to be happy. The abridged version goes: after being "rebadged" by my old company (a term I've come to learn psycopath executives use for essentially selling their workforce to another company like cattle, but having them continue in their role as contractors with worse benefits and working conditions, while somehow asking with a straight face that you continue to care about the work the same way you did before), I started a search for more stable ground. I interviewed with a number of companies, felt good about a few only to be passed on, and generally got to experience the state of the job market amongst the many other jobseekers. I met some recruiters I've genuinely enjoyed talking to and hope to work with in the future; I even re-did my resume in LaTeX, allowing me to quickly generate variations of my resume for different roles, keeping the data and templates in source control and using a pipeline to generate a resume PDF!

After months of searching, the man who hired me at my old job reached out about a role as a DevSecOps Engineer at his new place of work. I was already friends with two other people who worked there, and during my third round I felt I really clicked with the team; we had a great conversation, drifting between technical questions and discussions to music and hobbies, and I even learned I went to high school with a distant relative of one of the team members. My final interview with the CTO and lead Developer also went well, and I was feeling very confident I would get the role, when after a couple of weeks of waiting, the position was pulled with nobody hired to do it.

I was completely devastated. I had learned not to daydream or get excited about a potential new job through the previous months of searching, but this felt like such a great fit. It helped to know I wasn't passed on, but that the position itself was closed. Fortunately for me, a change in headcount on the team re-opened the position, and I accepted an offer. The catharsis I felt resigning my old position was amazing, and I hope I never have to experience it again.

I felt very comfortable at the new job almost immediately. The team and larger organization were welcoming, friendly, and helpful, and I quickly picked up a couple of projects I'm very excited to work on. The company is in a period of positive change and modernization, and as their first DevOps hire, I am excited to be joining at the start of this time of growth. I have a good level of autonomy and support, and a wonderful level of freedom to work with the tooling I choose (within reason, of course). The product is interesting, and the work is incredibly engaging. While I am a fully remote employee, I have gone to the office twice and enjoy being there. The flexibility to work from home, where distractions are minimal and I can be highly productive, or go into the office to have facetime for meetings and meet coworkers I otherwise wouldn't interact with, is what I've been searching for. I feel trusted as an adult responsible for completing my work, in a way that feels like graduating from high school into college.

A big part of my work will be with the Platform team, developing a repository of CI/CD pipeline templates and components to centralize functionality defined in disparate existing pipelines the developers have built over the years and implementing security scanners into their build process. I am nearly finished with my first pipeline, a flexible orchestrator for security scanners like [Trivy](https://trivy.dev/), [Gitleaks](https://gitleaks.io/), [Trufflehog](https://github.com/trufflesecurity/trufflehog), and [OSV-scanner](https://github.com/google/osv-scanner). I set up a Postgres instance with Docker Compose to serve as [the database server for OWASP's definitions](https://dependency-check.github.io/DependencyCheck/data/database.html), and am working on an architecture to automate updating definitions so pipeline and local workstation scanners can skip the lengthy download phase of a scan. I have also written a number of Powershell scripts for the Infrastructure team, and feel like I'm filling a niche, doing things I absolutely love because others haven't had the time.

The company is privately owned, and doesn't feel at risk of being picked apart by private equity vultures. The family-owned business has been around for over half a century, and is being gracefully handed down to the next generation over time. Company materials discuss the future growth of the company as if the owning family intends to be invested for the long haul. I also work with a close friend I met at my first "real" job many years ago, we've had fun trading good morning messages and chatting throughout the day.
