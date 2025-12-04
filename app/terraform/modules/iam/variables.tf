
variable "tags" {
  type = map(string)
  default = {}
}

variable "region" {
  type        = string
  description = "AWS region"
}
