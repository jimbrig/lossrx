CREATE TYPE "claim_status" AS ENUM (
  'O',
  'C',
  'R'
);

CREATE TYPE "coverage_codes" AS ENUM (
  'WC',
  'AL',
  'PROP',
  'GL',
  'MPL',
  'OTHER'
);

CREATE TABLE "claims" (
  "claim_id" uuid PRIMARY KEY NOT NULL,
  "claim_number" SERIAL,
  "claimant_id" uuid,
  "occurrence_id" uuid,
  "policy_id" uuid,
  "coverage_id" uuid,
  "tpa_id" uuid,
  "company_id" uuid,
  "loss_date" date NOT NULL,
  "report_date" date NOT NULL,
  "close_date" date DEFAULT NULL,
  "reopen_date" date DEFAULT NULL,
  "reclose_date" date DEFAULT NULL
);

CREATE TABLE "claim_evaluations" (
  "claim_id" uuid NOT NULL,
  "evaluation_date" date NOT NULL,
  "status" claim_status,
  "total_paid" numeric NOT NULL DEFAULT 0,
  "total_case" numeric NOT NULL DEFAULT 0,
  PRIMARY KEY ("claim_id", "evaluation_date")
);

CREATE TABLE "claimants" (
  "claimant_id" uuid PRIMARY KEY NOT NULL,
  "claimant_first_name" varchar,
  "claimant_last_name" varchar,
  "claimant_full_name" varchar,
  "claimant_age" integer,
  "claimant_details" varchar
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
  "premium" numeric NOT NULL,
  "alae_treatment" varchar,
  "occ_claims_based" varchar
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

ALTER TABLE "claims" ADD FOREIGN KEY ("policy_id") REFERENCES "policies" ("policy_id");

ALTER TABLE "claims" ADD FOREIGN KEY ("coverage_id") REFERENCES "coverages" ("coverage_id");

ALTER TABLE "claims" ADD FOREIGN KEY ("tpa_id") REFERENCES "tpas" ("tpa_id");

ALTER TABLE "claims" ADD FOREIGN KEY ("company_id") REFERENCES "companies" ("company_id");

ALTER TABLE "claim_evaluations" ADD FOREIGN KEY ("claim_id") REFERENCES "claims" ("claim_id");

ALTER TABLE "claim_evaluations" ADD FOREIGN KEY ("evaluation_date") REFERENCES "evaluations" ("evaluation_date");

ALTER TABLE "policies" ADD FOREIGN KEY ("coverage") REFERENCES "coverages" ("coverage_abbr");

ALTER TABLE "tpas" ADD FOREIGN KEY ("coverage") REFERENCES "coverages" ("coverage_abbr");


COMMENT ON TABLE "claims" IS 'Primary claims table listing idividual claims and their relationships, dates, and attributes.';

COMMENT ON COLUMN "claims"."claim_id" IS 'Unique indentifier for the individual claim. Primary Key of this table.';

COMMENT ON COLUMN "claims"."claim_number" IS 'Another form of claim identification but using an auto-incrememnting integer based off creation date.';

COMMENT ON COLUMN "claims"."claimant_id" IS 'Identifier for the claim"s claimant. References the claimants table > claimant_id field.';

COMMENT ON COLUMN "claims"."occurrence_id" IS 'Identifier for the claim"s occurrence, if applicable. Occurrences group claims by accident or occurrence and depending on the policy, occurrence or claims based reserving should be used.';

COMMENT ON COLUMN "claims"."policy_id" IS 'Identifer for the claims policy.';

COMMENT ON COLUMN "claims"."coverage_id" IS 'Identifier for the claim"s coverage (i.e. WC, AL, GL, MPL, PROP, etc.)';

COMMENT ON COLUMN "claims"."tpa_id" IS 'Identifier for the claim"s TPA (third party administer) that provieded claim details.';

COMMENT ON COLUMN "claims"."company_id" IS 'Identifier for the claim"s company or division, if applicable.';

COMMENT ON TABLE "claim_evaluations" IS 'This table combines individual claims and their corresponding evaluation dates values. containing all combinations of claims and evaluation dates. This table represents a merged table containing all evaluation date lossuns for a given client or project.';

COMMENT ON COLUMN "claim_evaluations"."claim_id" IS 'Claim Identifier';

COMMENT ON COLUMN "claim_evaluations"."evaluation_date" IS 'Evaluation date values are evaluated as of.';

COMMENT ON COLUMN "claim_evaluations"."status" IS 'O, C, or R for Open, Closed, or Re-Opened; Status can change between evals determining prior-to-current status levels (i.e. O->C is a closure, C->R is a re-opening, etc.)';

COMMENT ON COLUMN "claim_evaluations"."total_paid" IS 'Total cumulative paid as of the specified evaluation date. Should be less than reported and flagged if closed and $0 paid.';

COMMENT ON COLUMN "claim_evaluations"."total_case" IS 'Total cumulative case reserves as of the evaluation date. Case plus paid determines reported amounts.';

COMMENT ON TABLE "claimants" IS 'The Claimants table represents all claimants that have appeared in the system over its lifetime. Claimants represent individuals that have filed claims in accordance with their policies and coverages.';

COMMENT ON TABLE "occurrences" IS 'Occurrences represent groups of individual claims and group together all parties involved with a single occurrence or accident. Depending on the policy type, treatment of losses will either depend on occurrence based or claims based losses.';

COMMENT ON TABLE "coverages" IS 'The coverages table lists all potential coverages and their abbrevations/codes in the given actuarial projects environment';

COMMENT ON TABLE "policies" IS 'Policy details';
