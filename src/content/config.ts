import { z, defineCollection } from 'astro:content';

const postCollection = defineCollection({
  type: 'content',
  schema: z.object({
    title: z.string(),
    summary: z.string(),
    tags: z.array(z.string()),
    garden: z.enum(["seedling", "budding", "evergreen"]),
    createdDate: z.string(),
    modifiedDate: z.string(),
    category: z.enum(["essays", "notes", "programming", "lists"]),
  }),
});

export const collections = {
  'posts': postCollection,
};