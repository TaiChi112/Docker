-- pgVector Extension Setup for AI/ML Applications
-- เปิดใช้งาน vector extension และสร้าง sample schema

-- Enable vector extension
CREATE EXTENSION IF NOT EXISTS vector;

-- Create AI schema
CREATE SCHEMA IF NOT EXISTS ai_embeddings;

-- Create table สำหรับเก็บ document embeddings
CREATE TABLE IF NOT EXISTS ai_embeddings.documents (
    id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    embedding vector(1536), -- OpenAI ada-002 embedding dimension
    metadata JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create index สำหรับ vector similarity search
CREATE INDEX IF NOT EXISTS idx_documents_embedding 
ON ai_embeddings.documents 
USING ivfflat (embedding vector_cosine_ops)
WITH (lists = 100);

-- Insert sample data (mock embeddings)
INSERT INTO ai_embeddings.documents (title, content, embedding, metadata) VALUES
    (
        'Introduction to PostgreSQL',
        'PostgreSQL is a powerful, open source object-relational database system.',
        array_fill(0.1, ARRAY[1536])::vector,
        '{"category": "database", "language": "en"}'::jsonb
    ),
    (
        'Vector Similarity Search',
        'Vector databases enable efficient similarity search for AI applications.',
        array_fill(0.2, ARRAY[1536])::vector,
        '{"category": "ai", "language": "en"}'::jsonb
    ),
    (
        'Machine Learning Embeddings',
        'Embeddings represent data in high-dimensional vector spaces.',
        array_fill(0.3, ARRAY[1536])::vector,
        '{"category": "ml", "language": "en"}'::jsonb
    )
ON CONFLICT DO NOTHING;

-- Create function สำหรับ similarity search
CREATE OR REPLACE FUNCTION find_similar_documents(
    query_embedding vector(1536),
    similarity_threshold float DEFAULT 0.8,
    max_results int DEFAULT 10
)
RETURNS TABLE(
    id int,
    title text,
    content text,
    similarity float,
    metadata jsonb
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        d.id,
        d.title,
        d.content,
        1 - (d.embedding <=> query_embedding) as similarity,
        d.metadata
    FROM ai_embeddings.documents d
    WHERE 1 - (d.embedding <=> query_embedding) > similarity_threshold
    ORDER BY d.embedding <=> query_embedding
    LIMIT max_results;
END;
$$ LANGUAGE plpgsql;

-- Grant permissions
GRANT USAGE ON SCHEMA ai_embeddings TO vectoruser;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA ai_embeddings TO vectoruser;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA ai_embeddings TO vectoruser;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA ai_embeddings TO vectoruser;

-- Log completion
SELECT 'pgVector setup completed successfully!' as message;