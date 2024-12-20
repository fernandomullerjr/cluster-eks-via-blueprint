<h1 align="center"> Cluster EKS via Terraform usando Blueprint </h1>

![Amazon EKS + Terraform](https://github.com/fernandomullerjr/cluster-eks-via-blueprint/blob/main/outros/imagens/amazon-eks-plus-terraform.png?raw=true)


## Descrição do projeto 

<p align="justify">
  Coleção de projetos que efetuam o deploy de um cluster EKS usando o Terraform.<br/>
  Idéia deste repositório é fornecer manifestos testados e validados, contendo alguns cenários de clusters EKS que podemos precisar.<br/>
  Alguns projetos vão utilizar Blueprints, outros terão os manifestos separados, alguns terão uma pipeline que efetua o deploy dependendo da ação e a trigger.<br/>
</p>


## :hammer: Projetos - EKS + Terraform

[Lab 001 - EKS via Blueprint + RBAC](001-eks-blueprint/README.md)
<details> 
  <summary><b>Detalhes sobre o projeto</b> <em>(clique para visualizar)</em></summary>
Projeto que cria um Cluster EKS via Terraform, usando Blueprint do EKS.<br/>
Já efetua a criação da estrutura de RBAC (ClusterRole, ClusterRoleBinding, ClusterRole), aplicando os devidos manifestos.<br/>
Também adiciona 2 usuários(usuário root e um usuário comum) como administradores, fazendo uso do "Teams", que é um recurso que facilita a criação de acesso ao cluster.<br/>
</details>


[Lab 002 - EKS via Blueprint + RBAC + Stack do Grafana + Prometheus +AlertManager + Dashboards extras](002-eks-blueprint-com-grafana/README.md)
<details> 
  <summary><b>Detalhes sobre o projeto</b> <em>(clique para visualizar)</em></summary>
Projeto que cria um Cluster EKS via Terraform, usando Blueprint do EKS.<br/>
Já efetua a criação da estrutura de RBAC (ClusterRole, ClusterRoleBinding, ClusterRole), aplicando os devidos manifestos.<br/>
Também adiciona 2 usuários(usuário root e um usuário comum) como administradores, fazendo uso do "Teams", que é um recurso que facilita a criação de acesso ao cluster.<br/>
Efetua a instalação da stack kube-prometheus-stack, contendo:<br/>
Prometheus<br/>
Grafana<br/>
AlertManager<br/>
Grafana Dashboards<br/>
São adicionados diversos dashboards úteis ao Grafana, que ajudam no gerenciamento dos clusters Kubernetes.<br/><br/>
</details>


---

> Status dos Projetos: :warning: (em fase de melhorias, em breve serão adicionados novos projetos de exemplo)
