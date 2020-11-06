terraform {
  required_providers {
    packet = {
      source = "packethost/packet"
    }
    template = {
      source = "hashicorp/template"
    }
  }
  required_version = ">= 0.13"
}
