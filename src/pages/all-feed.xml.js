import { AppConfig } from "@/utils/AppConfig";
import rss from "@astrojs/rss";
import { getCollection } from "astro:content";
import sanitizeHtml from "sanitize-html";
import MarkdownIt from "markdown-it";

const parser = new MarkdownIt();

export async function GET() {
  const posts = await getCollection("posts");

  posts.sort(function (a, b) {
    return new Date(b.data.createdDate) - new Date(a.data.createdDate);
  });

  return rss({
    title: "Ramkarthik Krishnamurthy",
    description: AppConfig.description,
    site: AppConfig.site,
    items: posts.map((post) => {
      const category = post.data.category;
      const link =
        category === "essays" ? `/${post.slug}/` : `/${category}/${post.slug}/`;

      return {
        title: post.data.title,
        pubDate: post.data.createdDate,
        description: post.data.summary,
        link: link,
        content: sanitizeHtml(parser.render(post.body), {
          allowedTags: sanitizeHtml.defaults.allowedTags.concat(["img"]),
        }),
      };
    }),
  });
}

