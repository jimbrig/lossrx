CREATE TABLE `claims` (
  `claim_id` uuid PRIMARY KEY NOT NULL COMMENT 'Unique indentifier for the individual claim. Primary Key of this table.',
  `claim_number` int AUTO_INCREMENT COMMENT 'Another form of claim identification but using an auto-incrememnting integer based off creation date.',
  `claimant_id` uuid COMMENT 'Identifier for the claim\'s claimant. References the claimants table > claimant_id field.',
  `occurrence_id` uuid COMMENT 'Identifier for the claim\'s occurrence, if applicable. Occurrences group claims by accident or occurrence and depending on the policy, occurrence or claims based reserving should be used.',
  `policy_id` uuid COMMENT 'Identifer for the claims policy.',
  `coverage_id` uuid COMMENT 'Identifier for the claim\'s coverage (i.e. WC, AL, GL, MPL, PROP, etc.)',
  `tpa_id` uuid COMMENT 'Identifier for the claim\'s TPA (third party administer) that provieded claim details.',
  `company_id` uuid COMMENT 'Identifier for the claim\'s company or division, if applicable.',
  `segment_id` uuid COMMENT 'Identifier for the claim\'s segment, if applicable.',
  `loss_date` date NOT NULL COMMENT 'The claim\'s loss date, i.e. the date which the accident or insured event took place.',
  `report_date` date NOT NULL COMMENT 'The claim\'s report date, i.e. the date which the claimant reported the claim to the insurer/TPA.',
  `close_date` date DEFAULT NULL COMMENT 'The claim\'s closure date, i.e. the date the claim\'s Status changes to Closed and case reserves are zeroed out.',
  `reopen_date` date DEFAULT NULL COMMENT 'The claim\'s re-open date, i.e. the date a previosly closed claim is re-opened.',
  `reclose_date` date DEFAULT NULL COMMENT 'The claim\'s last closure date given it has been re-opened at least once.'
);

CREATE TABLE `claim_evaluations` (
  `claim_id` uuid NOT NULL COMMENT 'Claim Identifier',
  `evaluation_date` date NOT NULL COMMENT 'Evaluation date values are evaluated as of.',
  `status` ENUM ('O', 'C', 'R') COMMENT 'O, C, or R for Open, Closed, or Re-Opened; Status can change between evals determining prior-to-current status levels (i.e. O->C is a closure, C->R is a re-opening, etc.)',
  `total_paid` numeric NOT NULL DEFAULT 0 COMMENT 'Total cumulative paid as of the specified evaluation date. Should be less than reported and flagged if closed and $0 paid.',
  `total_case` numeric NOT NULL DEFAULT 0 COMMENT 'Total cumulative case reserves as of the evaluation date. Case plus paid determines reported amounts.',
  PRIMARY KEY (`claim_id`, `evaluation_date`)
);

CREATE TABLE `claimants` (
  `claimant_id` uuid PRIMARY KEY NOT NULL,
  `claimant_first_name` varchar(255),
  `claimant_last_name` varchar(255),
  `claimant_full_name` varchar(255),
  `claimant_age` integer,
  `claimant_details` varchar(255)
);

CREATE TABLE `occurrences` (
  `occurrence_id` uuid PRIMARY KEY NOT NULL,
  `occurrence_number` int NOT NULL AUTO_INCREMENT,
  `number_of_claims` int,
  `default_claim_used` uuid
);

CREATE TABLE `coverages` (
  `coverage_id` uuid PRIMARY KEY NOT NULL,
  `coverage` varchar(255) UNIQUE NOT NULL,
  `coverage_abbr` varchar(255) UNIQUE NOT NULL,
  `coverage_exposure_base` varchar(255) UNIQUE NOT NULL
);

CREATE TABLE `policies` (
  `policy_id` uuid PRIMARY KEY NOT NULL,
  `policy_type` varchar(255),
  `coverage` varchar(255),
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `policy_year` int,
  `start_end_text` varchar(255),
  `premium` numeric NOT NULL,
  `alae_treatment` varchar(255),
  `occ_claims_based` varchar(255)
);

CREATE TABLE `tpas` (
  `tpa_id` uuid PRIMARY KEY NOT NULL,
  `tpa` varchar(255) UNIQUE NOT NULL,
  `coverage` varchar(255)
);

