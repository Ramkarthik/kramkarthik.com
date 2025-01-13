import { AppConfig } from "@/utils/AppConfig";
import rss from "@astrojs/rss";
import { getCollection } from "astro:content";
import sanitizeHtml from "sanitize-html";
import MarkdownIt from "markdown-it";
import { ContentSchemaContainsSlugError } from "node_modules/astro/dist/core/errors/errors-data";
const parser = new MarkdownIt();

export async function GET() {
  const blog = await getCollection("essays");
  const notes = await getCollection("notes");
  const programming = await getCollection("programming");

  let allItems = blog.concat(notes).concat(programming);
  allItems.sort(function (a,b) { return new Date(b.data.createdDate) - new Date(a.data.createdDate)});
  
  return rss({
    title: "Ramkarthik Krishnamurthy",
    description: AppConfig.description,
    site: AppConfig.site,
    items: allItems.map((post) => ({
      title: post.data.title,
      pubDate: post.data.createdDate,
      description: post.data.summary,
      link: "/" + (post.collection == "essays" ? "" : post.collection) + `/${post.slug}/`,
      content: sanitizeHtml(parser.render(post.body), {
        allowedTags: sanitizeHtml.defaults.allowedTags.concat(["img"]),
      }),
    })),
  });
}
