CREATE TABLE [claim] (
  [claim_id] uniqueidentifier PRIMARY KEY NOT NULL DEFAULT (NEWID()),
  [claim_number] int UNIQUE NOT NULL IDENTITY(1, 1),
  [loss_date] date NOT NULL,
  [report_date] date NOT NULL,
  [close_date] date DEFAULT (NULL),
  [reopen_date] date DEFAULT (NULL),
  [reclose_date] date DEFAULT (NULL),
  [claimant_id] uniqueidentifier,
  [occurrence_id] uniqueidentifier,
  [policy_id] uniqueidentifier,
  [coverage_id] uniqueidentifier,
  [tpa_id] uniqueidentifier,
  [company_id] uniqueidentifier,
  [segment_id] uniqueidentifier,
  [accident_location_id] uniqueidentifier,
  [claim_status] varchar(10) NOT NULL DEFAULT 'O',
  [latest_transaction_id] uniqueidentifier NOT NULL,
  [total_paid] float NOT NULL,
  [total_case] float NOT NULL,
  [created_at] datetime NOT NULL DEFAULT (CURRENT_TIMESTAMP),
  [created_by] varchar(100) NOT NULL DEFAULT (CURRENT_USER),
  [modified_at] datetime NOT NULL DEFAULT (CURRENT_TIMESTAMP),
  [modified_by] varchar(100) NOT NULL DEFAULT (CURRENT_USER)
)
GO

CREATE TABLE [claim_transaction] (
  [transaction_id] uniqueidentifier UNIQUE PRIMARY KEY NOT NULL DEFAULT (NEWID()),
  [claim_id] uniqueidentifier NOT NULL,
  [transaction_date] date NOT NULL DEFAULT (GETUTCDATE()),
  [transaction_time] time NOT NULL DEFAULT (CURRENT_TIMESTAMP),
  [transaction_type] varchar(100) NOT NULL DEFAULT 'payment',
  [change_paid] float NOT NULL DEFAULT (0),
  [change_case] float NOT NULL DEFAULT (0),
  [change_status] varchar(100),
  [comment] text
)
GO

CREATE TABLE [location] (
  [location_id] uniqueidentifier UNIQUE PRIMARY KEY NOT NULL DEFAULT (NEWID()),
  [region] varchar(50),
  [country_code] varchar(10),
  [state_code] varchar(5),
  [city] varchar(100),
  [zip_code] char(5),
  [location_type] varchar(100)
)
GO

CREATE TABLE [evaluation] (
  [evaluation_date] DATE UNIQUE PRIMARY KEY NOT NULL,
  [evaluation_qtr] varchar(10) UNIQUE NOT NULL
)
GO

CREATE TABLE [lossrun] (
  [claim_id] uniqueidentifier NOT NULL,
  [evaluation_date] date NOT NULL,
  [status] varchar(5) NOT NULL,
  [total_paid] float NOT NULL DEFAULT (0),
  [total_case] float NOT NULL DEFAULT (0),
  PRIMARY KEY ([claim_id], [evaluation_date])
)
GO

CREATE TABLE [claimant] (
  [claimant_id] uniqueidentifier PRIMARY KEY,
  [first_name] VARCHAR(100),
  [last_name] VARCHAR(100),
  [claimant_age] INTEGER,
  [claimant_location] uniqueidentifier
)
GO

CREATE TABLE [occurrence] (
  [occurrence_id] uniqueidentifier PRIMARY KEY NOT NULL,
  [occurrence_number] int NOT NULL IDENTITY(1, 1),
  [number_of_claims] int,
  [default_claim_used] uniqueidentifier NOT NULL
)
GO

CREATE TABLE [coverage] (
  [coverage_id] uniqueidentifier PRIMARY KEY NOT NULL,
  [coverage] nvarchar(255) UNIQUE NOT NULL,
  [coverage_abbr] nvarchar(255) UNIQUE NOT NULL,
  [coverage_exposure_base] nvarchar(255) UNIQUE NOT NULL
)
GO

