# Configuração do provedor Kubernetes
provider "kubernetes" {
  host                   = module.eks_blueprints.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks_blueprints.eks_cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.this.token
}

# Configuração do provedor Helm
provider "helm" {
  kubernetes {
    host                   = module.eks_blueprints.eks_cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks_blueprints.eks_cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}

# Configuração do provedor Kubectl
provider "kubectl" {
  apply_retry_count      = 10
  host                   = module.eks_blueprints.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks_blueprints.eks_cluster_certificate_authority_data)
  load_config_file       = false
  token                  = data.aws_eks_cluster_auth.this.token
}

# Módulo EKS Blueprints
module "eks_blueprints" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints?ref=v4.21.0"

  cluster_name = local.name

  # Configuração obrigatória do VPC e Subnet do cluster EKS
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnets

  # Variáveis do plano de controle do EKS
  cluster_version = local.cluster_version

  # Lista de funções adicionais com permissões de administrador no cluster
  # Comente esta seção se você NÃO estiver em um evento da AWS, pois a TeamRole não existirá no seu site, ou substitua por qualquer função válida que você desejar
  map_roles = [
    {
      rolearn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/TeamRole"
      username = "ops-role"         # Nome de usuário dentro do Kubernetes para mapear para a função IAM
      groups   = ["system:masters"] # Lista de grupos dentro do Kubernetes aos quais a função é mapeada; Verifique Role e Rolebindings do K8s
    },
    {
      rolearn  = "arn:aws:iam::552925778543:role/eks-admin"
      username = "eks-admin"
      groups   = ["system:masters"]
    }
  ]

  # Lista de usuários mapeados
  map_users = [
    {
      userarn  = data.aws_caller_identity.current.arn                          # ARN do usuário IAM a ser adicionado
      username = "fernandomullerjr8596"                                        # Nome de usuário dentro do Kubernetes para mapear para a função IAM
      groups   = ["system:masters", "eks-console-dashboard-full-access-group"] # Lista de grupos dentro do Kubernetes aos quais o usuário é mapeado; Verifique Role e Rolebindings do K8s
    },
    {
      userarn  = "arn:aws:iam::552925778543:user/fernando" # ARN do usuário IAM a ser adicionado
      username = "fernando-devops"                         # Nome de usuário dentro do Kubernetes para mapear para a função IAM
      groups   = ["system:masters", "eks-console-dashboard-full-access-group"]
    },
    {
      userarn  = "arn:aws:iam::552925778543:root" # ARN do usuário IAM a ser adicionado
      username = "root"                           # Nome de usuário dentro do Kubernetes para mapear para a função IAM
      groups   = ["system:masters", "eks-console-dashboard-full-access-group"]
    }
  ]

  # EKS MANAGED NODE GROUPS
  managed_node_groups = {
    T3A_MICRO = {
      node_group_name = local.node_group_name
      instance_types  = ["t3a.micro"]
      subnet_ids      = module.vpc.private_subnets
    }
  }

  # teams
  platform_teams = {
    admin = {
      users = [
        data.aws_caller_identity.current.arn, "arn:aws:iam::552925778543:user/fernando", "arn:aws:iam::552925778543:root"
      ]
    }
  }

  tags = local.tags
}



# VPC

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.14.0"

  name = local.name
  cidr = local.vpc_cidr

  azs             = local.azs
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 10)]

  enable_nat_gateway   = true
  create_igw           = true
  enable_dns_hostnames = true
  single_nat_gateway   = true

  # Manage so we can name
  manage_default_network_acl    = true
  default_network_acl_tags      = { Name = "${local.name}-default" }
  manage_default_route_table    = true
  default_route_table_tags      = { Name = "${local.name}-default" }
  manage_default_security_group = true
  default_security_group_tags   = { Name = "${local.name}-default" }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.name}" = "shared"
    "kubernetes.io/role/elb"              = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.name}" = "shared"
    "kubernetes.io/role/internal-elb"     = "1"
  }

  tags = local.tags
}



# Manifestos

resource "kubectl_manifest" "rbac" {
  yaml_body = <<-YAML
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRole
    metadata:
      name: eks-console-dashboard-full-access-clusterrole
    rules:
    - apiGroups:
      - ""
      resources:
      - nodes
      - namespaces
      - pods
      - configmaps
      - endpoints
      - events
      - limitranges
      - persistentvolumeclaims
      - podtemplates
      - replicationcontrollers
      - resourcequotas
      - secrets
      - serviceaccounts
      - services
      verbs:
      - get
      - list
    - apiGroups:
      - apps
      resources:
      - deployments
      - daemonsets
      - statefulsets
      - replicasets
      verbs:
      - get
      - list
    - apiGroups:
      - batch
      resources:
      - jobs
      - cronjobs
      verbs:
      - get
      - list
    - apiGroups:
      - coordination.k8s.io
      resources:
      - leases
      verbs:
      - get
      - list
    - apiGroups:
      - discovery.k8s.io
      resources:
      - endpointslices
      verbs:
      - get
      - list
    - apiGroups:
      - events.k8s.io
      resources:
      - events
      verbs:
      - get
      - list
    - apiGroups:
      - extensions
      resources:
      - daemonsets
      - deployments
      - ingresses
      - networkpolicies
      - replicasets
      verbs:
      - get
      - list
    - apiGroups:
      - networking.k8s.io
      resources:
      - ingresses
      - networkpolicies
      verbs:
      - get
      - list
    - apiGroups:
      - policy
      resources:
      - poddisruptionbudgets
      verbs:
      - get
      - list
    - apiGroups:
      - rbac.authorization.k8s.io
      resources:
      - rolebindings
      - roles
      verbs:
      - get
      - list
    - apiGroups:
      - storage.k8s.io
      resources:
      - csistoragecapacities
      verbs:
      - get
      - list
    ---
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRoleBinding
    metadata:
      name: eks-console-dashboard-full-access-binding
    subjects:
    - kind: Group
      name: eks-console-dashboard-full-access-group
      apiGroup: rbac.authorization.k8s.io
    roleRef:
      kind: ClusterRole
      name: eks-console-dashboard-full-access-clusterrole
      apiGroup: rbac.authorization.k8s.io
  YAML

  depends_on = [
    module.eks_blueprints
  ]
}