library(mockaRoo)
library(uuid)

basicSchema <- data.frame(
  claimant_id = uuid::UUIDgenerate(n = 1),
  claimant_first_name = "John",
  claimant_last_name = "Doe"
)

response <- mockaRoo::mockaroo("csv", list(key = "de7c9b30", count = 10), schema = jsonlite::toJSON(basicSchema))

jsonlite::prettify(response)


mockaRoo::mockaroo()

claimants <-

  search_ghr("mockaroo")

basicSchema<-list(
  name = "blah"
  , percentBlank = 0
  , type = "Color"
)

library(mockaRoo)

mockaRoo::mockaroo("json"
                   , list( key = "de7c9b30"
                           , count = 10)
                   , schema = jsonlite::toJSON(basicSchema)
)
