---
title: "Firefox vs Chrome Extensions: The Experience of Building and Publishing"
createdDate: "2020-12-14"
modifiedDate: "2020-12-18"
tags: ["coding", "learning"]
garden: "evergreen"
summary: "I recently had an idea for a small web app. And for the first time, I decided to also publish both a Firefox add-on and a Chrome extension for it. This was my experience right from building it till publishing it to the corresponding stores."
---

I recently had an idea for a small web app. And for the first time, I decided to also publish both a Firefox add-on and a Chrome extension for it. This was my experience right from building it till publishing it to the corresponding stores.

The idea behind this post is to share my experience so if you, the reader, plan to publish an extension in the future, you will get an idea of what to expect.

The post is structured as follows and to make it more fun, I choose a winner among Firefox and Chrome web store for each stage.

1. About the app
2. Creating the extension
3. Debugging the extension
4. Registration process
5. Publishing the package
6. Initial review
7. Subsequent release
8. Final wrap up
9. Some tips if you are planning to develop an extension

## **0. About the app**

Have you ever had a link open on your browser that you wanted to send to your mobile? How do you do it? I know there are a few applications that lets you do this but I wanted something really simple.

Since we can open links by scanning a QR code, I built an app called [Open this Url](https://openthisurl.com/) that generates a QR code. I created a bookmarklet (bookmark link) for this app which is a JavaScript snippet:

```js
javascript: void open(
  "https://openthisurl.com/g?url=" + encodeURIComponent(location.href),
  "Open this URL",
  "width=200,height=275"
);
```

Once you add this snippet to your bookmarks, you can click on the bookmark link when you have any link open and this will create a small popup with the QR code for the link. You can then scan this link from your phone.

I sent it some of my friends and all of them found it useful. But some of them didn&#8217;t know about bookmarklets so they did not know how to get this to work. I created a video explaining how it works. A few of them said &#8220;But could you just make this into a browser extension?&#8221;

Since I have never published a browser extension before, I thought it would be fun to try.

And I did end up creating browser extensions. They are live on both [Chrome](https://chrome.google.com/webstore/detail/openthisurl/ebcejpedcchttps://chrome.google.com/webstore/detail/openthisurl/ebcejpedccgbmpnocggeomidamkoibbbgbmpnocggeomidamkoibbb/) and [Firefox](https://addons.mozilla.org/en-US/firefox/addon/openthisurl/) store.

While building and publishing this extension for Chrome and Firefox, I started noticing the differences between the two.

## **1. Creating the extension**

Having never created an extension before, I did what most developers do when they are new to something: Copy from a tutorial, make it work and then understand what is going on to fix the issues that popup.

Firefox has the best [tutorial for creating an extension](https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/Your_first_WebExtension/). I followed it and got my app to work a testable stage in a very short time.

My assumption was that an extension I build for Firefox should work for Chrome without any major changes. And luckily that was the case. Though I did have to make some changes but more on that later.

It actually took more time for me to create the required icons for the extension. Ideally you want to have a 16&#215;16, 48&#215;48 and 128&#215;128 icons.

Since the same code was working fine for both the browsers, this is a tie.

## **2. Debugging the extension**

Both Firefox and Chrome has a way to load extensions and test.

To debug an extension in Firefox:

1. Open a new tab and type about:debugging
2. Click on &#8220;This Firefox&#8221; on the left
3. Click on Load Temporary Add-on
4. Choose any file from your source code

To debug an extension in Chrome:

1. Click on the extensions icon new the URL bar to the right OR click on the three vertical dots → More tools → Extensions
2. Toggle developer mode ON
3. Click on Load unpacked
4. Choose the main folder of your source code

At a high level, there are some common steps. BUT&#8230; For Firefox, I had to Google to find how to get to the extensions page whereas it was quite obvious for Chrome. That being said, once I knew how to do it in Firefox the first time, it became very easy the subsequent times.

When testing the extension, I had some issues in my code and this was extremely easy to debug in Firefox. In the Extensions page, there is an icon to Inspect that gives you access to developer console for the extension. Maybe it is just me, but I had a hard time finding it in Chrome and I gave up without searching because I was able to anyway debug in Firefox.

I think Firefox wins the debugging process over Chrome.

**Firefox 1 &#8211; 0 Chrome.**

## **3. Registration process**

Now that I had my extensions ready, it was time to first register for Chrome web store and Firefox add-on developer accounts.

I started registering for Chrome first. There is a one time $5 registration fee. There is also a limit of 20 extensions. So if you want to publish more than 20 (which is rare for most people), you have to register a different account.

During the registration process, partly because there is a fee, you have to fill lots of details. It took me around 15 minutes.

Next I went to Firefox Add-on registration. This process was so quick. There is no fee and there is no limit (I could find) for the number of add-ons you can publish. The whole process took less than 5 minutes.

Considering that there is a (very small) fee and it took longer to register for Chrome web store, I think Firefox wins this process as well.

**Firefox 2 &#8211; 0 Chrome.**

## **4. Publishing the package**

I got both the packages ready for publishing. Both Chrome and Firefox expect you to upload a ZIP file.

I started with Chrome. Like their registration process, they ask for a lot of details before you can publish your extension. They ask you to upload at least one screenshot and it has to be either 1280&#215;800 or 640&#215;400. Easy right? Well, not really. I created a screenshot of size 1280&#215;800 and it gave me an error without much details (&#8220;an error occurred&#8221;). I tried a few things and after 10 minutes, it accepted one of the screenshots. I still have no idea what it expects. I read their image requirements and couldn&#8217;t find anything that I was not following during the first few tries.

The whole process for Chrome took around 20 minutes.

Next up, Firefox. The first thing I noticed is that when I uploaded the zip file, it said it could not recognize the extension files. The way I had my extension package was, I had the project folder as parent and then the files inside. Chrome detected this but Firefox required me to compress the files directly and not the project folder. This seemed odd but it was a quick fix.

Firefox doesn&#8217;t ask for much information. It was very straightforward and took less than 10 minutes.

Publishing the package was also much easier in Firefox, so it wins this round.

**Firefox 3 &#8211; 0 Chrome**.

## **5. Initial Review**

I submitted both the extensions to their respective stores and now it was time to wait. Chrome approved my initial version first. It took them around 12 hours. There wasn&#8217;t any review comments or feedback. I was happy to see it approved in the first try.

Firefox team got back in the next few hours. The extension was not approved. They wanted me to add an opt-in step at the beginning. They also wanted me to add a privacy policy link that explained what the extension does with the data. Since my extension doesn&#8217;t store any information, I mentioned that in the privacy policy page.

The Firefox reviewer [gave me a link](https://blog.mozilla.org/addons/2016/07/15/writing-an-opt-in-ui-for-an-extension/) that had sample implementation. This was really helpful and I was able to make those changes very quickly. I submitted it again and this time, they approved within 4 hours.

For this stage, it is hard to pick a winner because both Chrome and Firefox did similar but since Firefox team asked me to include opt-in, it makes me think they value their users privacy more. So even though it took more time, I think Firefox wins this.

**Firefox 4 &#8211; 0 Chrome**.

## **6. Subsequent release**

I wanted to add few things so I had to make a few changes to the extensions. I created a new package with the changes and submitted them at the same time to both Firefox and Chrome web store.

This time it took less than 4 hours for Firefox to approve and it took more than 36 hours for Chrome to approve. I&#8217;m not sure if this was just a timing issue considering the Chrome team probably gets more submissions in a day. Since they both took around the same time for the first release, I&#8217;m going to call this a tie till I submit a few more times and have enough data.

**Tie. Firefox 4 &#8211; 0 Chrome.**

## **7. Final wrap up**

This feels so one sided at this point but in each stage there&#8217;s not really a huge difference. But Firefox add-on store edges Chrome web store in most of the stages for me.

Firefox add-on store wins 4-0 over Chrome web store.

## 8. **Tips if you are planning to develop an extension**

This is what I learned from building the extension and will take forward when I build extensions in the future:

1. Test the extension primarily with Firefox. It has so much better debugging and an easy way to load and unload extensions.
2. Add user opt-in along with privacy policy for your extension to avoid rejection the first time.
3. Create high quality screenshot images to avoid frustration with Chrome.
4. Be aware that it will cost you a one-time $5 registration fee for Chrome web store.
5. When you package the extension into a zip file, select all the individual files and folders and compress instead of compressing the parent project folder to avoid errors during Firefox package upload.

If you are planning to write your first extension, I would love to help you. Please reach out to me on Twitter: [@Ramkarthik](https://twitter.com/Ramkarthik/).

If you have some time, I would love to hear your thoughts on my app: [Open this URL](https://openthisurl.com/) You can get it for both [Chrome](https://chrome.google.com/webstore/detail/openthisurl/ebcejpedcchttps://chrome.google.com/webstore/detail/openthisurl/ebcejpedccgbmpnocggeomidamkoibbbgbmpnocggeomidamkoibbb/) and [Firefox](https://addons.mozilla.org/en-US/firefox/addon/openthisurl/).
