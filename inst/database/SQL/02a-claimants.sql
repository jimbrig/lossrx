CREATE TABLE public.claimants (
    claimant_id UUID UNIQUE PRIMARY KEY DEFAULT uuid_generate_v4(),
    claimant_first_name VARCHAR,
    claimant_last_name VARCHAR,
    claimant_birth_date DATE,
    claimant_hire_date DATE,
    claimant_age INTEGER,
    claimant_gender VARCHAR,
    claimant_vehicle_id UUID, -- REFERENCES public.vehicles(vehicle_id),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by VARCHAR DEFAULT NULL,
    modified_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by VARCHAR DEFAULT NULL
);
