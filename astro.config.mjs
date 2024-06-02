import { defineConfig } from "astro/config";
import sitemap from "@astrojs/sitemap";
import remarkCodeTitles from "remark-code-titles";

// https://astro.build/config
export default defineConfig({
  site: "https://kramkarthik.com",
  integrations: [sitemap()],
  markdown: {
    syntaxHighlight: "prism",
    remarkPlugins: [remarkCodeTitles],
  },
});
