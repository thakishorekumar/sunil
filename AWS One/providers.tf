provider "aws" {
  alias   = "primary"
  region  = "ap-south-1"
  profile = "ellwin"
}

provider "aws" {
  alias   = "secondary"
  region  = "ap-south-2"
  profile = "ellwin"
}
