const express = require('express');
const router = express.Router();
const { supabase } = require('../database');

// GET all available menu items
router.get('/', async (req, res) => {
  const { data, error } = await supabase
    .from('menu_items')
    .select('*')
    .order('category', { ascending: true });
  if (error) return res.status(500).json({ error: error.message });
  res.json(data);
});

// POST create item (admin)
router.post('/', async (req, res) => {
  const { data, error } = await supabase
    .from('menu_items')
    .insert([req.body])
    .select()
    .single();
  if (error) return res.status(500).json({ error: error.message });
  res.status(201).json(data);
});

// PUT update item (admin)
router.put('/:id', async (req, res) => {
  const { data, error } = await supabase
    .from('menu_items')
    .update(req.body)
    .eq('id', req.params.id)
    .select()
    .single();
  if (error) return res.status(500).json({ error: error.message });
  res.json(data);
});

// DELETE item (admin)
router.delete('/:id', async (req, res) => {
  const { error } = await supabase
    .from('menu_items')
    .delete()
    .eq('id', req.params.id);
  if (error) return res.status(500).json({ error: error.message });
  res.json({ success: true });
});

module.exports = router;
