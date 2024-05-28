import { AppConfig } from "@/utils/AppConfig";
import rss from "@astrojs/rss";
import { getCollection } from "astro:content";
import sanitizeHtml from "sanitize-html";
import MarkdownIt from "markdown-it";
const parser = new MarkdownIt();

export async function GET() {
  const blog = await getCollection("notes");
  return rss({
    title: "Ramkarthik Krishnamurthy's Notes",
    description: AppConfig.description,
    site: AppConfig.site,
    items: blog.map((post) => ({
      title: post.data.title,
      pubDate: post.data.createdDate,
      description: post.data.summary,
      link: `/notes/${post.slug}/`,
      content: sanitizeHtml(parser.render(post.body), {
        allowedTags: sanitizeHtml.defaults.allowedTags.concat(["img"]),
      }),
    })),
  });
}
