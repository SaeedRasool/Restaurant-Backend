const express = require('express');
const router = express.Router();
const { supabase } = require('../database');

// POST place new order
router.post('/', async (req, res) => {
  const { customer, items, orderType, payMethod, subtotal, deliveryFee, total, notes } = req.body;
  const orderId = 'ORD-' + Math.floor(Math.random() * 90000 + 10000);

  const { data, error } = await supabase
    .from('orders')
    .insert([{
      _id: orderId,
      customer,
      items,
      order_type: orderType,
      pay_method: payMethod,
      subtotal,
      delivery_fee: deliveryFee,
      total,
      notes,
      status: 'confirmed',
      estimated_time: orderType === 'delivery' ? '30–40 min' : '20 min',
      created_at: new Date().toISOString(),
    }])
    .select()
    .single();

  if (error) return res.status(500).json({ error: error.message });
  res.status(201).json(formatOrder(data));
});

// GET all orders (admin) — must be before /:id so "history" is not captured as id
router.get('/', async (req, res) => {
  const { status } = req.query;
  let query = supabase.from('orders').select('*').order('created_at', { ascending: false });
  if (status) query = query.eq('status', status);
  const { data, error } = await query;
  if (error) return res.status(500).json({ error: error.message });
  res.json((data || []).map(formatOrder));
});

// GET order history by phone — before /:id
router.get('/history/:phone', async (req, res) => {
  const phone = decodeURIComponent(req.params.phone || '');
  const { data, error } = await supabase
    .from('orders')
    .select('*')
    .eq('customer->>phone', phone)
    .order('created_at', { ascending: false });
  if (error) return res.status(500).json({ error: error.message });
  res.json((data || []).map(formatOrder));
});

// PATCH update order status (admin) — before generic /:id if we add more routes
router.patch('/:id/status', async (req, res) => {
  const { data, error } = await supabase
    .from('orders')
    .update({ status: req.body.status })
    .eq('_id', req.params.id)
    .select()
    .single();
  if (error) return res.status(500).json({ error: error.message });
  res.json(formatOrder(data));
});

// GET single order
router.get('/:id', async (req, res) => {
  const { data, error } = await supabase
    .from('orders')
    .select('*')
    .eq('_id', req.params.id)
    .single();
  if (error) return res.status(404).json({ error: 'Order not found' });
  res.json(formatOrder(data));
});

function formatOrder(d) {
  if (!d) return d;
  return {
    _id: d._id,
    customer: d.customer,
    items: d.items,
    orderType: d.order_type,
    payMethod: d.pay_method,
    subtotal: num(d.subtotal),
    deliveryFee: num(d.delivery_fee),
    total: num(d.total),
    notes: d.notes,
    status: d.status,
    estimatedTime: d.estimated_time,
    createdAt: d.created_at,
  };
}

function num(v) {
  const n = typeof v === 'string' ? parseFloat(v) : Number(v);
  return Number.isFinite(n) ? n : 0;
}

module.exports = router;
