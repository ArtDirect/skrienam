// Skrienam — Supabase savienojums.
//
// Šīs vērtības ņemtas no Supabase: Project Settings -> Data API (url)
// un Project Settings -> API Keys (key).
//
// The publishable key is MEANT to be public — it ships in every browser.
// What protects the data is Row Level Security, set up in schema.sql.
// NEVER put the service_role / sb_secret_ key here: this repo is public.
//
// `url` is the bare project URL. Do not include /rest/v1/ — the client
// appends that itself.

window.SKRIENAM = {
  url: "https://qxnjqkdwadbldayudffj.supabase.co",
  key: "sb_publishable_gWh5jG2AK5cvao_fOczQjw_1omh2BLP"
};