CREATE TABLE [policies] (
  [policy_id] uniqueidentifier PRIMARY KEY NOT NULL,
  [policy_type] nvarchar(255),
  [coverage] nvarchar(255),
  [start_date] date NOT NULL,
  [end_date] date NOT NULL,
  [policy_year] int,
  [start_end_text] nvarchar(255),
  [premium] numeric NOT NULL,
  [alae_treatment] nvarchar(255),
  [occ_claims_based] nvarchar(255)
)
GO

CREATE TABLE [tpas] (
  [tpa_id] uniqueidentifier PRIMARY KEY NOT NULL,
  [tpa] nvarchar(255) UNIQUE NOT NULL,
  [coverage] nvarchar(255)
)
GO

CREATE TABLE [companies] (
  [company_id] uniqueidentifier PRIMARY KEY NOT NULL,
  [company_name] nvarchar(255),
  [company_abbr] nvarchar(255)
)
GO

CREATE TABLE [segments] (
  [segment_id] uniqueidentifier PRIMARY KEY NOT NULL,
  [segment_name] nvarchar(255),
  [segment_abbr] nvarchar(255)
)
GO

CREATE TABLE [vehicles] (
  [vehicle_id] uniqueidentifier PRIMARY KEY NOT NULL,
  [vehicle_vin_number] nvarchar(255),
  [driver_id] uniqueidentifier,
  [vehicle_make] nvarchar(255),
  [vehicle_model] nvarchar(255),
  [vehicle_year] int,
  [vehicle_color] nvarchar(255),
  [vehicle_exposure_level] int,
  [vehicle_value] float
)
GO

ALTER TABLE [claim] ADD FOREIGN KEY ([claimant_id]) REFERENCES [claimant] ([claimant_id])
GO

ALTER TABLE [claim] ADD FOREIGN KEY ([occurrence_id]) REFERENCES [occurrence] ([occurrence_id])
GO

ALTER TABLE [claim] ADD FOREIGN KEY ([policy_id]) REFERENCES [policies] ([policy_id])
GO

ALTER TABLE [claim] ADD FOREIGN KEY ([coverage_id]) REFERENCES [coverage] ([coverage_id])
GO

ALTER TABLE [claim] ADD FOREIGN KEY ([tpa_id]) REFERENCES [tpas] ([tpa_id])
GO

ALTER TABLE [claim] ADD FOREIGN KEY ([company_id]) REFERENCES [companies] ([company_id])
GO

ALTER TABLE [claim] ADD FOREIGN KEY ([segment_id]) REFERENCES [segments] ([segment_id])
GO

ALTER TABLE [claim] ADD FOREIGN KEY ([accident_location_id]) REFERENCES [location] ([location_id])
GO

ALTER TABLE [claim_transaction] ADD FOREIGN KEY ([transaction_id]) REFERENCES [claim] ([latest_transaction_id])
GO

ALTER TABLE [claim_transaction] ADD FOREIGN KEY ([claim_id]) REFERENCES [claim] ([claim_id])
GO

ALTER TABLE [claim] ADD FOREIGN KEY ([claim_id]) REFERENCES [lossrun] ([claim_id])
GO

ALTER TABLE [lossrun] ADD FOREIGN KEY ([evaluation_date]) REFERENCES [evaluation] ([evaluation_date])
GO

ALTER TABLE [claimant] ADD FOREIGN KEY ([claimant_location]) REFERENCES [location] ([location_id])
GO

ALTER TABLE [occurrence] ADD FOREIGN KEY ([default_claim_used]) REFERENCES [claim] ([claim_id])
GO

ALTER TABLE [policies] ADD FOREIGN KEY ([coverage]) REFERENCES [coverage] ([coverage_abbr])
GO

ALTER TABLE [tpas] ADD FOREIGN KEY ([coverage]) REFERENCES [coverage] ([coverage_abbr])
GO

ALTER TABLE [vehicles] ADD FOREIGN KEY ([driver_id]) REFERENCES [claimant] ([claimant_id])
GO


EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = 'Primary claims fact table listing idividual claim"s measures
such as amounts paid, reported, and reserved as well as the 
dimensional relationships to various claim attributes.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'claim';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Unique indentifier for the individual claim. Primary Key of this table.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'claim',
@level2type = N'Column', @level2name = 'claim_id';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Another form of claim identification but using an auto-incrememnting
    integer based off creation date.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'claim',
@level2type = N'Column', @level2name = 'claim_number';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'The claim"s loss date, i.e. the date which the accident or
    insured event took place.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'claim',
@level2type = N'Column', @level2name = 'loss_date';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'The claim"s report date, i.e. the date which the claimant 
    reported the claim to the insurer/TPA.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'claim',
@level2type = N'Column', @level2name = 'report_date';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'The claim"s closure date, i.e. the date the claim"s 
    Status changes to Closed and case reserves are zeroed out.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'claim',
@level2type = N'Column', @level2name = 'close_date';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'The claim"s re-open date, i.e. the date a previosly 
    closed claim is re-opened.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'claim',
@level2type = N'Column', @level2name = 'reopen_date';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'The claim"s last closure date given it has been re-opened at least once.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'claim',
@level2type = N'Column', @level2name = 'reclose_date';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Identifier for the claim"s claimant. 
    References the claimants table > claimant_id field.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'claim',
@level2type = N'Column', @level2name = 'claimant_id';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Identifier for the claim"s occurrence, if applicable. 
    Occurrences group claims by accident or occurrence and depending 
    on the policy, occurrence or claims based reserving 
    should be used.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'claim',
@level2type = N'Column', @level2name = 'occurrence_id';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Identifer for the claims policy.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'claim',
@level2type = N'Column', @level2name = 'policy_id';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Identifier for the claim"s coverage (i.e. WC, AL, GL, MPL, PROP, etc.)',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'claim',
@level2type = N'Column', @level2name = 'coverage_id';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Identifier for the claim"s TPA (third party administer) 
    that provieded claim details.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'claim',
@level2type = N'Column', @level2name = 'tpa_id';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Identifier for the claim"s company or division, if applicable.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'claim',
@level2type = N'Column', @level2name = 'company_id';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Identifier for the claim"s segment, if applicable.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'claim',
@level2type = N'Column', @level2name = 'segment_id';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'foreign key to accident location.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'claim',
@level2type = N'Column', @level2name = 'accident_location_id';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = '- "O" for Open
- "C" for Closed
- "R" for Re-opened',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'claim',
@level2type = N'Column', @level2name = 'claim_status';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'From transaction table.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'claim',
@level2type = N'Column', @level2name = 'latest_transaction_id';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'The total paid to date amount for the claim.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'claim',
@level2type = N'Column', @level2name = 'total_paid';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'The total case reseres to date for the claim (should be zero on closed claims).',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'claim',
@level2type = N'Column', @level2name = 'total_case';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Creation date of the claims record.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'claim',
@level2type = N'Column', @level2name = 'created_at';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'User that created the claim.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'claim',
@level2type = N'Column', @level2name = 'created_by';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Last modification timestamp for the claim.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'claim',
@level2type = N'Column', @level2name = 'modified_at';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'User that last modified the claim.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'claim',
@level2type = N'Column', @level2name = 'modified_by';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = 'The Claim Transaction Table represents the transactional side 
of this data warehouse and should be kept in sync with the claim table.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'claim_transaction';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Unique identifier for a transaction.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'claim_transaction',
@level2type = N'Column', @level2name = 'transaction_id';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Many to one relationship between transactions and claims.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'claim_transaction',
@level2type = N'Column', @level2name = 'claim_id';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Date of the transaction. 
Should match with the corresponding claims modification dates.
This is how evaluated loss runs are created.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'claim_transaction',
@level2type = N'Column', @level2name = 'transaction_date';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Timestamp for the transaction.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'claim_transaction',
@level2type = N'Column', @level2name = 'transaction_time';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Comments about this transaction.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'claim_transaction',
@level2type = N'Column', @level2name = 'comment';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = 'The evaluation table represents all possible evaluation dates to analyze 
  the claims as of in the form of static loss runs.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'evaluation';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = 'This table combines individual claims and their corresponding 
