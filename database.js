const { createClient } = require('@supabase/supabase-js');

// Project URL: Settings → API → Project URL (https://xxxxx.supabase.co)
const url = (process.env.SUPABASE_URL || '').trim();
// Service role key (secret): Settings → API → service_role — NOT the anon key
const key = (
  process.env.SUPABASE_SERVICE_KEY ||
  process.env.SUPABASE_SERVICE_ROLE_KEY ||
  ''
).trim();

if (!url || !key) {
  console.error(
    '[FATAL] Missing Supabase credentials. Set in Railway (or .env for local):'
  );
  console.error('  SUPABASE_URL = https://<ref>.supabase.co');
  console.error('  SUPABASE_SERVICE_KEY = <service_role JWT from Supabase → API>');
  process.exit(1);
}

if (!/^https:\/\//i.test(url)) {
  console.warn('[WARN] SUPABASE_URL should use https://');
}

const supabase = createClient(url, key, {
  auth: { persistSession: false, autoRefreshToken: false },
});

module.exports = { supabase };
