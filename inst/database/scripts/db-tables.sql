CREATE TABLE claims (
    "claim_id" UUID PRIMARY KEY, -- DEFAULT uuid_generate_v4(),
    "claim_number" integer NOT NULL, -- GENERATED ALWAYS AS IDENTITY (start 1),
    "occurrence_id" UUID, -- REFERENCES occurrences(occurrence_id),
    "claimant_id" UUID, -- REFERENCES claimaints(claimaint_id),
    "coverage_id" UUID, -- REFERENCES coverages(coverage_id),
    "tpa_id" UUID, -- REFERENCES tpas(tpa_id),
    "segment_id" UUID, -- REFERENCES segments(segment_id),
    "policy_id" UUID, -- REFERENCES policies(policy_id),
    evaluation_date DATE NOT NULL,
    loss_date DATE NOT NULL,
    report_date DATE NOT NULL,
    close_date DATE DEFAULT NULL,
    reopen_date DATE DEFAULT NULL,
    reclose_date DATE DEFAULT NULL,
    status_code INTEGER NOT NULL DEFAULT REFERENCES statuses(status_code),
    total_paid NUMERIC DEFAULT 0,
    total_reported NUMERIC DEFAULT 0    
)