evaluation dates values. containing all combinations of claims and evaluation
dates. This table represents a merged table containing all evaluation date 
lossuns for a given client or project.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'lossrun';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Claim Identifier',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'lossrun',
@level2type = N'Column', @level2name = 'claim_id';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Evaluation date the loss values are evaluated as of.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'lossrun',
@level2type = N'Column', @level2name = 'evaluation_date';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Claim status uses a custom ENUM user-defined data-type allowing only 
the values of O, C, or R for Open, Closed, or Re-Opened. Status can change 
between evaluation dates determining prior-to-current status levels. This is 
known as a "slowly changing dimention in data engineering (i.e. O->C is a 
closure, C->R is a re-opening, etc.)',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'lossrun',
@level2type = N'Column', @level2name = 'status';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Total cumulative paid as of the specified evaluation date. Should be 
less than reported and flagged if closed and $0 paid.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'lossrun',
@level2type = N'Column', @level2name = 'total_paid';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Total cumulative case reserves as of the evaluation date. 
Case plus paid determines reported amounts.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'lossrun',
@level2type = N'Column', @level2name = 'total_case';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = 'The Claimants table represents all claimants that have appeared 
in the system over its lifetime. Claimants represent individuals that have 
filed claims in accordance with their policies and coverages.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'claimant';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Claimant unique identier and primary key for this table.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'claimant',
@level2type = N'Column', @level2name = 'claimant_id';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Claimant first name.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'claimant',
@level2type = N'Column', @level2name = 'first_name';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Claimant last, or family, name.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'claimant',
@level2type = N'Column', @level2name = 'last_name';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Claimant"s age in years represented as an integer (i.e. 78 is 78
years old.)',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'claimant',
@level2type = N'Column', @level2name = 'claimant_age';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Claimant location',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'claimant',
@level2type = N'Column', @level2name = 'claimant_location';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = 'Occurrences represent groups of individual claims and group together all parties involved with a single occurrence or accident. Depending on the policy type, treatment of losses will either depend on occurrence based or claims based losses.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'occurrence';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Reference to the claim used to populate non-measure fields.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'occurrence',
@level2type = N'Column', @level2name = 'default_claim_used';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = 'The coverages table lists all potential coverages and their abbrevations/codes in the given actuarial projects environment',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'coverage';
GO

EXEC sp_addextendedproperty
@name = N'Table_Description',
@value = 'Policy details',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'policies';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'The vehicle"s unique identifer and primary key.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'vehicles',
@level2type = N'Column', @level2name = 'vehicle_id';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'VIN number for the vehicle.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'vehicles',
@level2type = N'Column', @level2name = 'vehicle_vin_number';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Foreign key identity to the claimant whom acted as the driver (owner) of the vehicle.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'vehicles',
@level2type = N'Column', @level2name = 'driver_id';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'The make of the vehicle.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'vehicles',
@level2type = N'Column', @level2name = 'vehicle_make';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'The vehicle"s model.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'vehicles',
@level2type = N'Column', @level2name = 'vehicle_model';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Year the vehicle was made/purchased.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'vehicles',
@level2type = N'Column', @level2name = 'vehicle_year';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Color of the vehicle.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'vehicles',
@level2type = N'Column', @level2name = 'vehicle_color';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'Exposure level (1,2, or 3) or the vehicle (i.e. passenger vehicles = 1, motor bikes = 2, and trucks = 3).',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'vehicles',
@level2type = N'Column', @level2name = 'vehicle_exposure_level';
GO

EXEC sp_addextendedproperty
@name = N'Column_Description',
@value = 'The value in USD ($) of the vehicle.',
@level0type = N'Schema', @level0name = 'dbo',
@level1type = N'Table',  @level1name = 'vehicles',
@level2type = N'Column', @level2name = 'vehicle_value';
GO
