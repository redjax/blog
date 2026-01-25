---
title: "How Linux Frustrated Me Into Loving It"
date: 2016-03-24T00:00:00-05:00
draft: false
categories: []
tags: ["linux", "story"]
author: "me"
description: "Re-post of an old Medium article I wrote in 2016."
showToc: false
TocOpen: false
hidemeta: false
comments: false
searchHidden: false
---

![Header image](linux-story.jpeg#center)

I have been very interested in Linux since my entry into the Wonderful World of Unix in 2006. I found Ubuntu and installed it on a crappy Dell desktop computer I was given when I was doing online schooling. The computer originally came with Windows, and one day while I was browsing, I decided to search for “alternative to Windows.” Linux popped up right away. I had never heard of Linux before, but after voraciously reading article after article, I decided Linux was the path for my future.

!["Linux for human beings" was not applicable in 2006](ubuntu-logo.jpeg#center)

Like most Linux newbies, [Ubuntu](https://ubuntu.com) was the first distribution I found. Back in 2006, Ubuntu wasn’t ugly, necessarily, but it definitely was not a pretty distribution. When I first found Ubuntu, they were on version 6.10, “Edgy Eft.” My initial thoughts were that their naming convention was stupid (Ubuntu picks an animal for each release and creates an adjective-noun alliteration for it), but it looked interesting, and I decided to try it. I downloaded the image and burnt it to a CD (I’ve since moved to multibooting Linux images from a USB stick), popped it in my CD tray, and jumped straight down the rabbit hole.

![Ubuntu Linux 6.10 "Edgy Eft"](ubuntu-edgyeft-desktop.jpeg#center)

I was always interested in computers as a kid, but I had never entered into the world of partition and driver hell that was such a reality back in 2006. When I booted the disk, I was presented with an installer (back then, I believe it was still a command line installer of sorts…it was graphical, but not like today’s installers; there was a lot of room for error). Before I started the installation, I had printed out a “how to install Ubuntu” guide, but I didn’t read very much of it previous to my first attempt. At that point, I had not had much trouble in figuring out how to install, configure, and use software in the Windows world.

![The modern Ubuntu installer is nearly foolproof](ubuntu-installer.jpeg#center)

During my first attempt, I completely wiped out my Windows partition and deleted everything I had on my computer, because I had no idea what “format” meant, or what a partition even was. I also did not successfully install Linux on my first attempt. I thought I had destroyed my computer.

!["Lesson learned...read about what I'm doing before I do it."](frustrated-lady-computer.jpeg#center)

I had no idea what I did wrong, but I read through the guide I printed, and realized retroactively that I should have done that initially. I learned about partitions, and realized with my skillset, there was no way to get the data I had lost back. I accepted that truth, and realized I had no hope of restoring a Windows install, because I had not been sent a recovery disk with the computer. I wiped the tears off my face and resolved to get Linux installed on my computer, no matter how difficult the task was.

I put the Ubuntu CD I had made back in the tray, cracked my knuckles like I saw people on TV do, and braced for impact. The installation window came back up, and this time, armed with my handy installation guide, managed to install Ubuntu. I didn’t do any fancy partitioning or anything, seems how I had just learned partitioning was even a thing, so Ubuntu was on my entire disk. I booted up my computer, and all was right in the world.

Actually, that’s not the case at all. Back in 2006, Linux was awesome, but had a ton of driver problems. My computer was a low end Dell with an Ethernet driver that was not included in the installation image. After many hours of developing my troubleshooting skills without an Internet connection, I used my brother’s working Windows computer (and I’d be lying if I said I wasn’t envious of his working computer, or that he had not decided to be adventurous with me) to research installing the driver for Ubuntu. I found some documentation for the model of Dell I was using, and found that there were a few other driver problems as well. I downloaded the drivers, put them on a USB stick, and printed the guide for installing the drivers on Ubuntu (what a year 2006 was, where we didn’t have smartphones to just pull up the guides when we needed them. So much wasted paper…).

![YOU WILL NOT GET THE BEST OF ME, YOU STUPID MACHINE!](guy-screaming-at-monitor.jpeg#center)

Let’s recap. At this point, I had a CD burnt with the Ubuntu live image on it, a USB stick with a few drivers, and about 25 pages worth of documentation. I had failed the installation initially, destroyed my Windows partition, lost some data that was pretty important at the time (I had to redo a few assignments), and scared myself a little into thinking Linux might not be for me. Luckily, I am a bit (ok, very) defiant when it comes to computers besting me, and I was not about to let this low end Dell tell me who’s boss. This stupid computer was going to run Linux whether it liked it or not, and based on my experience trying to install Linux and getting the proper drivers, it did *not* want to run Ubuntu. Tough luck, you stupid Optiplex.

Back to the story! I popped the USB stick into the computer to install the drivers I had found online…only to find that in 2006, Ubuntu did not support FAT formatted drives out of the box. I punched myself in the face in frustration, and went back to my brother’s computer to learn about different file systems. I didn’t understand any of what I was reading, but it boiled down to me learning what the “Format” option does when right clicking a drive on Windows. I formatted the drive, and in my young stupidity, forgot to back up the drivers. After curling up in a ball and rolling around the floor in frustration, on the verge of giving up and accepting that my computer was currently as useful as an uncomfortable footrest, I decided this was all a learning process, and shifting my mentality from “why in the world do so many people love Linux” to “there must be a reason so many people love Linux,” I got back on my brother’s computer, downloaded the drivers again, and took my newly formatted EXT3 drive back to my room. I sat at the computer, prayed to any gods who were listening, and put the USB stick into the slot on my computer.

!["Computer god, please let this work, because if it doesn't, I'm jumping out the window with this PC in my arms](guy-praying-to-monitor.jpeg#center)

A wave of relief rushed over me as I saw a neat little animation pop up on my desktop, confirming that my disk had properly mounted (of course, I didn’t know what “mounting” a disk was, but thankfully I didn’t have to play around in my FSTAB file, or else I would probably not be enjoying Linux today, stuck instead with Windows in Microsoft Land). I opened the drive, found my drivers, and moved them to my Downloads folder in Ubuntu. I double clicked them to install, just like you would on Windows, right?

![WRONG](wrong.jpeg#center)

Of course it wouldn’t be that simple! What was I even thinking? Linux is a complex beast, and until you know what you’re doing and see the efficiency, Linux’s simplicity feels like complexity. Through my tears of frustration, I consulted the guide I had printed for installing the drivers on Ubuntu. Some thoughts running through my head while reading were “Shell? Terminal? Why do I have to type something in this weird program, just to install a driver?! What have I gotten myself into…” I decided not to think, and just to follow the guide. I found the Terminal program, opened it up, and noticed it looked a lot like the command prompt on Windows. I previously used the command prompt for the ping command exclusively, because on my Windstream connection (little plug: Windstream sucks. Don’t use.), pinging could help me determine if my computer was the problem, or if our connection was out, and based on past experiences with Windstream, it was usually the latter.

Anyway, with the terminal opened, the guide told me to “cd” to the Downloads folder, and use a command called “chmod +x” to tell the computer the driver files were executable. “Hold up…the computer doesn’t just know I want to run something? I have to actually tell it this file can be executed? Good lord, I hate Linux.” I think that is a more common thought for newbies than people realize/remember. It’s honestly a miracle and a testament to how great Linux is that any converters actually stay with it.

## Getting Back on the Internet, and Next Steps

So, my computer was finally ready to install the drivers. I had to type some weird command with a dot in front of it (./[driver name]) to get the driver to install. I later learned that the “./” portion of the command tells the computer to run whatever input you’re giving it through the shell.

A bunch of text started flying through the terminal, and I thought for sure I had either broken my computer again, or that I had learned how to hack, since this is how it looked in the movies. Of course, neither of those scenarios were my reality, but I let the commands run with faith that my computer would not catch fire in front of my eyes.

![This looks pretty intimidating to anyone new to a terminal shell](terminal-output.jpeg#center)

When the command finally stopped running and the terminal was dutifully waiting for more commands, my network connection icon in the statusbar started spinning, and I got a little popup that my network connection was active. I sat stunned for a minute that I’d Forrest Gump’d my way into a working Linux installation. I opened an Internet browser (I had been using Firefox on Windows, so this was *one* thing I was familiar with in this new land), went to Google, and danced with joy that I had a working Internet connection.

I could go into more detail about the troubles I had learning Linux, but suffice it to say, learning Linux coming from never even hearing about it before was a long, arduous process of trial and extremely frustrating error. The thought of adjusting to the command line alone was daunting enough to keep me wondering if I had made a huge mistake, but after a couple days of using Ubuntu, I was captivated by the uniqueness and simultaneous familiarity. I love change, and I love experimenting with computers, and this was a whole new world for me. I got comfortable with the command line, and found it to be far superior to the click and drag interface I was used to, although people new to Linux will be happy to hear you can do pretty much everything graphically, especially on Ubuntu. No scary terminal window necessary!

## My Time with Linux Since Then

It didn’t take me very long to learn that Linux was just the core of the operating system, and there were loads of different “flavors,” or “distributions,” of Linux. I had started on Ubuntu, which I learned was an offshoot of the great Debian distribution, plus a few enhancements. Once I traced Ubuntu’s roots back to Debian, I found that there were many, *many* different offshoots of Debian, and even some that came from Ubuntu. The more I searched, the more I found that Linux is one hell of an ecosystem, with distributions for just about anything you can want. There are distributions crafted to be run solely as a server; distributions that value security and stability over cutting edge technology; distributions like Arch Linux that are always up to date, to the point of being unstable at times; and distributions with a nice mix of stability and freshness, like Fedora.

![A graphic with a very small sampling of different Linux distributions](varied-linux-distros.jpeg#center)

I decided to try Fedora out, and found that Gnome 3 looked much nicer than Ubuntu’s desktop, which was based on the older Gnome 2. Ubuntu eventually created their own entirely unique environment, called Unity, and caused *quite* a divide in the community: some people loved the fresh, unique take on the desktop, and some people despised the fact that Ubuntu tried to pigeon hole them into change. One thing I’ve learned about the Linux community is that people really, really value their freedom of choice, and when a distribution makes an executive decision, they will hear loud and clear the displeasure of the people they pissed off.

![Ubuntu’s “Unity” desktop was a major shock to some people with how different it was from their previous desktop](ubuntu-unity-desktop.jpeg#center)

Since trying Ubuntu and Fedora out, I have become what the community dubbed a “distro hopper.” Distro hoppers want to get their feet wet with as many distributions as they can find. I’ve tried ’em all, starting with Ubuntu, moving to Fedora, and from there travelling swiftly through [Linux Mint](https://linuxmint.com/), to [Debian](http://www.debian.org/) when I felt I had learned enough about Linux to try the mother distribution; I tried [ZorinOS](http://zorinos.com/) because it promised to be familiar to people coming from Windows, and they were right; I installed [openSUSE](https://www.opensuse.org/) because I liked the green lizard, but I eventually made my way back to Debian-land and settled on Linux Mint. It felt fresh and clean, but still offered the simplicity and idiot-proof nature of Ubuntu. I stuck with Mint for a long time, but eventually the itch hit me again, and I started hopping around.

![Linux Mint was my home for a long time, mostly because it had all the drivers I needed pre-packaged with the image](linux-mint-desktop.jpeg#center)

When I got bored of the safeness of Linux Mint, I branched out into fringe and new distributions. I found [elementaryOS](http://elementary.io/), which was, at the time, a very new branch from Ubuntu. Its main offering was a positively *gorgeous* interface, taking obvious inspiration from Apple’s Mac OS X (they deny that they were inspired by Apple’s OS, but it’s pretty apparent to anyone that they at least valued OS X’s clean, consistent interface and color scheme). I bounced from elementaryOS over to [DeepinOS](https://www.deepin.org/), which is a Chinese distribution that’s doing a lot of new and exciting things to the Ubuntu desktop world.

Eventually I got tired of hopping around and not finding the one distribution that fit all my needs. I wanted something that was stable, had up to date packages so I could try new things, was easy to manage, and was modifiable in a way I had not found yet. I am a compulsive modder, changing things just for the sake of change. I had heard of [Arch Linux](https://www.archlinux.org/), a distribution that the community likes to tout as “for hardcore users only.” There is surely a steep learning curve, but the documentation and community is so passionate about their distribution that the entire process of installing and maintaining an Arch Linux install is very demystified at this point. I had read about how customizable Arch Linux is, and decided this was surely the next step in my journey.

![The main reason I picked Arch was their pretty logo](archlinux-logo.jpeg#center)

I downloaded the net install (a *very* small image that requires you to be connected to the Internet, where it then downloads the rest of the installation) and set to work. And good lord did I mess a lot of things up. Setting Arch Linux up is to this day one of the hardest, most time consuming, and frustrating things I have ever done. It took me *weeks* to get a working installation. After failing the first 5 times, I decided to try in a virtual machine. I would go through the Arch installer, get a system up and running, delete the virtual machine, and try again. I probably did this 20 times before I felt comfortable trying again on my computer.

And I still failed. I’ve only ever had 1 working Arch install, and at that point I was too scared to mess with it and screw things up even more. I read around, and a lot of people suggested [Antergos](https://antergos.com/), which is essentially a simple, graphical installer for Arch Linux that adds a repository for themes.

![Antergos’s motto is very true, unlike 2006 Ubuntu’s “Linux for humans”](antergos-logo.jpeg#center)

The Cnchi graphical installer for Antergos was beautiful, and worked like a charm. I had a working Arch Linux install on my computer within 15 minutes. And as it turns out, Arch Linux is the absolute perfect distribution for me. It’s stable, it’s *faaaast*, it’s customizable beyond belief, and most importantly for me, it’s as up to date as you can be. As soon as a program is updated, it gets added to Arch Linux’s central repository, or its indescribably useful User Repository (AUR), and you can download it with a simple *pacman -S* command. I could write a whole post about my journey with Antergos, and perhaps I will…but for now, suffice it to say I had found my home.

With Arch Linux, I had everything I wanted. No more distro hopping to get a package update I wanted, or a theme that only worked with a certain base (Debian or Redhat, for instance). No more obliterating my installation with a simple update, which happened far too frequently in my time with openSUSE. Antergos was *it* for me. I grew to love how configurable it was, which initially was a very daunting task (pretty much everything is configured through the command line by editing text files).

## Where I Am Now with Linux

This post is getting long, as I forgot how passionate I am about Linux until I took this nostalgic trip down Linux-Hell memory lane.

Since I first accidentally wiped out my Windows installation, I have been treading deeper and deeper into the Linux forest. I have learned more about computers and their inner workings in my ~10 years with Linux than I ever knew with a Windows installation. I have lost data, formatted my hard drive every which way hundreds of times, found new uses for Linux in my everyday life, and set up my own home server using an ESXi host running a few Linux virtual machines (another post for another time).

I took the plunge and decided to use Linux as my main operating system a couple years ago, booting into Windows infrequently to use a couple of programs I simply can’t use to their full potential in Linux (namely FL Studio and a couple of Windows only games). It’s true that at first, Linux is scary. You have to learn the command line if you want to do anything besides basic Internet browsing and word processing; you have to read a lot of documentation and forum posts to learn how you stupidly messed up your installation, and you have to develop a tough skin to deal with the community, which is made up of some really grumpy old timers and a disproportionately large group of newcomers who ask a *lot* of questions. It’s a testament to Linux’s greatness that so many people put up with all of that, just to use the operating system on their computer.

Because of my love for Linux, I am now working towards learning what I need to learn to become a Linux Systems Administrator, where I will get to work with Linux computers and servers for a living, and learn even more about this wonderful software project that has broken so much ground over the years. I’m sure there will be many more long nights spent figuring out where I went wrong in an update, or why my configuration files aren’t working as intended, but I look forward to being tired the next day from staying up too late playing on my computer, feeling satisfied that I fixed whatever went wrong, and that I am still loving the Linux Life.

![Got Linux?](got-linux.jpeg#center)
