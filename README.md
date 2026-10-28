# Supabase + NextJS Pro setup

This repo aims to take [Vercel's excellent template repo](https://github.com/vercel/next.js/tree/canary/examples/with-supabase) as a starting point and improve it to make it a fully production ready system for ongoing development. The initial repo comes with a recommended best practice NextJS boilerplate, with best practices for Supabase auth built in.

This Repo is currently a work in progress. Do not use it yet.

The aim is to create a recommended setup for NextJS + Supabase with versioned migrations and edge functions.

## Getting Started

1. Create your Supabase project here
2. Once created, copy the .env values from the connect tab under NextJS in the [Supabase dashboard](https://supabase.com/dashboard/project/_?showConnect=true). Rename the .env.example file to .env.local, and paste the contents in there. Make sure to rename the file so that it is not tracked in git.
3. Create an access token for this project in your [Supabase account settings](https://supabase.com/dashboard/account/tokens). Scope it to this project only. If you want to use edge functions, you must choose read/write, but if you don't want to, you can choose read-only to just use it for migrations.

## How To Use

There are two files already set up in the Supabase directory. A migration file, and an edge functions directory. These are designed to show how the setup works. The migration file will create a table for user profiles linked to the inbuilt auth schema, and a function and trigger to create new profile rows automatically when a new user is added.

## Deployment to Vercel

Vercel deployment will guide you through creating a Supabase account and project.
