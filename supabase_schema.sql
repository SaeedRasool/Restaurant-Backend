-- ================================================
-- PUERTA DE ESTEPA — Database Schema
-- Paste this into Supabase → SQL Editor → Run
-- ================================================

CREATE TABLE menu_items (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  category TEXT NOT NULL,
  description TEXT,
  price DECIMAL(10,2) NOT NULL,
  emoji TEXT DEFAULT '🍽',
  image_url TEXT,
  extras TEXT[] DEFAULT '{}',
  removable TEXT[] DEFAULT '{}',
  available BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE orders (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  _id TEXT UNIQUE NOT NULL,
  customer JSONB NOT NULL,
  items JSONB NOT NULL,
  order_type TEXT NOT NULL CHECK (order_type IN ('delivery', 'pickup')),
  pay_method TEXT NOT NULL CHECK (pay_method IN ('cash', 'card')),
  subtotal DECIMAL(10,2) NOT NULL,
  delivery_fee DECIMAL(10,2) DEFAULT 0,
  total DECIMAL(10,2) NOT NULL,
  notes TEXT,
  status TEXT NOT NULL DEFAULT 'confirmed'
    CHECK (status IN ('confirmed','preparing','ready','delivered','cancelled')),
  estimated_time TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_orders_phone   ON orders ((customer->>'phone'));
CREATE INDEX idx_orders_status  ON orders (status);
CREATE INDEX idx_orders_created ON orders (created_at DESC);

-- Seed menu items
INSERT INTO menu_items (name, category, description, price, emoji, extras, removable) VALUES
('Patata Asada Básica',       'Patatas Asadas',   'Mantequilla, tomate frito, jamón york y queso',                      5.00, '🥔', ARRAY['Extra queso','Bacon'],              ARRAY['Jamón york']),
('Patata Asada Atún',         'Patatas Asadas',   'Mayonesa, atún, tomate, cebolla',                                    5.50, '🥔', ARRAY['Extra atún'],                       ARRAY['Cebolla']),
('Patata Asada Kebab',        'Patatas Asadas',   'Salsa yogurt, carne kebab, lechuga, tomate, cebolla, maíz y queso',  5.50, '🥔', ARRAY['Extra carne','Extra queso'],        ARRAY['Cebolla','Maíz']),
('Dürum XXL',                 'Kebab & Dürum',    '+ patatas + lata refresco',                                         12.00, '🌯', ARRAY['Extra carne','Doble salsa'],        ARRAY['Lechuga','Tomate','Cebolla']),
('Dürum Grande',              'Kebab & Dürum',    '+ patatas + lata refresco',                                          6.99, '🌯', ARRAY['Extra carne','Extra salsa'],        ARRAY['Lechuga','Tomate','Cebolla']),
('Pita Kebab',                'Kebab & Dürum',    '+ patatas + lata refresco',                                          6.99, '🥙', ARRAY['Extra carne','Jalapeños'],          ARRAY['Lechuga','Tomate','Cebolla','Salsa']),
('Falafel Dürum',             'Kebab & Dürum',    '+ patatas + lata refresco',                                          7.00, '🌯', ARRAY['Extra falafel'],                    ARRAY['Lechuga','Tomate']),
('Hamburguesa',               'Hamburguesas',     '+ patatas + lata refresco',                                          6.00, '🍔', ARRAY['Bacon','Queso extra','Huevo frito'],ARRAY['Lechuga','Tomate','Cebolla','Salsa']),
('Campero',                   'Hamburguesas',     'Pollo empanado + patatas + lata refresco',                           6.99, '🍔', ARRAY['Extra pollo','Queso extra','Bacon'],ARRAY['Lechuga','Tomate','Mayonesa']),
('Alitas de Pollo (5 uds)',   'Pollo',            '5 unidades + patatas + lata refresco',                               6.00, '🍗', ARRAY['Salsa barbacoa','Salsa picante'],   ARRAY[]::TEXT[]),
('Nuggets de Pollo (5 uds)',  'Pollo',            '5 unidades + patatas + lata refresco',                               6.00, '🍗', ARRAY['Salsa barbacoa','Ketchup'],         ARRAY[]::TEXT[]),
('Plato Shawarma',            'Shawarma & Horno', 'Shawarma + lata refresco',                                           7.99, '🍖', ARRAY['Con arroz +1€','Extra carne'],      ARRAY['Salsa','Cebolla']),
('Plato Shawarma con Arroz',  'Shawarma & Horno', 'Shawarma con arroz + lata refresco',                                 8.99, '🍖', ARRAY['Extra carne'],                      ARRAY['Salsa']),
('Lahmacun',                  'Shawarma & Horno', '+ patatas + lata refresco',                                          7.99, '🫓', ARRAY['Extra carne','Limón'],              ARRAY['Cebolla','Perejil']),
('Plato Horno',               'Shawarma & Horno', 'Carne con patatas gratinadas + lata refresco',                       9.00, '🍲', ARRAY['Extra queso','Salsa extra'],        ARRAY['Salsa']),
('Margarita',                 'Pizzas',           'Tomate y mozzarella',                                                7.50, '🍕', ARRAY['Familiar 11€'],                     ARRAY[]::TEXT[]),
('Pan de Ajo',                'Pizzas',           'Tomate, mozzarella, ajo y aceite',                                   7.50, '🍕', ARRAY['Familiar 11€'],                     ARRAY['Ajo']),
('Prosciutto',                'Pizzas',           'Tomate, mozzarella y jamón',                                         7.50, '🍕', ARRAY['Familiar 11€','Extra jamón'],       ARRAY['Jamón']),
('Tonno',                     'Pizzas',           'Tomate, mozzarella, atún y cebolla',                                 7.50, '🍕', ARRAY['Familiar 11€','Extra atún'],        ARRAY['Cebolla']),
('Caprichosa',                'Pizzas',           'Tomate, mozzarella, atún, champiñones y pavo',                       7.50, '🍕', ARRAY['Familiar 11€'],                     ARRAY['Champiñones']),
('Fungui Prosciutto',         'Pizzas',           'Tomate, mozzarella, champiñones y jamón',                            7.50, '🍕', ARRAY['Familiar 11€'],                     ARRAY['Champiñones']),
('Hawaiana',                  'Pizzas',           'Tomate, mozzarella, jamón y piña',                                   7.50, '🍕', ARRAY['Familiar 11€'],                     ARRAY['Piña']),
('Favorita',                  'Pizzas',           'Tomate, mozzarella, jamón, pimiento, pollo y cebolla',               7.50, '🍕', ARRAY['Familiar 11€'],                     ARRAY['Pimiento','Cebolla']),
('Primavera',                 'Pizzas',           'Tomate, mozzarella, pollo, carne picada, atún, cebolla y pimientos', 7.50, '🍕', ARRAY['Familiar 11€'],                     ARRAY['Cebolla','Pimientos']),
('Shawarma Pizza',            'Pizzas',           'Tomate, mozzarella, carne shawarma, pimientos y cebolla',            7.50, '🍕', ARRAY['Familiar 11€','Extra carne'],       ARRAY['Pimientos','Cebolla']),
('Barbacoa',                  'Pizzas',           'Tomate, mozzarella, carne picada, pollo, cebolla y salsa barbacoa',  7.50, '🍕', ARRAY['Familiar 11€'],                     ARRAY['Cebolla']),
('4 Estaciones',              'Pizzas',           'Tomate, mozzarella, jamón, atún, pollo y aceitunas',                 7.50, '🍕', ARRAY['Familiar 11€'],                     ARRAY['Aceitunas']),
('Marinera',                  'Pizzas',           'Tomate, mozzarella, atún, gambas, mejillones y cebolla',             7.50, '🍕', ARRAY['Familiar 11€'],                     ARRAY['Cebolla','Mejillones']),
('Mexicana',                  'Pizzas',           'Tomate, mozzarella, ternera picante, pimientos y cebolla',           7.50, '🍕', ARRAY['Familiar 11€','Extra picante'],     ARRAY['Pimientos','Cebolla']),
('4 Quesos',                  'Pizzas',           'Tomate, mozzarella, cuatro tipos de queso',                         7.50, '🍕', ARRAY['Familiar 11€'],                     ARRAY[]::TEXT[]),
('San Marcos',                'Pizzas',           'Tomate, mozzarella, jamón, champiñones y carne de kebab',            7.50, '🍕', ARRAY['Familiar 11€','Extra carne'],       ARRAY['Champiñones']),
('Calzone',                   'Pizzas',           'Tomate, mozzarella, pollo o ternera, cebolla y salsa yogurt',        7.50, '🍕', ARRAY['Familiar 11€'],                     ARRAY['Cebolla']),
('Carbonara',                 'Pizzas',           'Tomate, mozzarella, pollo, queso parmesano y nata',                  7.50, '🍕', ARRAY['Familiar 11€'],                     ARRAY[]::TEXT[]),
('Rey',                       'Pizzas',           'Tomate, mozzarella, jamón, pollo, atún y carne picada',              7.50, '🍕', ARRAY['Familiar 11€'],                     ARRAY[]::TEXT[]),
('Al Gusto',                  'Pizzas',           'Tomate, mozzarella y 3 ingredientes a tu elección',                  7.50, '🍕', ARRAY['Familiar 11€'],                     ARRAY[]::TEXT[]),
('Ensalada Mixta',            'Ensaladas',        'Lechuga, tomate, zanahoria, maíz, aceite y vinagre',                 3.50, '🥗', ARRAY['Atún','Queso feta'],                ARRAY['Maíz','Zanahoria']),
('Ensalada Atún',             'Ensaladas',        'Lechuga, tomate, zanahoria y salsa',                                 5.50, '🥗', ARRAY['Extra atún'],                       ARRAY['Zanahoria']),
('Ensalada Especial',         'Ensaladas',        'Carne de pollo o ternera, lechuga, tomate, cebolla y salsa especial',5.50, '🥗', ARRAY['Extra carne'],                      ARRAY['Cebolla']),
('Menú 12 — 2 Hamburguesas',  'Menús Combinados', '2 hamburguesas de pollo + 2 latas o 2L refresco + patatas',         11.00, '⭐', ARRAY[]::TEXT[],                           ARRAY[]::TEXT[]),
('Menú 13 — 2 Dürum o Pitas', 'Menús Combinados', '2 dürum o pitas + 2 latas o 2L refresco + patatas',                13.00, '⭐', ARRAY[]::TEXT[],                           ARRAY[]::TEXT[]),
('Menú 14 — 2 Pizzas Medianas','Menús Combinados','2 pizzas medianas + 2 latas o 2L refresco',                         15.00, '⭐', ARRAY[]::TEXT[],                           ARRAY[]::TEXT[]),
('Menú 15 — 3 Pitas o Dürum', 'Menús Combinados', '3 pitas o dürum + 2 latas o 2L refresco',                          17.00, '⭐', ARRAY[]::TEXT[],                           ARRAY[]::TEXT[]),
('Menú 17 — 3 Tarrinas',      'Menús Combinados', '3 tarrinas medianas + 2 latas o 2L refresco',                       17.00, '⭐', ARRAY[]::TEXT[],                           ARRAY[]::TEXT[]),
('Menú 18 — Pizza + 2 Pitas', 'Menús Combinados', 'Pizza mediana + 2 pitas o dürum + 2 latas + patatas',               17.00, '⭐', ARRAY[]::TEXT[],                           ARRAY[]::TEXT[]),
('Menú 19 — 3 Platos Grandes','Menús Combinados', '3 platos grandes + 2L refresco',                                    20.00, '⭐', ARRAY[]::TEXT[],                           ARRAY[]::TEXT[]),
('Menú 20 — 2 Pizzas Familiares','Menús Combinados','2 pizzas familiares + 2 latas o 2L refresco',                     21.00, '⭐', ARRAY[]::TEXT[],                           ARRAY[]::TEXT[]);
