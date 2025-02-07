resource "aws_dynamodb_table" "url-dynamodb-table" {
    name           = "url-table"
    billing_mode   = "PAY_PER_REQUEST"
    hash_key       = "short_id"
    #range_key      = "Genre"

  attribute {
    name = "short_id"
    type = "S"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = true
  }

  /* global_secondary_index {
    name               = "TitleIndex"
    hash_key           = "Title"
    range_key          = "Author"
    #write_capacity     = 10
    #read_capacity      = 10
    projection_type    = "ALL"
    #non_key_attributes = ["UserId"]
  } */

  tags = {
    Name        = "url-table"
    Environment = "dev"
  }
}