CREATE TABLE public.vehicle (
    vehicle_id UUID UNIQUE PRIMARY KEY DEFAULT uuid_generate_v4(),
    vehicle_vin VARCHAR UNIQUE,
    vehicle_make VARCHAR,
    vehicle_model VARCHAR,
    vehicle_year INTEGER,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_by VARCHAR DEFAULT NULL,
    modified_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    modified_by VARCHAR DEFAULT NULL
)

