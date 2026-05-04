const { createClient } = require('@supabase/supabase-js');

const url = process.env.SUPABASE_URL;
const key = process.env.SUPABASE_SERVICE_KEY;

if (!url || !key) {
  console.error(
    '[FATAL] Missing SUPABASE_URL or SUPABASE_SERVICE_KEY. Set them in Railway (or .env for local).'
  );
  process.exit(1);
}

const supabase = createClient(url, key);

module.exports = { supabase };
