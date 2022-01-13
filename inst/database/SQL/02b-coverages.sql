CREATE TABLE public.coverages (
    coverage_id UUID UNIQUE PRIMARY KEY DEFAULT uuid_generate_v4(),
    coverage VARCHAR,
    coverage_abbr VARCHAR,
    coverage_exposure_base VARCHAR,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by VARCHAR DEFAULT NULL,
    modified_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by VARCHAR DEFAULT NULL
);
