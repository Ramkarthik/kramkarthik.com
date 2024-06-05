---
title: "Create an Astro blog from scratch"
createdDate: "2024-06-03"
modifiedDate: "2024-06-03"
tags: ["tutorial"]
garden: "budding"
summary: "This is the ultimate guide on how to create an Astro blog from scratch. By the end, you will have an Astro website and a blog ready to be deployed."
---

Astro is a web framework to create content-driven websites. It is allows you to build extremely fast website. It is perfectly for building blogs and we are going to do exactly that. We are going build an Astro blog from scratch.

You can find the complete code here: [https://github.com/Ramkarthik/astro-blog-tutorial](https://github.com/Ramkarthik/astro-blog-tutorial)

This is the blog we are building from scratch: [https://quick-astro-blog-tutorial.vercel.app/](https://quick-astro-blog-tutorial.vercel.app/)

We will be going over the steps below to build this blog:

0. Create an Astro project
1. Add some basic styling
2. Create a layout
3. Set up default website configurations
4. Create an about page
5. Create a Nav header
6. Create a folder to add the blog content (the easy route)
7. Use Content Collections for our blog
8. Setting up the dynamic routes for our blog
9. Getting Markdown content from collection entry
10. Create a blog listing page
11. Using our first Astro Integration to add SEO
12. Create an RSS feed for the blog
13. Add Sitemap and robots.txt file
14. Preparing for deployment
15. Next steps

Before we start, you want to make sure you have Node.js installed. Astro recommends using `v18.17.1` or `v20.3.0` or higher. ( `v19` is not supported.)

### 0. Create an Astro project

Open Terminal and navigate to the folder where you want to create the blog and run this command to create an Astro project:

```shell
npm create astro@latest
```

It will ask you a couple of questions:

```shell
1. Where should we create your new project? ./name-of-your-project
2. How would you like to start your new project? Empty (You can use the blog template here but this is to learn how to set up one from scratch, so we will choose the Empty template)
3. Do you plan to use TypeScript? Yes (You can choose no if you don't want to use TypeScript)
4. How strict should TypeScript be? Strict
5. Install dependencies? Yes
6. Initialize a new git repository? Yes
```

This will create the Astro project. Navigate into the folder to run the project. Open the project in your favorite editor.

```shell
cd name-of-your-project
npm run dev
```

Go to https://localhost:4321 and you will see the page displaying **Astro**. If you chose the blog template in step 2, you may see a different page.

Before we get started, let's add modify the `tsconfig.json` file a little bit to make things easier for referencing different components.

```json
{
  "compilerOptions": {
    "baseUrl": ".",
    "paths": {
      "@/*": ["./src/*"]
    }
  },
  "extends": "astro/tsconfigs/strict"
}
```

Let's get started.

### 1. Add some basic styling

We can write the CSS from scratch as well or use something like Tailwind. To keep things easier, we will use one of the many classless CSS. A classless CSS styles a page based on the HTML elements instead of using class names. We are using this to make it easier for us to style the HTML rendered using Markdown. The Astro Markdown render outputs a basic HTML and using a classless CSS, we don't have to worry too much about styling each element. Classless CSS are also lightweight so our blog will be extremely fast.

There are [many classless CSS options](https://github.com/dbohdan/classless-css). For this project (and my blog), I'm going to be using [Sakura](https://oxal.org/projects/sakura/). You can use any of those options.

1. Download the CSS file
2. Create a folder named `css` inside the `public` folder
3. Paste the file and rename it to `style.css`

Now go to `\src\index.astro` and add the CSS file to the end of the `<head>` tag.

```html
<link rel="stylesheet" href="/css/style.css" type="text/css" />
```

You should see the changes already. Without adding any classes, we can see that our page is already styled.

### 2. Create a layout

Layouts are basic templates that can be shared across different pages. We want the basic `html`, `head`, and `footer` elements to be available in each page. So let's create a base layout that will store these as a template.

1. Create a folder named `layouts` under the `src` folder (`\src\layouts`)
2. Create a file inside the layouts folder named `Base.astro` (`\src\layouts\Base.astro`)

The page we are seeing now comes from the `pages\index.astro` page. This is the default page or the entry point. We will be creating both the static pages (ex: `\about`) and the dynamic pages (ex: `\blog\my-first-post`) by create Astro pages inside the `pages` folder.

Now let's move all the code inside the `index.astro` page to the `Base.astro` page we created.

Go to `index.astro` and add the `Base.astro` layout.

```jsx:pages\index.astro
---
import Base from "@/layouts/Base.astro";
---
<Base />

```

You will notice a couple of things:

1. In Astro, you write JavaScript code within the `three dash separators`.
2. Similar to React, you can also write JavaScript alongside the HTML.

If you refresh the page now, you should not see any difference because we only moved the content from `index.astro` to `Base.astro` and referenced `Base.astro` from `index.astro`.

This bring us to a new concept in Astro... **Slots**. Astro uses `<slot/>` to inject the child components.

Let's go to `Base.astro`. Not every line of code there belongs in a template, mainly the `<h1>` tag. Replace that with `<slot />`.

Go to `index.astro`, add the `h1` tag within the `<Base>` tag.

```jsx:pages\index.astro
---
import Base from "@/layouts/Base.astro";
---
<Base>
    <h1>Astro</h1>
</Base>
```

Go to the browser and you will not see any changes. What we did is move the template code from `index.astro` into `Base.astro` and use the layout.

### 3. Set up default website configurations

We need some basic information about our website that we need to display in many places. We don't want to type them everywhere. We want to store these configurations in one place and refer to them wherever we need it so that if we want to make any change, we only have to change the configuration.

1. Create a folder named `utils` inside the `src` folder (`src\utils`)
2. Create a file named `AppConfig.ts` inside the `utils` folder (`AppConfig.js` if you don't want TypeScript)

```typescript:utils\AppConfig.ts
export const AppConfig = {
    author: "Author Name",
    title: "My personal website",
    description: "This is my personal website",
    image: "/images/social.png", // this will be used as the default social preview image
    twitter: "@handle",
    site: "https://yourwebsite.com/" // this is your website URL
}
```

Our website currently displays `Astro`. Let's change that to show our name from the config file we created. Let's also bring in the description and display that.

```jsx:pages\index.astro
---
import Base from "@/layouts/Base.astro";
import { AppConfig } from "@/utils/AppConfig";
---
<Base>
  <h1>{AppConfig.title}</h1>
  <p>{AppConfig.description}</p>
</Base>
```

### 4. Create an About page

Now that we have the home page, let's see how we can create a new page - in this case, an About (`https://localhost:4321/about`) page.

Astro uses file based routing. Let's see some examples:

```
src/pages/index.astro -> mysite.com/
src/pages/about.astro -> mysite.com/about
src/pages/about/index.astro  -> mysite.com/about
```

As you can see, there are two ways to create an About page. We will use the first approach and create a new file named `about.astro` inside the `pages` folder.

```jsx:pages\about.astro
---
import Base from "@/layouts/Base.astro";
---
<Base>
    <h1>About</h1>
</Base>
```

Go to `http://localhost:4321/about` and you should see the page we created.

### 5. Create a Nav header

We now have two pages, so we need a way to link to them from our home page as well as our other pages. We will do this by creating a nav header. Since we want this header to appear on all our pages, we will add it to the `Base.astro` layout page.

Instead of adding the code for the header directly to this file, we will create a separate component (`Nav.astro`). From the React docs:
"Components let you split the UI into independent, reusable pieces, and think about each piece in isolation."

We will store all the components inside a separate folder called `components` which we will create under the `src` folder (`src\components`).

1. Create a folder named `components` inside the `src` folder (`src\components`)
2. Create a file named `Nav.astro`

Let's display our name on the left and the navigation links on right.

```jsx:src\components\Nav.astro
---
import { AppConfig } from "@/utils/AppConfig";
---
<nav role="navigation">
  <a href="/">{AppConfig.author}</a>
  <div>
    <a href="/about">About</a>
  </div>
</nav>
```

We will style this in a minute. We only have two pages, so this approach is fine. But we will likely create more nav links like `blog`, `rss`, etc and there's a better way to manage that than adding a new line of code here with the name and the link.

Let's go back to our AppConfig.ts and add our list of pages.

```typescript:src\utils\AppConfig.ts
export const AppConfig = {
        author: "Author Name",
        title: "My personal website",
        description: "This is my personal website",
        image: "/images/social.png", // this will be used as the default social preview image
        twitter: "@handle",
        site: "https://yourwebsite.com/",// this is your website URL
        pages: [{
            name: "About",
            link: "/about"
        }]
    }
```

We can now modify the `Nav.astro` component to get the links from the `pages` array.

```jsx:src\components\Nav.astro
---
import { AppConfig } from "@/utils/AppConfig";
---

<nav role="navigation" class="justify-between">
  <a href="/">{AppConfig.author}</a>
  <div>
    {
      AppConfig.pages.map((p, index) => {
        return (
          <span>
            <a href={p.link}>
              <small>{p.name}</small>
            </a>
            {index != AppConfig.pages.length - 1 && <small>|</small>}
          </span>
        );
      })
    }
  </div>
</nav>
```

You might be familiar with this syntax of mapping an array and returning JSX, if you've used React before. One thing you may notice is the missing `key` property. Astro doesn't require a `key` property.

Also, notice the `class="justify-between"` added to the `<nav>` element. We will use this later to style the nav.

You won't see any changes on the website yet because we haven't added the `Nav.astro` component to our `Base.astro` layout. Let's do that now. We will add the `<Nav />` component just above the slot.

```jsx:src\layouts\Base.astro
---
import Nav from "@/components/Nav.astro";
---

<html lang="en">
  <head>
    <meta charset="utf-8" />
    <link rel="icon" type="image/svg+xml" href="/favicon.svg" />
    <meta name="viewport" content="width=device-width" />
    <meta name="generator" content={Astro.generator} />
    <title>Astro</title>
    <link rel="stylesheet" href="/css/style.css" type="text/css" />
  </head>
  <body>
    <Nav />
    <slot />
  </body>
</html>
```

If we go to `http://localhost:4321/`, we should now see the title and the navigation links. Let's style this so that the title is on the left and the nav links are on the right. Remember the `nav="class"` that we added to the `nav` element before. We will use that to style the nav.

Add this to the end of the `style.css` file:

```css:public\style.css
.justify-between {
  display: flex;
  justify-content: space-between;
}
```

Perfect, we have the header set up now. In case you don't see the changes, press `Ctrl+R` on the webpage to hard reload (disabling the cache). Let's move on to the blog (the interesting part).

### 6. Create a folder to add the blog content (the easy route)

We want to create a folder to store the contents of our blog. Each post will be a Markdown file. We will do the easy implement first and then change that to match our needs.

1. Create a folder named `blog` inside the `pages` folder (`pages\blog`)
2. Create a sample Markdown file inside the `blog` folder

I'm going to create a file named `my-first-post.md`:

```markdown:src\pages\blog\my-first-post.md
---
title: My first post
createdDate: "2024-05-18"
modifiedDate: "2024-05-18"
tags: ["first-tag"]
summary: "A summary of the post"
---

This is my first blog post written in Markdown.

```

The content within the `three dashed separator` `---` is called **frontmatter**. We will later use the information from the frontmatter to display in our page.

Now go to the URL: `http://localhost:4321/blog/my-first-post` and you should see a very basic version of your blog post content. You will not see the title yet and that's where frontmatter comes into play.

### 7. Use Content Collections for our blog

Currently, we have the blog content inside the `pages` folder. We want to keep the `pages` folder for code and move our blog content to a separate folder so that we have separation of concerns and it is also easier to manage it this way.

Astro provides an API called `Content Collections` starting from `astro@2.0.0`. To use this feature, we have to create folder named `content` inside the `src` folder. This `content` folder is restricted for content collections and should not be used for anything else.

So let's go ahead and move our blog folder from `src\pages` to `src\content`. If you followed the steps so far, your project folder should look like this:

```
.astro
node_modules
public
	css
		style.css
	favico.svg
src
	components
		Nav.astro
	content
		blog
			my-first-post.md
	layouts
		Base.astro
	pages
		about.astro
		index.astro
	utils
		AppConfig.ts
	env.t.ds
.gitignore
astro.config.mjs
package-lock.json
package.json
README.md
tsconfig.json
```

Now the URL `http://localhost:4321/blog/my-first-post` will not work because we have moved the `blog` folder within the `content` folder.

### 8. Setting up the dynamic routes for our blog

We want the URL `http://localhost:4321/blog/my-first-post` to work again. We can see that we have the `\blog` route which means we have to create a folder named `blog` inside the `pages` folder.

Once we create the folder, we need set up a way to handle the dynamic part of the URL, called the `slug`. In our case, the slug is `my-first-post`. But for each post, this will change.

Let's create a file named `[slug].astro` inside the `blog` folder (`src\content\blog\[slug].astro`).

For the dynamic paths to work, we need to let Astro know of the different possible paths. We do this by implementing the `getStaticPaths` function. For us to know the different paths available, we have to get each file inside the `content` folder and return the `slug`. We do this using the `getCollection` API provided by Astro via the `astro:content` module that is built-in.

The `getCollection` API works only with folders inside the `content` folder. We get the posts inside the `blog` folder, map through each item, and return the `slug` as a parameter and also the contents of each item as props. Astro has a nifty way to retrieve the props through `Astro.props`.

While we are on this file, let's add some basic HTML as well. We will use the `Base.astro` layout we created.

```jsx:src/pages/blog/[slug].astro
---
import { getCollection } from "astro:content";

export async function getStaticPaths() {
  const posts = await getCollection("blog");
  return posts.map((post) => ({
    params: { slug: post.slug },
    props: {
      post,
    },
  }));
}
---

<Base>
  <h1>Title</h1>
</Base>
```

Go to `http://localhost:4321/blog/my-first-post` and it should now work. We have successfully migrated to the `Content Collections` API.

But wait, where's the content of the post we saw earlier? We have to bring those in from `Astro.props`.

Remember the frontmatter we added to our post? Let's first define a schema so that we get type safety. We need it when we get the values from `Astro.props`.

Create a file named `config.ts` under the `content` folder (don't add it inside the `blog` folder).

```typescript:src\content\config.ts
import { z, defineCollection } from 'astro:content';

const blogCollection = defineCollection({
  type: 'content',
  schema: z.object({
    title: z.string(),
    summary: z.string(),
    tags: z.array(z.string()),
    createdDate: z.string(),
    modifiedDate: z.string(),
  }),
});

export const collections = {
  'blog': blogCollection,
};
```

Once we define the schema, we have to let Astro know to generate the types. We can do that either by stopping the server (`Ctrl+C`) or by running `npm run astro sync`.

Now let's edit the `[slug].astro` file to display the blog post title. For this, we have to extract the title from Astro.props and add this to the existing `<h1>` tag.

```jsx:src/pages/blog/[slug].astro
---
import { getCollection } from "astro:content";
import Base from "@/layouts/Base.astro";

export async function getStaticPaths() {
  const posts = await getCollection("blog");
  return posts.map((post) => ({
    params: { slug: post.slug },
    props: {
      post,
    },
  }));
}

const { post } = Astro.props;
const { title, summary, createdDate, tags } = post.data;
---
<Base>
  <h1>{title}</h1>
</Base>
```

Now when you go to `http://localhost:4321/blog/my-first-post`, you should see the title from the frontmatter of the post appear.

What about the content?

### 9. Getting Markdown content from collection entry

We are writing our posts in Markdown. We want Astro to generate HTML for the markdown and display that. We do this by first using the `render()` function Astro provides and then adding that to the HTML block.

```jsx:src/pages/blog/[slug].astro
---
import { getCollection } from "astro:content";
import Base from "@/layouts/Base.astro";

export async function getStaticPaths() {
  const posts = await getCollection("blog");
  return posts.map((post) => ({
    params: { slug: post.slug },
    props: {
      post,
    },
  }));
}

const { post } = Astro.props;
const { title, summary, createdDate, tags } = post.data;
const { Content } = await post.render();
---

<Base>
  <h1>{title}</h1>
  <Content />
</Base>
```

We call the `render()` function on the `post` object, store it as `Content`, and then add that to the HTML as `<Content />`.

You should now see the blog post content when you go to `http://localhost:4321/blog/my-first-post`. Let's add some random markdown to the `my-first-post.md` file to see how the Markdown is displayed on the page (styled using the Sakura classless CSS we added). You can copy and paste random markdown using [Lorem Markdownum](https://jaspervdj.be/lorem-markdownum/).

We also want to display the tags and the created date. Let's bring those in as well from the `props` and add that to the HTML.

```jsx:src/pages/blog/[slug].astro
---
import { getCollection } from "astro:content";
import Base from "@/layouts/Base.astro";

export async function getStaticPaths() {
  const posts = await getCollection("blog");
  return posts.map((post) => ({
    params: { slug: post.slug },
    props: {
      post,
    },
  }));
}

const { post } = Astro.props;
const { title, summary, createdDate, tags } = post.data;
const { Content } = await post.render();
---

<Base>
  <h1>{title}</h1>
  <div class="justify-between">
    <div>
      {
        tags.map((t) => {
          return (
            <small>
              <i>#{t}</i>
            </small>
          );
        })
      }
    </div>
    <small>{createdDate}</small>
  </div>
  <hr />
  <Content />
</Base>
```

Let's add more posts to play around with. Go to the `blog` folder and create more files. For this example, we will create `my-second-post.md` and `my-third-post.md` with the same content as `my-first-post.md` and change only the `frontmatter` details like `title`, `summary`, `createdDate`, and `tags`.

With that, you should now be able to access the following URLs:
`http://localhost:4321/blog/my-first-post`
`http://localhost:4321/blog/my-second-post`
`http://localhost:4321/blog/my-third-post`

Great! But we now need a blog listing page where readers can find all the blog posts as a list.

### 10. Create a blog listing page

We want the listing page to be available at `/blog` which means, you guessed it, we have to add either a `blog.astro` find directly inside the `pages` folder or add a `index.astro` page inside the `pages\blog` folder. We will do the latter. We will also bring in the `Base.astro` layout (see how we are reusing the layout?).

```jsx:src\pages\blog\index.astro
---
import Base from "@/layouts/Base.astro";
---

<Base>
    <h1>Posts</h1>
</Base>
```

If you navigate to `http://localhost:4321/blog`, you should see the blog listing page. Now we want to list the blog posts here.

We will use the `getCollection()` function to get the list of posts from the `blog` folder and then map over each item to display them. We will also sort the posts based on the `createdDate` we have defined in the frontmatter.

```jsx:src\pages\blog\index.astro
---
import { getCollection } from "astro:content";
import Base from "@/layouts/Base.astro";

const posts = await getCollection("blog");
const sortedPosts = posts.sort((a, b) => {
  return +new Date(b.data.createdDate) - +new Date(a.data.createdDate);
});
---

<Base>
  <h1>Posts</h1>
  <ul>
    {
      sortedPosts.map((p) => {
        return (
          <li>
            <a href={"/blog/" + p.slug}>{p.data.title}</a>
          </li>
        );
      })
    }
  </ul>
</Base>
```

We can also do this for the home page and list the five most recent blog posts by editing the `src\pages\index.astro` file.

```jsx:src\pages\index.astro
---
import { getCollection } from "astro:content";
import Base from "@/layouts/Base.astro";
import { AppConfig } from "@/utils/AppConfig";

const posts = await getCollection("blog");

const sortedPosts = posts.sort((a, b) => {
  return +new Date(b.data.createdDate) - +new Date(a.data.createdDate);
});
---

<Base>
  <h1>{AppConfig.title}</h1>
  <p>{AppConfig.description}</p>
  <h3>Posts</h3>
  <ul>
    {
      sortedPosts.slice(0, 5).map((p) => {
        return (
          <li>
            <a href={"/blog/" + p.slug}>{p.data.title}</a>
          </li>
        );
      })
    }
  </ul>
  <a href="/blog">Click here</a> to view the archive.
</Base>
```

Let's add some links for easy navigation.

First, we will add a link for our blog listing page to the header. Since the links in the header comes from the `pages` property in `AppConfig.ts` file, we will add a link to the blog listing page to the `pages` array.

```typescript:src\utils\AppConfig.ts
export const AppConfig = {
        author: "Author Name",
        title: "My personal website",
        description: "This is my personal website",
        image: "/images/social.png", // this will be used as the default social preview image
        twitter: "@handle",
        site: "https://yourwebsite.com/", // this is your website URL
        pages: [{
            name: "Blog",
            link: "/blog"
        },{
            name: "About",
            link: "/about"
        }]

    }
```

We will also add links to previous post and next post (if available) to the end of the blog post. To do this, we will retrieve the list of blog posts using the `getCollection()` function, sort the posts, find the index of the current post in the sorted list and then identify the previous and next post to display in the HTML. We do this by editing the `[slug].astro` file.

```jsx:src/pages/blog/[slug].astro
---
import { getCollection } from "astro:content";
import Base from "@/layouts/Base.astro";

export async function getStaticPaths() {
  const posts = await getCollection("blog");
  return posts.map((post) => ({
    params: { slug: post.slug },
    props: {
      post,
    },
  }));
}

const { post } = Astro.props;
const { title, summary, createdDate, tags } = post.data;
const { Content } = await post.render();
const posts = await getCollection("blog");

const sortedPosts = posts.sort((a, b) => {
  return +new Date(b.data.createdDate) - +new Date(a.data.createdDate);
});

const index = sortedPosts.findIndex((c: any) => {
  return c.slug == post.slug;
});

const prev = index == 0 ? undefined : sortedPosts[index - 1];
const next =
  index == sortedPosts.length - 1 ? undefined : sortedPosts[index + 1];
---

<Base>
  <h1>{title}</h1>
  <div class="justify-between">
    <div>
      {
        tags.map((t) => {
          return (
            <small>
              <i>#{t}</i>
            </small>
          );
        })
      }
    </div>
    <small>{createdDate}</small>
  </div>
  <hr />
  <Content />
  <hr />
  <div class="justify-between">
    {
      prev && (
        <a href={`/blog/${prev.slug}`}>
          <small>&larr; {prev.data.title}</small>
        </a>
      )
    }
    {
      next && (
        <a href={`/blog/${next.slug}`}>
          <small>{next.data.title} &rarr;</small>
        </a>
      )
    }
  </div>
</Base>
```

We should now have navigations links at the end of the blog post. You can verify that by going to `http://localhost:4321/blog/my-second-post`.

You may have noticed that the browser tab title always says Astro. We want this to be dynamic based on the page we are on. Introducing you to the world of **Astro Integrations**.

### 11. Using our first Astro Integration to add SEO

Astro provides ability for us to use plugins either offered directly by Astro or created by the community to build things faster through Astro Integrations. We will use the `astro-seo` integration to:

1. Fixing the title
2. Add SEO to our page (we want the search engines to find our website)
3. Add social tags (so our links will look when shared on Facebook, Twitter, etc.)

Install `astro-seo` by running the following command:

```shell
npm install astro-seo
```

We are going to import `SEO` from the `astro-seo` integration. This component expects a few props like title, description, OG info, Twitter info, etc.

Since we want to use the information corresponding to each page, we are going to define the props for our `Head.astro` component. We are also creating an interface to get type safety.

Let's create the interface first. We will create a file named `types.ts` inside the `utils` folder (`src\utils\types.ts`).

```typescript:src\utils\types.ts
export interface HeadProps {
    props: {
      title: string;
      description: string;
      image?: string | undefined;
    };
  }
```

Let's create a component named `Head.astro` inside the `components` folder (`src\components\Head.astro`) with the following content.

```jsx:src\components\Head.astro
---
import { SEO } from "astro-seo";
import { AppConfig } from "@/utils/AppConfig";
import { type HeadProps } from "@/utils/types";

const {
  props: { title, description, image },
} = Astro.props as Props;
---

<SEO
  title={title || AppConfig.title}
  description={description || AppConfig.description}
  openGraph={{
    basic: {
      title: title || AppConfig.title,
      type: description || AppConfig.description,
      image: AppConfig.site + (image || AppConfig.image || ""),
    },
  }}
  twitter={{
    creator: AppConfig.twitter,
  }}
  extend={{
    link: [{ rel: "icon", href: "/favicon.svg" }],
    meta: [
      {
        name: "twitter:image",
        content: AppConfig.site + (image || AppConfig.image || ""),
      },
      { name: "twitter:title", content: title || AppConfig.title },
      {
        name: "twitter:description",
        content: description || AppConfig.description,
      },
    ],
  }}
/>
```

Now that we have the `Head.astro` component created, we want to add this to our `Base.astro` layout page so that we will have the SEO feature applied to all the pages.

We will remove the existing `<title>` tag from the `Base.astro` file and add the `<Head />` component we just created. You will immediately see an error because we have to pass the mandatory props to the `<Head>` component.

Again, instead of passing the values directly from the `<Base>` layout, we will define a prop for the layout of type `HeadProps` that we created before and have the pages that use the layout pass this information to it.

```jsx:src\layouts\Base.astro
---
import Head, { type HeadProps } from "@/components/Head.astro";
import Nav from "@/components/Nav.astro";

const {
  props: { title, description, image },
} = Astro.props as HeadProps;
---

<html lang="en">
  <head>
    <meta charset="utf-8" />
    <link rel="icon" type="image/svg+xml" href="/favicon.svg" />
    <meta name="viewport" content="width=device-width" />
    <meta name="generator" content={Astro.generator} />
    <link rel="stylesheet" href="/css/style.css" type="text/css" />
    <Head props={{ title, description, image }} />
  </head>
  <body>
    <Nav />
    <slot />
  </body>
</html>
```

You will get a errors in every file that uses the `Base.astro` file because we are not providing the value for the props. Let's do that for each page.

First, let's update the `src\pages\index.astro` (homepage). For this, we will page the values from the `AppConfig.ts` file.

```jsx:src\pages\index.astro
---
import { getCollection } from "astro:content";
import Base from "@/layouts/Base.astro";
import { AppConfig } from "@/utils/AppConfig";

const posts = await getCollection("blog");

const sortedPosts = posts.sort((a, b) => {
  return +new Date(b.data.createdDate) - +new Date(a.data.createdDate);
});
---

<Base
  props={{
    title: AppConfig.title,
    description: AppConfig.description,
    image: AppConfig.image,
  }}
>
  <h1>{AppConfig.title}</h1>
  <p>{AppConfig.description}</p>
  <h3>Posts</h3>
  <ul>
    {
      sortedPosts.slice(0, 5).map((p) => {
        return (
          <li>
            <a href={"/blog/" + p.slug}>{p.data.title}</a>
          </li>
        );
      })
    }
  </ul>
  <a href="/blog">Click here</a> to view the archive.
</Base>
```

Next, let's fix the blog listing page `src\pages\blog\index.astro`.

```jsx:src\pages\blog\index.astro
---
import { getCollection } from "astro:content";
import Base from "@/layouts/Base.astro";
import { AppConfig } from "@/utils/AppConfig";

const posts = await getCollection("blog");

const sortedPosts = posts.sort((a, b) => {
  return +new Date(b.data.createdDate) - +new Date(a.data.createdDate);
});
---

<Base
  props={{
    title: "My collection of essays",
    description: AppConfig.description,
    image: AppConfig.image,
  }}
>
  <h1>Posts</h1>
  <ul>
    {
      sortedPosts.map((p) => {
        return (
          <li>
            <a href={"/blog/" + p.slug}>{p.data.title}</a>
          </li>
        );
      })
    }
  </ul>
</Base>
```

Let's fix the `About` page.

```jsx:src\pages\about.astro
---
import Base from "@/layouts/Base.astro";
import { AppConfig } from "@/utils/AppConfig";
---

<Base
  props={{
    title: "About | " + AppConfig.author,
    description: AppConfig.description,
    image: AppConfig.image,
  }}
>
  <h1>About</h1>
</Base>
```

Finally, we will fix the blog slug file `src\pages\blog\[slug].astro`.

```jsx:src/pages/blog/[slug].astro
---
import { getCollection } from "astro:content";
import Base from "@/layouts/Base.astro";
import { AppConfig } from "@/utils/AppConfig";

export async function getStaticPaths() {
  const posts = await getCollection("blog");
  return posts.map((post) => ({
    params: { slug: post.slug },
    props: {
      post,
    },
  }));
}

const { post } = Astro.props;
const { title, summary, createdDate, tags } = post.data;
const { Content } = await post.render();
const posts = await getCollection("blog");

const sortedPosts = posts.sort((a, b) => {
  return +new Date(b.data.createdDate) - +new Date(a.data.createdDate);
});

const index = sortedPosts.findIndex((c: any) => {
  return c.slug == post.slug;
});

const prev = index == 0 ? undefined : sortedPosts[index - 1];
const next =
  index == sortedPosts.length - 1 ? undefined : sortedPosts[index + 1];
---

<Base props={{ title: title, description: summary, image: AppConfig.image }}>
  <h1>{title}</h1>
  <div class="justify-between">
    <div>
      {
        tags.map((t) => {
          return (
            <small>
              <i>#{t}</i>
            </small>
          );
        })
      }
    </div>
    <small>{createdDate}</small>
  </div>
  <hr />
  <Content />
  <hr />
  <div class="justify-between">
    {
      prev && (
        <a href={`/blog/${prev.slug}`}>
          <small>&larr; {prev.data.title}</small>
        </a>
      )
    }
    {
      next && (
        <a href={`/blog/${next.slug}`}>
          <small>{next.data.title} &rarr;</small>
        </a>
      )
    }
  </div>
</Base>
```

Alright, we have fixed pretty much everything. The final thing related to SEO that we need to fix is the social image. We are using the value of `image` property from the `AppConfig.ts` file everywhere but we don't have that image. You can add the image you want to display as preview when sharing links. I usually take a screenshot of the homepage and use that. Once you choose the image, add it to `public\images\` with the name `social.png` since that's the value of `AppConfig.image`.

Alright, we are almost there setting up the blog. There are a couple more things we need for the blog to be complete.

### 12. Create an RSS feed for the blog

We have a blog but we need an RSS feed so that people can subscribe to our blog (yes, people still subscribe to blogs).

We will use another Astro integration for this called `@astro/rss`. Let's install it using the below command:

```shell
npm install @astrojs/rss
```

Let's create a file named `rss.xml.js` inside the `pages` folder (`src\pages\rss.xml.js`) with the following content.

```javascript:src\pages\rss.xml.js
import { AppConfig } from "@/utils/AppConfig";
import rss from "@astrojs/rss";
import { getCollection } from "astro:content";

export async function GET() {
  const blog = await getCollection("blog");

  return rss({
    title: AppConfig.title,
    description: AppConfig.description,
    site: AppConfig.site,
    items: blog.map((post) => ({
      title: post.data.title,
      pubDate: post.data.createdDate,
      description: post.data.summary,
      link: `/blog/${post.slug}/`,
    })),
  });
}
```

We should also add a `<link>` to our `Base.astro` file that allows browsers and other apps to auto discover the RSS feed from our website.

Let's add the below line to the `Base.astro` file just above the `</head>` tag.

```html
<link
  rel="alternate"
  type="application/rss+xml"
  title="{AppConfig.title}"
  href="{`${AppConfig.site}rss.xml`}"
/>
```

We also have to create a sitemap and a robots.txt file so that search engines can crawl our website.

### 13. Add Sitemap and robots.txt file

We will use another Astro integration called `sitemap`. Instead of running `npm install`, we will run the below command which will both install the integration as well as auto configure the sitemap for us.

```shell
npx astro add sitemap
```

We have to add our website URL to `astro.config.mjs` file.

```javascript:astro.config.mjs
import { defineConfig } from "astro/config";
import sitemap from "@astrojs/sitemap";

// https://astro.build/config
export default defineConfig({
  site: "https://yourwebsite.com",
  integrations: [sitemap()],
});
```

You can verify that the `sitemap-index.xml` file gets generated by running `npm run build` and then going to the `dist` folder created in the root of your project.

Similar to how we added a `<link>` to the RSS feed to the `Base.astro` layout file, we have to do the same for the `sitemap-index.xml` file. Let's add the below line to the `src\layouts\Base.astro` file just above the `</head>` tag.

```html
<link rel="sitemap" href="/sitemap-index.xml" />
```

Finally, let's create a `robots.txt` file inside the `public` folder (`public\robots.txt`) with the below content.

```text
User-agent: *
Allow: /

Sitemap: https://<YOUR SITE>/sitemap-index.xml
```

Congrats! If you followed the tutorial till now, you have a fully functional blog.

### 14. Preparing for deployment

We have a few dummy values that we need to change before we deploy this blog.

1. Update the `AppConfig.ts` file with the right information
2. Update the dummy URL in `astro.config.mjs` file
3. Delete the dummy Markdown files from the `content\blog` folder and add your blog posts. Don't forget to add the necessary frontmatter to each post.
4. Update the social image with the image you would like `public\images\social.png`
5. Update the `src\pages\about.astro` page with details about you

Once you've made these changes, you can deploy to one of the many services that provide free hosting for static website.

1. [Vercel](https://vercel.com/) - [Deploy your Astro Site to Vercel | Docs](https://docs.astro.build/en/guides/deploy/vercel/)
2. [Cloudflare](https://www.cloudflare.com/) - [Astro · Cloudflare Pages docs](https://developers.cloudflare.com/pages/framework-guides/deploy-an-astro-site/)
3. [Netlify](https://www.netlify.com/) - [Astro on Netlify | Netlify Docs](https://docs.netlify.com/frameworks/astro/)

### 15. Next steps

You have a proper blog in place right now. There are few things you can add to this to make it better.

1. Create a `src\components\footer.astro` component and add it to the `Base.astro` layout to make it part of every page
2. Add a `src\pages\now.astro` page to tell your readers about what you are doing now (following [The /now page movement | Derek Sivers](https://sive.rs/nowff))
3. Add analytics to your website (for ex: [GoatCounter – open source web analytics](https://www.goatcounter.com/))
4. Add separate collection for `notes` where you can write short notes instead of long blog posts and make it available as part of `\notes` URL similar to `\blog`

Happy coding and happy writing!
