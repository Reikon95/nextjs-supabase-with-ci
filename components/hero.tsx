import { NextLogo } from "./next-logo";
import { SupabaseLogo } from "./supabase-logo";

export function Hero() {
  return (
    <div className="flex flex-col gap-16 items-center">
      <div className="flex gap-8 justify-center items-center">
        <a
          href="https://supabase.com/?utm_source=create-next-app&utm_medium=template&utm_term=nextjs"
          target="_blank"
          rel="noreferrer"
        >
          <SupabaseLogo />
        </a>
        <span className="border-l rotate-45 h-6" />
        <a href="https://nextjs.org/" target="_blank" rel="noreferrer">
          <NextLogo />
        </a>
      </div>
      <div className="flex flex-col gap-4 items-center">
        <h1 className="text-3xl lg:text-4xl !leading-tight mx-auto max-w-xl text-center">
          A production ready, scalable template for NextJS and Supabase
        </h1>
        <p className="text-lg mx-auto max-w-xl text-center text-foreground/80">
          This repo contains NextJS and Supabase best practices alongside
          recommended workflows for versioned migrations and edge functions.
        </p>
      </div>
      <div className="w-full p-[1px] bg-gradient-to-r from-transparent via-foreground/10 to-transparent my-8" />
    </div>
  );
}
