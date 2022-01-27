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
  "segment_id" uuid,
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

CREATE TABLE "vehicles" (
  "vehicle_id" uuid PRIMARY KEY NOT NULL,
  "vehicle_vin_number" varchar,
  "driver_id" uuid,
  "vehicle_make" varchar,
  "vehicle_model" varchar,
  "vehicle_year" int,
  "vehicle_color" varchar,
  "vehicle_exposure_level" int,
  "vehicle_value" float
);

ALTER TABLE "claimants" ADD FOREIGN KEY ("claimant_id") REFERENCES "claims" ("claimant_id");

ALTER TABLE "occurrences" ADD FOREIGN KEY ("occurrence_id") REFERENCES "claims" ("occurrence_id");

ALTER TABLE "policies" ADD FOREIGN KEY ("policy_id") REFERENCES "claims" ("policy_id");

ALTER TABLE "coverages" ADD FOREIGN KEY ("coverage_id") REFERENCES "claims" ("coverage_id");

ALTER TABLE "tpas" ADD FOREIGN KEY ("tpa_id") REFERENCES "claims" ("tpa_id");

ALTER TABLE "companies" ADD FOREIGN KEY ("company_id") REFERENCES "claims" ("company_id");

ALTER TABLE "segments" ADD FOREIGN KEY ("segment_id") REFERENCES "claims" ("segment_id");

ALTER TABLE "claim_evaluations" ADD FOREIGN KEY ("claim_id") REFERENCES "claims" ("claim_id");

ALTER TABLE "claim_evaluations" ADD FOREIGN KEY ("evaluation_date") REFERENCES "evaluations" ("evaluation_date");

ALTER TABLE "policies" ADD FOREIGN KEY ("coverage") REFERENCES "coverages" ("coverage_abbr");

ALTER TABLE "tpas" ADD FOREIGN KEY ("coverage") REFERENCES "coverages" ("coverage_abbr");

ALTER TABLE "vehicles" ADD FOREIGN KEY ("driver_id") REFERENCES "claimants" ("claimant_id");


COMMENT ON TABLE "claims" IS 'Primary claims fact table listing idividual claim"s measures such as amounts paid, reported, and reserved as well as the dimensional relationships to various claim attributes.';

COMMENT ON COLUMN "claims"."claim_id" IS 'Unique indentifier for the individual claim. Primary Key of this table.';

COMMENT ON COLUMN "claims"."claim_number" IS 'Another form of claim identification but using an auto-incrememnting integer based off creation date.';

COMMENT ON COLUMN "claims"."claimant_id" IS 'Identifier for the claim"s claimant. References the claimants table > claimant_id field.';

COMMENT ON COLUMN "claims"."occurrence_id" IS 'Identifier for the claim"s occurrence, if applicable. Occurrences group claims by accident or occurrence and depending on the policy, occurrence or claims based reserving should be used.';

COMMENT ON COLUMN "claims"."policy_id" IS 'Identifer for the claims policy.';

COMMENT ON COLUMN "claims"."coverage_id" IS 'Identifier for the claim"s coverage (i.e. WC, AL, GL, MPL, PROP, etc.)';

COMMENT ON COLUMN "claims"."tpa_id" IS 'Identifier for the claim"s TPA (third party administer) that provieded claim details.';

COMMENT ON COLUMN "claims"."company_id" IS 'Identifier for the claim"s company or division, if applicable.';

COMMENT ON COLUMN "claims"."segment_id" IS 'Identifier for the claim"s segment, if applicable.';

COMMENT ON COLUMN "claims"."loss_date" IS 'The claim"s loss date, i.e. the date which the accident or insured event took place.';

COMMENT ON COLUMN "claims"."report_date" IS 'The claim"s report date, i.e. the date which the claimant reported the claim to the insurer/TPA.';

COMMENT ON COLUMN "claims"."close_date" IS 'The claim"s closure date, i.e. the date the claim"s Status changes to Closed and case reserves are zeroed out.';

COMMENT ON COLUMN "claims"."reopen_date" IS 'The claim"s re-open date, i.e. the date a previosly closed claim is re-opened.';

COMMENT ON COLUMN "claims"."reclose_date" IS 'The claim"s last closure date given it has been re-opened at least once.';

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

COMMENT ON COLUMN "vehicles"."vehicle_id" IS 'The vehicle"s unique identifer and primary key.';

COMMENT ON COLUMN "vehicles"."vehicle_vin_number" IS 'VIN number for the vehicle.';

COMMENT ON COLUMN "vehicles"."driver_id" IS 'Foreign key identity to the claimant whom acted as the driver (owner) of the vehicle.';

COMMENT ON COLUMN "vehicles"."vehicle_make" IS 'The make of the vehicle.';

COMMENT ON COLUMN "vehicles"."vehicle_model" IS 'The vehicle"s model.';

COMMENT ON COLUMN "vehicles"."vehicle_year" IS 'Year the vehicle was made/purchased.';

COMMENT ON COLUMN "vehicles"."vehicle_color" IS 'Color of the vehicle.';

COMMENT ON COLUMN "vehicles"."vehicle_exposure_level" IS 'Exposure level (1,2, or 3) or the vehicle (i.e. passenger vehicles = 1, motor bikes = 2, and trucks = 3).';

COMMENT ON COLUMN "vehicles"."vehicle_value" IS 'The value in USD ($) of the vehicle.';
