-- Development Database Initialization Script
-- รันเมื่อสร้าง database ครั้งแรก

-- Enable common extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_stat_statements";

-- Create sample schema
CREATE SCHEMA IF NOT EXISTS app_data;

-- Create sample table
CREATE TABLE IF NOT EXISTS app_data.users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Insert sample data
INSERT INTO app_data.users (username, email) VALUES
    ('john_doe', 'john@example.com'),
    ('jane_smith', 'jane@example.com'),
    ('dev_user', 'dev@example.com')
ON CONFLICT (username) DO NOTHING;

-- Create index
CREATE INDEX IF NOT EXISTS idx_users_email ON app_data.users(email);

-- Create function for updated_at trigger
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger
DROP TRIGGER IF EXISTS update_users_updated_at ON app_data.users;
CREATE TRIGGER update_users_updated_at
    BEFORE UPDATE ON app_data.users
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Grant permissions
GRANT USAGE ON SCHEMA app_data TO ${PG_USER};
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA app_data TO ${PG_USER};
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA app_data TO ${PG_USER};

-- Log completion
SELECT 'Database initialization completed successfully!' as message;