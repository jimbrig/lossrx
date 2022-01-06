CREATE TYPE "claim_status" AS ENUM (
  'O',
  'C',
  'R'
);

CREATE TABLE "claims" (
  "claim_id" uuid PRIMARY KEY NOT NULL,
  "claim_number" SERIAL,
  "claimant_id" uuid,
  "occurrence_id" uuid,
  "coverage_id" uuid,
  "tpa_id" uuid,
  "company_id" uuid,
  "evaluation_date" date,
  "loss_date" date NOT NULL,
  "report_date" date NOT NULL,
  "close_date" date DEFAULT NULL,
  "reopen_date" date DEFAULT NULL,
  "reclose_date" date DEFAULT NULL,
  "status" claim_status,
  "total_paid" numeric NOT NULL DEFAULT 0,
  "total_reported" numeric NOT NULL DEFAULT 0
);

CREATE TABLE "claimants" (
  "claimant_id" uuid PRIMARY KEY NOT NULL,
  "claimant_name" varchar
);

CREATE TABLE "occurrences" (
  "occurrence_id" uuid PRIMARY KEY NOT NULL,
  "occurrence_number" SERIAL NOT NULL,
  "number_of_claims" int,
  "default_claim_used" uuid
);

CREATE TABLE "coverages" (
  "coverage_id" uuid PRIMARY KEY NOT NULL,
  "coverage" varchar UNIQUE NOT NULL,
  "coverage_abbr" varchar UNIQUE NOT NULL,
  "coverage_exposure_base" varchar UNIQUE NOT NULL
);

CREATE TABLE "policies" (
  "policy_id" uuid PRIMARY KEY NOT NULL,
  "policy_type" varchar,
  "coverage" varchar,
  "start_date" date NOT NULL,
  "end_date" date NOT NULL,
  "policy_year" int,
  "start_end_text" varchar,
  "premium" numeric NOT NULL
);

CREATE TABLE "tpas" (
  "tpa_id" uuid PRIMARY KEY NOT NULL,
  "tpa" varchar UNIQUE NOT NULL,
  "coverage" varchar
);

CREATE TABLE "companies" (
  "company_id" uuid PRIMARY KEY NOT NULL,
  "company_name" varchar,
  "company_abbr" varchar
);

CREATE TABLE "segments" (
  "segment_id" uuid PRIMARY KEY NOT NULL,
  "segment_name" varchar,
  "segment_abbr" varchar
);

CREATE TABLE "evaluations" (
  "evaluation_id" uuid PRIMARY KEY NOT NULL,
  "evaluation_date" date UNIQUE NOT NULL
);

ALTER TABLE "claims" ADD FOREIGN KEY ("claimant_id") REFERENCES "claimants" ("claimant_id");

ALTER TABLE "claims" ADD FOREIGN KEY ("occurrence_id") REFERENCES "occurrences" ("occurrence_id");

ALTER TABLE "claims" ADD FOREIGN KEY ("coverage_id") REFERENCES "coverages" ("coverage_id");

ALTER TABLE "claims" ADD FOREIGN KEY ("tpa_id") REFERENCES "tpas" ("tpa_id");

ALTER TABLE "claims" ADD FOREIGN KEY ("company_id") REFERENCES "companies" ("company_id");

ALTER TABLE "claims" ADD FOREIGN KEY ("evaluation_date") REFERENCES "evaluations" ("evaluation_date");

ALTER TABLE "policies" ADD FOREIGN KEY ("coverage") REFERENCES "coverages" ("coverage_abbr");

ALTER TABLE "tpas" ADD FOREIGN KEY ("coverage") REFERENCES "coverages" ("coverage_abbr");

COMMENT ON COLUMN "claims"."claim_id" IS 'Unique indentifier for the individual claim. Primary Key of this table.';
