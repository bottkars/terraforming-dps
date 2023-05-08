variable "eks_count" {
    description = "the cout of eks clusters"
    type = number
    default= 0
}
variable "eks_cluster_name" {
    description = "the name ( prefix ) of the eks cluster"
    type = string
    default = "tfeks" 
}