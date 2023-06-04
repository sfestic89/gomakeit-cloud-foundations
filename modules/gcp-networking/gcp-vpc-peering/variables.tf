variable "peerings" {
    type = map(object({
        name = string
        network = string
        peer_network = string
    }))
}
