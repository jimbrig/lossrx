DROP TABLE IF EXISTS claimants;
CREATE TABLE claimants(
    claimant_id uuid,
    claimant_name character varying,
    PRIMARY KEY(claimant_id)
);

DROP TABLE IF EXISTS claims;
CREATE TABLE claims(
    claim_id uuid,
    claim_number integer,
    claimant_id uuid,
    occurrence_id uuid,
    coverage_id uuid,
    tpa_id uuid,
    company_id uuid,
    evaluation_date date,
    loss_date date,
    report_date date,
    close_date date,
    reopen_date date,
    reclose_date date,
    status USER-DEFINED,
    total_paid numeric,
    total_reported numeric,
    PRIMARY KEY(claim_id)
);

DROP TABLE IF EXISTS companies;
CREATE TABLE companies(
    company_id uuid,
    company_name character varying,
    company_abbr character varying,
    PRIMARY KEY(company_id)
);

DROP TABLE IF EXISTS coverages;
CREATE TABLE coverages(
    coverage_id uuid,
    coverage character varying,
    coverage_abbr character varying,
    coverage_exposure_base character varying,
    PRIMARY KEY(coverage_id)
);

DROP TABLE IF EXISTS evaluations;
CREATE TABLE evaluations(
    evaluation_id uuid,
    evaluation_date date,
    PRIMARY KEY(evaluation_id)
);

DROP TABLE IF EXISTS occurrences;
CREATE TABLE occurrences(
    occurrence_id uuid,
    occurrence_number integer,
    number_of_claims integer,
    default_claim_used uuid,
    PRIMARY KEY(occurrence_id)
);

DROP TABLE IF EXISTS policies;
CREATE TABLE policies(
    policy_id uuid,
    policy_type character varying,
    coverage character varying,
    start_date date,
    end_date date,
    policy_year integer,
    start_end_text character varying,
    premium numeric,
    PRIMARY KEY(policy_id)
);

DROP TABLE IF EXISTS segments;
CREATE TABLE segments(
    segment_id uuid,
    segment_name character varying,
    segment_abbr character varying,
    PRIMARY KEY(segment_id)
);

DROP TABLE IF EXISTS tpas;
CREATE TABLE tpas(
    tpa_id uuid,
    tpa character varying,
    coverage character varying,
    PRIMARY KEY(tpa_id)
);