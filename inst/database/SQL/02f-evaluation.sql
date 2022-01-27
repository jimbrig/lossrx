CREATE TABLE public.evaluation (
  evaluation_id UUID UNIQUE PRIMARY KEY DEFAULT uuid_generate_v4(),
  evaluation_date DATE NOT NULL UNIQUE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  created_by VARCHAR DEFAULT NULL,
  modified_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  modified_by VARCHAR DEFAULT NULL
)
