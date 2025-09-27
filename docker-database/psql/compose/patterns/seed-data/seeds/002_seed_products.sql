-- Seed Data: Sample products
-- File: 002_seed_products.sql

INSERT INTO app.products (name, description, price, stock_quantity, category) VALUES
    ('Laptop', 'High-performance laptop for development', 999.99, 50, 'electronics'),
    ('Smartphone', 'Latest smartphone with advanced features', 699.99, 100, 'electronics'),
    ('Coffee Mug', 'Developer-themed coffee mug', 12.99, 500, 'accessories'),
    ('Keyboard', 'Mechanical keyboard for coding', 149.99, 75, 'electronics'),
    ('Mouse', 'Ergonomic wireless mouse', 79.99, 120, 'electronics'),
    ('Book: Clean Code', 'Essential programming book', 39.99, 200, 'books'),
    ('T-Shirt', 'Developer humor t-shirt', 24.99, 300, 'clothing'),
    ('Water Bottle', 'Insulated water bottle', 19.99, 150, 'accessories')
ON CONFLICT DO NOTHING;