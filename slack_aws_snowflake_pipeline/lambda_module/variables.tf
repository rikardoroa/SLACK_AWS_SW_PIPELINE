variable "time_out"{
    description = "aprovisioning image time out"
    type = string 
    default = "sleep 10"
}


variable "curated_bucket" {
    description = "curated bucket"
    type = string
    default = "awscalivemarketinsightsnp-ap-curated"
}


variable  "kms_key_arn" {
  type  = string
}


variable "aws_region"{
  description = "aws region"
  type = string
  default = "us-east-2"

}