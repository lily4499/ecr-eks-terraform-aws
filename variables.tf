variable "ecr_repository_name" {
  description = "The name of the ECR repository"
  type        = string
  default     = "jobentry"
}

variable "eks_cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  default     = "lili-eks-cluster"
}

variable "eks_node_group_name" {
  description = "The name of the EKS node group"
  type        = string
  default     = "lili-eks-node-group"
}

variable "eks_node_instance_type" {
  description = "List of instance types for the EKS node group"
  type        = list(string)
  default     = ["t3.medium"] # Example default value, adjust as needed
}


variable "eks_desired_capacity" {
  description = "The desired capacity of the EKS node group"
  type        = number
  default     = 2
}

variable "eks_max_size" {
  description = "The max size of the EKS node group"
  type        = number
  default     = 3
}

variable "eks_min_size" {
  description = "The min size of the EKS node group"
  type        = number
  default     = 1
}
