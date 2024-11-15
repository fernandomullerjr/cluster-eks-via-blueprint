# Encontra o usuário atualmente em uso pela AWS
data "aws_caller_identity" "current" {}

# Região na qual a solução será implantada
data "aws_region" "current" {}

# Zonas de disponibilidade a serem usadas em nossa solução
data "aws_availability_zones" "available" {
  state = "available"
}

# Detalhes do cluster EKS
data "aws_eks_cluster" "cluster" {
  name = module.eks_blueprints.eks_cluster_id
}

# Detalhes de autenticação do cluster EKS
data "aws_eks_cluster_auth" "this" {
  name = module.eks_blueprints.eks_cluster_id
}
