require('dotenv').config();
const express = require('express');
const cors = require('cors');
const cron = require('node-cron');
const { supabase } = require('./database');

const menuRoutes = require('./routes/menu');
const orderRoutes = require('./routes/orders');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

app.use('/api/menu', menuRoutes);
app.use('/api/orders', orderRoutes);
// Same routers without /api prefix (avoids 404 if client uses base URL host only + /menu paths)
app.use('/menu', menuRoutes);
app.use('/orders', orderRoutes);

app.get('/api/health', (req, res) => res.json({ status: 'ok', restaurant: 'Puerta de Estepa', time: new Date() }));
app.get('/health', (req, res) => res.json({ status: 'ok', restaurant: 'Puerta de Estepa', time: new Date() }));

// Railway / load balancers often probe GET /
app.get('/', (req, res) => {
  res.status(200).json({ status: 'ok', hint: 'API is under /api — try GET /api/health' });
});

app.use((req, res) => {
  res.status(404).json({
    error: 'Not found',
    path: req.path,
    method: req.method,
    hint: 'Use /api/health, /api/menu, /api/orders (or /health, /menu, /orders).',
  });
});

// Auto-delete orders older than retention period — runs every day at 3am
cron.schedule('0 3 * * *', async () => {
  const days = parseInt(process.env.ORDER_RETENTION_DAYS || '14');
  const cutoff = new Date();
  cutoff.setDate(cutoff.getDate() - days);
  const { error } = await supabase.from('orders').delete().lt('created_at', cutoff.toISOString());
  if (!error) console.log(`[CRON] Deleted orders older than ${days} days`);
});

app.listen(PORT, () => console.log(`Puerta de Estepa backend running on port ${PORT}`));
