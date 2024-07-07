output "ecr_repository_url" {
  value = aws_ecr_repository.ecr.repository_url
}

output "eks_cluster_id" {
  value = aws_eks_cluster.eks.id
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.eks.endpoint
}

output "eks_cluster_version" {
  value = aws_eks_cluster.eks.version
}
