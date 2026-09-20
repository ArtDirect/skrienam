# Skrienam

One screen. Four fields. No accounts. A link you paste into the WhatsApp group.

- `index.html` — the whole app
- `config.js` — your Supabase URL + anon key (the only file you edit)
- `schema.sql` — one table and three functions
- `manifest.webmanifest`, `icon.svg`, `icon-180.png`, `icon-512.png` — home-screen icon

No build step, no framework, no npm. It is one HTML file.

---

## Setup — about 10 minutes

### 1. Supabase (the database)

1. Create a free account at **supabase.com** and start a new project. Pick the
   Frankfurt region — it is the closest to Latvia.
2. Open **SQL Editor**, paste the whole of `schema.sql`, press **Run**.
3. Open **Project Settings → API** and copy two things:
   - Project URL (`https://xxxx.supabase.co`)
   - `anon` `public` key (the long one)
4. Paste both into `config.js`.

The `anon` key is designed to be public — it sits in every visitor's browser.
Row Level Security, which `schema.sql` switches on, is what actually guards the
data: anyone can read the list and post a run, but nobody can update or delete
rows directly. Joining and leaving go through the three functions instead.

**This is the Excel Raitis asked for.** Supabase → Table Editor → `runs` is a
spreadsheet of every run, sortable and exportable to CSV.

### 2. Put it online

Drag this whole folder onto **app.netlify.com/drop**. That is the entire deploy.
You get a URL straight away; rename it to something like `skrienam` in Site
settings so the link reads well in a chat.

Cloudflare Pages and Vercel both work the same way — any static host will do,
because there is nothing to build.

### 3. Send it

Paste the link into the WhatsApp group. Tell people to **Add to Home Screen** —
it then opens like an app, full screen, with the icon.

---

## How it behaves

- **Name, not account.** First time you tap *Es skrienu*, it asks `Kā tevi sauc?`
  once and remembers it in that phone's local storage. Tap your name in the
  header to change it.
- **Past runs disappear** from the list on their own. Nothing to tidy up.
- **The list refreshes** every 30 seconds and whenever you switch back to the tab.
- **Sharing** uses the phone's native share sheet where it exists (so WhatsApp
  shows up in the list), and falls back to a `wa.me` link on desktop. There is
  also a Copy button.
- **Deleting** is only offered to whoever posted the run, and the database
  enforces it too — not just the button.

## Changing things

Everything is in `index.html`. The colours are CSS custom properties at the very
top (`--accent` is the carmine). The Latvian strings are inline — search for the
word you want to change.

## If something breaks

- **Nothing loads, "Neizdevās ielādēt"** — `config.js` values are wrong, or
  `schema.sql` was never run.
- **"Nav savienots" banner** — `config.js` is missing or still has the
  placeholder text. The app still works, but only in that one browser tab.
- **Joining fails silently** — the three `grant execute` lines at the bottom of
  `schema.sql` did not run.
