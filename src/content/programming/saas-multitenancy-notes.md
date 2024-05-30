---
title: "Notes on SaaS Multitenancy"
createdDate: "2024-05-30"
modifiedDate: "2024-05-30"
tags: ["saas"]
garden: "seedling"
summary: "Multitenancy is hard. It is best to start a project with multitenancy than add it later. These are some notes on SaaS multitenancy."
---

These are notes based on the article: [Ultimate guide to multi-tenant SaaS data modeling](https://www.flightcontrol.dev/blog/ultimate-guide-to-multi-tenant-saas-data-modeling)

The top most level is `organization` (since it is naming, it can be called other things but will be referred to as organization in this case - which also makes sense for users).

### Three models

- GitHub: Each person has one account that can belong to one or more organizations
- Google: Each person has a unique account for each organization
- Linear: Each person can have one or more accounts and each account can belong to one or more organizations

### Data modeling:

- Every table except the `users` table should have `organization_id` which is a foreign key reference to the `organization` table
- The mapping table between the `users` table and the `organization` table is the `Membership` table
- Since every table will be first queries on `organization_id`, create an index on this column
- (Optional) Make the primary key for each table a combination of `organization_id` and `table_id` (organization_id, table_id). This will help if we want to clone an organization's data into a sandbox environment for testing.
- Assign items to the user's membership instead of the user directly.
- Require `organization_id` everywhere - in the URLs (ex: `/org/[orgId]/projects/[projectId]`), query inputs, database calls, etc.

### User login sessions

Three implementations with varying degrees of complexity and challenges it solves.

1. **Basic**
   - Store `organization_id` in the session
   - Assuming a user has access to org1 and org2 and they are only logged into org1, if they try to access org2, they will not be able to access org2
2. **Mid**
   - Store all the organization a user has access to along with the role for each organization in the user session: `accessibleOrgs: Array<{orgId: string, role: string}>`
   - If a user is revoked or their role changes, update all the user's sessions
   - The problem with this implementation is that one of the orgs the user belongs to might require a particular way of auth (ex: Google or SSO). In this case, we cannot automatically allow access to the user for this auth when they logged in using, say, email/password
3. **Ultimate**
   - Store two things in the user session:
     - `accessibleOrgs: Array<{orgId: string, role: string}>` - synced across all user sessions
     - `loggedInOrgsOnThisDevice: Array<{orgId: string}>` - not synced across all user sessions
   - Set `accessibleOrganizations` to the list of all their org memberships
   - Set `loggedInOrgsOnThisDevice` to the same as `accessibleOrganizations` but filtered by orgs that permit access with the login method (like email/password vs Google)
   - User will log into other orgs by clicking on the "Sign into organization" from the org switcher
   - Once they sign in using the other org's preferred scheme, add the new org id to `accessibleOrganizations`, if it’s not already there, and to `loggedInOrgsOnThisDevice`

### User sign up flow

1. Direct signup
   - Create `organization` and `membership`
   - Create `user`
   - Add `user` to `membership`
2. Invitation
   - Create `membership` record with `invitationId`, `invitationExpiresAt`, and `invitedEmail`
   - `membership.userId` will be `null`
   - Create a link with the `invitationId`
   - When user signs up, check if the `invitationId` matches the `membership` to create the `user` and attach it to the `membership`

### Role-based access controls

- Store the `role` in user session to avoid API calls
- Maintain a list of permissions for each role
- Check if user has access to perform the query or mutation based on the role

### Billing

- Store the billing information at `organization` level (ex: `billingEmail`, `stripeCustomerId`, etc)
- An `organization` can have multiple `subscriptions`
- For usage based billing, calculate the count of items that belong to that `organization`

### Settings

Three types of settings:

1. Organization settings - Store it on the `organization` table
2. User settings at org level (ex: notifications) - Store it on the `membership` table
3. User settings at global level (ex: dark mode) - Store it on the `user` table

This post is basically notes from reading the [Ultimate guide to multi-tenant SaaS data modeling](https://www.flightcontrol.dev/blog/ultimate-guide-to-multi-tenant-saas-data-modeling) article.

The article further references:

- [Teams should be an MVP feature!](https://blog.bullettrain.co/teams-should-be-an-mvp-feature/)
- [Multitenancy - Blitz.js](https://blitzjs.com/docs/multitenancy)
- [Multi-tenant SaaS model with PostgreSQL, Mongo or DynamoDB?](https://www.checklyhq.com/blog/building-a-multi-tenant-saas-data-model/)
