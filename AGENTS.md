# Agent guide

This repo is a Next.js app backed by Supabase Auth, versioned SQL migrations, and edge functions. A push to `main` applies migrations and deploys every function in the repo.

## This is NOT the Next.js you know

This version has breaking changes — APIs, conventions, and file structure may all differ from your training data. Read the relevant guide in `node_modules/next/dist/docs/` (resolved from this file's directory; in monorepos the `next` package may not be visible from the repo root) before writing any code. Heed deprecation notices.

This block is written and re-added by `next dev` — verify at `node_modules/next/dist/server/lib/generate-agent-files.js`. Removing it from a diff only re-creates the uncommitted change; committing it with your work keeps the tree clean.

## Supabase

Use the clients in `lib/supabase/`. `client.ts` is for the browser. `server.ts` is for Server Components, Route Handlers, and Server Actions; create a new client inside each function. `proxy.ts` refreshes the session on each matched request. Bias towards server when possible, for security reasons.

The app reads `NEXT_PUBLIC_SUPABASE_URL` and `NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY` from `.env.local`. Leave the GitHub Actions secrets (`SUPABASE_ACCESS_TOKEN`, `SUPABASE_PROJECT_ID`, `SUPABASE_DB_PASSWORD`) in the repo settings.

Schema changes belong in a new file from `supabase migration new <name>`. `public.profiles` is created by the existing migration and is readable and updatable only by the signed-in user. Put privileged functions in the `private` schema. Enable RLS on tables exposed through the Data API, and keep authorization data out of `raw_user_meta_data`.

## Edge functions and CI

You should NEVER deploy any edge functions or push migrations. This is handled by the pipelines.

Add a function with `supabase functions new <name>` and commit `supabase/functions/<name>`. `.github/workflows/deploy-functions.yml` deploys with `--prune`, so removing a function folder removes it from the hosted project on the next push to `main`. `.github/workflows/supabase-migrations.yml` runs `supabase db push` for the linked project.