CREATE TABLE `companies` (
  `company_id` uuid PRIMARY KEY NOT NULL,
  `company_name` varchar(255),
  `company_abbr` varchar(255)
);

CREATE TABLE `segments` (
  `segment_id` uuid PRIMARY KEY NOT NULL,
  `segment_name` varchar(255),
  `segment_abbr` varchar(255)
);

CREATE TABLE `evaluations` (
  `evaluation_id` uuid PRIMARY KEY NOT NULL,
  `evaluation_date` date UNIQUE NOT NULL
);

CREATE TABLE `vehicles` (
  `vehicle_id` uuid PRIMARY KEY NOT NULL COMMENT 'The vehicle\'s unique identifer and primary key.',
  `vehicle_vin_number` varchar(255) COMMENT 'VIN number for the vehicle.',
  `driver_id` uuid COMMENT 'Foreign key identity to the claimant whom acted as the driver (owner) of the vehicle.',
  `vehicle_make` varchar(255) COMMENT 'The make of the vehicle.',
  `vehicle_model` varchar(255) COMMENT 'The vehicle\'s model.',
  `vehicle_year` int COMMENT 'Year the vehicle was made/purchased.',
  `vehicle_color` varchar(255) COMMENT 'Color of the vehicle.',
  `vehicle_exposure_level` int COMMENT 'Exposure level (1,2, or 3) or the vehicle (i.e. passenger vehicles = 1, motor bikes = 2, and trucks = 3).',
  `vehicle_value` float COMMENT 'The value in USD ($) of the vehicle.'
);

ALTER TABLE `claimants` ADD FOREIGN KEY (`claimant_id`) REFERENCES `claims` (`claimant_id`);

ALTER TABLE `occurrences` ADD FOREIGN KEY (`occurrence_id`) REFERENCES `claims` (`occurrence_id`);

ALTER TABLE `policies` ADD FOREIGN KEY (`policy_id`) REFERENCES `claims` (`policy_id`);

ALTER TABLE `coverages` ADD FOREIGN KEY (`coverage_id`) REFERENCES `claims` (`coverage_id`);

ALTER TABLE `tpas` ADD FOREIGN KEY (`tpa_id`) REFERENCES `claims` (`tpa_id`);

ALTER TABLE `companies` ADD FOREIGN KEY (`company_id`) REFERENCES `claims` (`company_id`);

ALTER TABLE `segments` ADD FOREIGN KEY (`segment_id`) REFERENCES `claims` (`segment_id`);

ALTER TABLE `claim_evaluations` ADD FOREIGN KEY (`claim_id`) REFERENCES `claims` (`claim_id`);

ALTER TABLE `claim_evaluations` ADD FOREIGN KEY (`evaluation_date`) REFERENCES `evaluations` (`evaluation_date`);

ALTER TABLE `policies` ADD FOREIGN KEY (`coverage`) REFERENCES `coverages` (`coverage_abbr`);

ALTER TABLE `tpas` ADD FOREIGN KEY (`coverage`) REFERENCES `coverages` (`coverage_abbr`);

ALTER TABLE `vehicles` ADD FOREIGN KEY (`driver_id`) REFERENCES `claimants` (`claimant_id`);


ALTER TABLE `claims` COMMENT = 'Primary claims fact table listing idividual claim\'s measures such as amounts paid, reported, and reserved as well as the dimensional relationships to various claim attributes.';

ALTER TABLE `claim_evaluations` COMMENT = 'This table combines individual claims and their corresponding evaluation dates values. containing all combinations of claims and evaluation dates. This table represents a merged table containing all evaluation date lossuns for a given client or project.';

ALTER TABLE `claimants` COMMENT = 'The Claimants table represents all claimants that have appeared in the system over its lifetime. Claimants represent individuals that have filed claims in accordance with their policies and coverages.';

ALTER TABLE `occurrences` COMMENT = 'Occurrences represent groups of individual claims and group together all parties involved with a single occurrence or accident. Depending on the policy type, treatment of losses will either depend on occurrence based or claims based losses.';

ALTER TABLE `coverages` COMMENT = 'The coverages table lists all potential coverages and their abbrevations/codes in the given actuarial projects environment';

ALTER TABLE `policies` COMMENT = 'Policy details';
