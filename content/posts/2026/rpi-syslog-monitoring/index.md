---
title: "Raspberry Pi Syslog Monitoring"
date: 2026-11-01T11:00:13-05:00
draft: false
slug: "/rpi-syslog-monitoring/"
# url: "/posts/rpi-syslog-monitoring/"
categories: []
tags: 
  - homelab
  - selfhosting
  - raspberrypi
  - grafana
  - loki
  - monitoring
  - sre
  - devops
  - unifi
  - networking
author: "me"
description: ""
showToc: false
TocOpen: false
hidemeta: false
comments: false
searchHidden: false
---

While I was poking around in my AT&T modem's admin UI, I discovered it can forward logs to syslog. I had a Raspberry Pi 3B sitting around doing absolutely nothing. So I plugged it into one of the modem's LAN ports and setup rsyslog to collect the events from the modem.

I have a separate Unifi network behind the modem, so this Raspberry Pi is on the Unifi's WAN, but my house's LAN. It collects network events passing between the networks. But why stop there?

I connect the isolated AT&T and Unifi networks with my self-hosted Netbird VPN. If you're a fan of Tailscale but want to host it yourself, I highly recommend it! I have a [Docker Compose stack for you](https://github.com/redjax/docker_templates/tree/main/templates/networking/docker_netbird) if you want to get started.

After a week or so of manually tail-ing the logs, I decided to setup Grafana Alloy to export formatted log events to a Loki container. And that quickly spiralled into creating a Grafana dashboard for all of my network traffic. I can see how many log events happen in a given time period, where the traffic originated and where it's headed.

![Modem logs dashboard](grafana1.png#center)

As any self-respecting tinkerer will appreciate, I was not satisfied to stop there, with a useful dashboard charting my home network's traffic. Surely, Unifi's gateway can also export to syslog, right?

Correct! I'm running rsyslog and Alloy in containers on my Unifi controller's host (also a Docker image), and a "satellite" Loki database so I don't overwhelm my poor, underpowered Raspberry Pi. The Alloy container on the controller exports to the local Loki instance, which Grafana connects to over my Netbird VPN.

![Unifi dashboard](grafana2.png#center)

I added some widgets to see overall traffic, and tables for the top 20 source/destination IPs and ports.

![Unifi network stats dashboard](grafana3.png#center)

But how will I know when the Raspberry Pi is overloaded or running out of disk space? I needed a way to chart metrics like RAM and CPU usage, network saturation, and available disk space, so I added Prometheus to the stack. It scrapes a node_exporter container on the Unifi controller and the Raspberry Pi, allowing me to chart system resources alongside the network traffic.

![Prometheus resource usage dashboard](grafana4.png#center)

The full stack:

![Dockhand full stack](full-stack.png#center)

The next step is going to be adding a large disk for log retention. This is quickly filling up the internal 64GB SD card in the Pi, and with the price of hardware, I will have to wait for a donation from someone getting rid of an old computer or something. I'm also organizing the workspace directory for this into a git repository so I can share it on Github. It will have the central syslog + Loki + Prometheus + Grafana server, and subdirectories for "satellite" instances of Loki, Prometheus, etc.
