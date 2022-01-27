CREATE TABLE public.policy (
  policy_id UUID UNIQUE PRIMARY KEY DEFAULT uuid_generate_v4(),
  coverage_id UUID,
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  premium NUMERIC NOT NULL,
  alae_treatment ALAE_TREATMENT,
  is_occurrence_based BIT,
  tpa_id UUID,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  created_by VARCHAR DEFAULT NULL,
  modified_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  modified_by VARCHAR DEFAULT NULL
);
