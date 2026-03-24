---
title: "Tech Brutalism"
date: 2026-03-12T01:48:42-04:00
draft: true
slug: "/tech-brutalism/"
# url: "/posts/tech-brutalism/"
categories: []
tags: []
author: "me"
description: ""
showToc: true
TocOpen: false
hidemeta: false
comments: false
searchHidden: false
---

Like all good blog posts, I will start by defining the word this article is about: "brutalism"

> Brutalist architecture is an architectural style that emerged during the 1950s in the United Kingdom, among the reconstruction projects of the post-war era.
> Brutalist buildings are known for minimalist construction showcasing the bare building materials and structural elements over decorative design.
> The style commonly makes use of exposed, unpainted concrete or brick, angular geometric shapes and a predominantly monochrome colour palette; other materials, such as steel, timber, and glass, are also featured.
>
> -[Wikipedia](https://en.wikipedia.org/wiki/Brutalist_architecture)

You have probably seen many examples of Brutalist architecture without realizing what you were looking at. Computers and buildings are not all that similar, but the design philosophy of Brutalist architecture really resonates with me in a way I think can be applied to technology, and perhaps should be more often. Strap in for a good "old man yells at cloud" post.

## Tech Brutalism

I don't know if this philosophy/concept is already out there when it comes to computing, but what I mean by tech brutalism is "technology stripped to its essence." Simple function over form. The machine you're reading this on and the machine I wrote this on are just that, a machine meant to perform a task (or in the case of a computer, a great many tasks).

We romanticize and anthropomorphize technolgy, to the point where [we begin falling in love with it in dangerous ways](https://www.bbc.com/future/article/20260209-can-a-machine-ever-love-you). In the early days of computing, nerds huddled over CRT teerminals, typing arcane symbols into a UI that looks straight out of the greatest movie ever filmed (I'm of course speaking of [Hackers](https://www.imdb.com/title/tt0113243/)), spending incredible amounts of time organizing the flow of data to produce programs that were nothing short of disgustingly ugly. Nobody was asking for fancy React components, or really styling of any kind. Computer resources were limited, the available space on a screen and pixel resolution added constraints that forced some brilliant software design.

Just look at this old filesystem UI:

![Old computer UI](old-computer-ui.jpg#center)

If your initial reaction was to cringe at how ugly it is, stop for a moment and look past the design and layout. This interface is functional, and discoverable. Large, clearly labeled buttons, clearly labeled windows with simple, identifiable controls and icons, and a legible font. OS elements like window resizing and help menus are exposed in the UI, similar to how a Brutalist building exposes its structural elements.

This is the concept I wish to convey with "tech brutalism." A focus/emphasis on the underlying components a UI layer facilitates, focused on the essential function of the technology rather than how pretty it looks. There is nothing wrong with a polished, pleasant interface, but if it serves to obfuscate function in the pursuit of form, there is a detrimental effect to the user's understanding of how that technology works.

## Abstraction Layers

As time went on and computers reached the masses, there was a push for a more accesssible computing experience for the "average person." This was a good thing! In the decades since the early 2000's, when more and more homes had a family computer, and then individual computers, into personal mobile devices, the push to make the devices and software more accessible opened the door for many more people to approach a computer. It is unequivocally good to "democratize computing," and to make the technology accessible to those with disabilities.

Somewhere along the way in this pursuit, we began to place more of an emphasis on the *form* of technology, rather than its *function*. In our quest to make a UI approachable, we have come almost full circle to Fisher Price-esque buttons, massive amounts of wasted screen real estate with intentional whitespace where underlying components could be exposed, shoving more and more of the program's functionality behind nested toolbar menus, and generally polishing a thing into extinction.

Function and form can and should balance each other. But if we were to overemphasize one of these traits, should we not focus more on the ability of the machine to perform its task, rather than how good it looks doing it?

While a Chromebook or iPad may be more accessible to the masses, what benefit are we giving them teaching UI patterns that only work in 1 ecosystem? How are they supposed to transfer knowledge when the concept of a filesystem is abstracted in its entirety?

### What We Lose by Abstracting

If you were a tech-inclined child sometime between the mid-to-late '90's and early 2000's, you are familiar with the joy of learning how to use a computer. It was difficult, frustrating, and one of the most rewarding experiences to explore a computer. You were also much closer to the layer doing the actual computing, and regularly had to dig into the internals of the OS or program you were using to monkey patch and wrangle the computer into performing its task.

And in the process, you learned a ton about how a computer actually works. When the underlying components were exposed, and you were encouraged (or at times, forced) to interact with them, you would have had a hard time not picking up a thing or two and understanding more about the overall world of computing. This might have earned you the "coveted" position of Family Tech Support Representative, where you got to hone your abilities more by diagnosing and fixing other peoples' machines.

Fast forward a bit to the 2010's and beyond, if you were (or are) a kid, you have more access to computers than anyone in history, and from a far younger age than the previous generation. Hundreds of millions of dollars have been pumped into usability studies and UX designers for the past 15 years. You are handed a device that has been designed to be so easy, you can get by almost on instinct alone. There are only a few UI elemnents, with pretty colors and unnecessary animations guiding your attention and hooking into parts of your psychology you aren't even aware of, leading you to use the machine the exact way the UX designer wants you to. You are discouraged or outright prevented from peeking under the hood, discovering and applying tweaks and modifications to personalize your device to you or enhance its functionality. Your concept of a filesystem is a folder in a cloud storage account.

In the pursuit of "form," a marketable device with a pleasant user interface and thousands of times more computing power than necessary for the simple web browsing you'll be primarily using the device for, the people who built it have successfully hid the most useful, functional parts from you. Using the device will feel uninspired, routine, maybe even ordinary.

## Technology, the Hard Way

Although it feels like a lost battle at this point to pull the world back towards a focus on functionality, there are some things a dedicated technologist (or hobbyist computer enthusiast) can do to force learning. You will need to make an intentional effort to ignore "the easy way," which will constantly tempt you by popping up first in any of your searches, and offer comfort when you feel stuck.

Reject that temptation!

Using a computer "the hard way" is one of the best learning catalysts. Don't reach for AI every time you see an error message or want to add a feature to an app. If you're using a program like Neovim, build your configuration by hand, learn the Lua you're writing as you do it, before reaching for plugins or a preconfigured distribution. When you want to learn a programming language, resist the urge to start installing 3rd party packages immediately, don't seek out linters or formatters or VS Code plugins. Just open the documentation and start working through examples.

Force yourself to hold onto and use a computer longer than you naturally would. Resist the consumerist urge to buy this year's latest and greatest, and instead spend time learning how to optimize the system you already have. Eek as much power as you can out of as little as you can.

When you look into tooling that exists around building and using technology, understand why it came into existence and what problem it solves. Force yourself to experience that problem, whether it's doing something by hand instead of automating it, until it becomes so boring and routine you don't feel there are any other corners or surprises. Then you will understand and appreciate why the tool that makes it easier exists.

Technology has become dogmatic. People repeat maxims they've heard, or best practices they've read, or they argue for or against something because they've spent more time amongst a community that holds a particular side in an argument. But how many dogmatic people understand where their opinions came from, or why a particular flame war raged?

By forcing yourself to experience and learn the hard way, you are taking a slower, more deliberate approach to that learning, and will end up with a far deeper understanding of the topic than someone who picked it up as it was the latest trend. Many trends in computing are just another iteration or abstraction layer, and understanding the layer beneath will help you when the abstraction fails.
