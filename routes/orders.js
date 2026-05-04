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

// GET order history by phone
router.get('/history/:phone', async (req, res) => {
  const { data, error } = await supabase
    .from('orders')
    .select('*')
    .eq('customer->>phone', req.params.phone)
    .order('created_at', { ascending: false });
  if (error) return res.status(500).json({ error: error.message });
  res.json(data.map(formatOrder));
});

// GET all orders (admin)
router.get('/', async (req, res) => {
  const { status } = req.query;
  let query = supabase.from('orders').select('*').order('created_at', { ascending: false });
  if (status) query = query.eq('status', status);
  const { data, error } = await query;
  if (error) return res.status(500).json({ error: error.message });
  res.json(data.map(formatOrder));
});

// PATCH update order status (admin)
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

function formatOrder(d) {
  return {
    _id: d._id,
    customer: d.customer,
    items: d.items,
    orderType: d.order_type,
    payMethod: d.pay_method,
    subtotal: d.subtotal,
    deliveryFee: d.delivery_fee,
    total: d.total,
    notes: d.notes,
    status: d.status,
    estimatedTime: d.estimated_time,
    createdAt: d.created_at,
  };
}

module.exports = router;
