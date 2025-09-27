-- Seed Data: Sample users
-- File: 001_seed_users.sql

INSERT INTO app.users (username, email, password_hash, status) VALUES
    ('admin', 'admin@example.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LeA7bkcqEusOJd.TC', 'active'),
    ('john_doe', 'john@example.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LeA7bkcqEusOJd.TC', 'active'),
    ('jane_smith', 'jane@example.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LeA7bkcqEusOJd.TC', 'active'),
    ('test_user', 'test@example.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LeA7bkcqEusOJd.TC', 'active')
ON CONFLICT (username) DO NOTHING;