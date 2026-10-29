# Supabase + Next.js Pro setup

This repo aims to take [Vercel's excellent template repo](https://github.com/vercel/next.js/tree/canary/examples/with-supabase) as a starting point and improve it to make it a fully production ready system for ongoing development.

This repo is my recommended setup for Next.js + Supabase with versioned migrations and edge functions. Pushing to `main` runs two GitHub Actions: one applies the SQL migrations, and one deploys the edge functions.

## Getting Started

This repo is enabled as a template. Just use the "use template" option to get a copy of the repo under your GitHub account, either public or private.

1. Create your Supabase project [here](https://supabase.com/dashboard).
2. Once created, copy the .env values from the connect tab under NextJS in the [Supabase dashboard](https://supabase.com/dashboard/project/_?showConnect=true). Copy the `.env.example` file to `.env.local`, and paste the contents in there. `.env.local` is not tracked in git.

The app reads `NEXT_PUBLIC_SUPABASE_URL` and `NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY`.

3. Install dependencies and start the app:

   ```bash
   npm install
   npm run dev
   ```

4. Create an access token for this project in your [Supabase account settings](https://supabase.com/dashboard/account/tokens). Scope it to this project only for security reasons.

The migrations workflow runs `supabase link` before it pushes, so the token needs Project Settings, API Keys, and API Key Secrets, all with Read. Edge function deploys need Edge Functions with Read-write as well, because the workflow can delete functions that are no longer in the repo. Permission names are the ones on that token screen. See [Personal access tokens](https://supabase.com/docs/guides/platform/personal-access-tokens).

5. Add these secrets on the GitHub repo so the workflows can run:

- `SUPABASE_ACCESS_TOKEN`, the token from the step above
- `SUPABASE_PROJECT_ID`, the project ref in `https://supabase.com/dashboard/project/<project-ref>`. You can also find it in the [General settings](https://supabase.com/dashboard/project/_/settings/general)
- `SUPABASE_DB_PASSWORD`, the database password from [Database settings](https://supabase.com/dashboard/project/_/settings/database). Only the migrations workflow uses this.

## How To Use

There are two things already set up in the Supabase directory. A migration file, and an edge functions directory. These are designed to show how the setup works.

The migration file creates a table for user profiles linked to the inbuilt auth schema, and a function and trigger to create new profile rows automatically when a new user is added.

Add the next change with `supabase migration new <name>`, commit it, and merging to `main` will automatically run a pipeline that pushes it to your Supabase project with `supabase db push`. Once you are using migrations, make schema changes in migration files. Edits in the dashboard SQL editor skip that history, and a later push will fail until the two are back in sync. Supabase's [database migrations](https://supabase.com/docs/guides/deployment/database-migrations) guide covers that.

The edge function in `supabase/functions/hello-world` is a small example. It expects a JSON body like `{ "name": "Functions" }` and answers with a hello message. Add another with `supabase functions new <name>` and commit the folder. The next push to `main` deploys every function in the repo. The workflow passes `--prune --yes`, which deletes hosted functions that no longer have a folder in the repo.

Both pipeline files can be accessed and edited via the .github/workflows folder.

To try the database locally, install the [Supabase CLI](https://supabase.com/docs/guides/local-development/cli/getting-started), then run `supabase start` and `supabase db reset` from this repo.

## Deployment to Vercel

The last step for the project to be ready to deploy is the auth configuration on Supabase. Email confirmation and password reset need your app URLs allowed to be allowed in [URL configuration](https://supabase.com/dashboard/project/_/auth/url-configuration). Add `http://localhost:3000/**`, your production URL, and `https://*-.vercel.app/**` for preview deploys. Supabase documents that pattern in [Redirect URLs](https://supabase.com/docs/guides/auth/redirect-urls#vercel-preview-urls). Migrations and functions still go out from GitHub Actions on `main`.

## More from me

If you want to see more of what I'm working on:

- [X](https://x.com/CamBlackwood95)
- [GitHub](https://github.com/Reikon95)
- [LinkedIn](https://www.linkedin.com/in/cameron-blackwood/)
- [Blog](https://www.cameronblackwood.xyz/blog)
