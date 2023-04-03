variable "edgerc_path" {
  type    = string
  default = "~/.edgerc"
}

variable "config_section" {
  type    = string
  default = "betajam"
}

variable "env" {
  type    = string
  default = "staging"
}

variable "tf_include" {
  type = string  
}
