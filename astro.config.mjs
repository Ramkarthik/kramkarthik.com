import { defineConfig } from "astro/config";
import sitemap from "@astrojs/sitemap";
import remarkCodeTitles from "remark-code-titles";
import mdx from '@astrojs/mdx';

// https://astro.build/config
export default defineConfig({
  site: "https://kramkarthik.com",
  integrations: [sitemap(), mdx()],
  markdown: {
    syntaxHighlight: "prism",
    remarkPlugins: [remarkCodeTitles],
  },
});
