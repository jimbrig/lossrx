CREATE TABLE public.tpa(
  tpa_id UUID UNIQUE PRIMARY KEY DEFAULT uuid_generate_v4(),
  tpa varchar UNIQUE NOT NULL,
  coverage_id UUID
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  created_by VARCHAR DEFAULT NULL,
  modified_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  modified_by VARCHAR DEFAULT NULL
);
