# Makefile para gerenciar a criação e destruição de um cluster EKS com Terraform
# Inclui cores para facilitar a identificação das mensagens.

# Variáveis
TF := terraform                 # Comando do Terraform
AUTO_APPROVE := -auto-approve   # Flag para evitar prompts de confirmação
TARGET_VPC := -target=module.vpc                      # Target específico para a VPC
TARGET_EKS := -target=module.eks_blueprints           # Target específico para o cluster EKS
TARGET_ADDONS := -target=module.kubernetes_addons     # Target específico para os addons Kubernetes

# Cores
COLOR_RESET := \033[0m
COLOR_INFO := \033[1;34m    # Azul
COLOR_SUCCESS := \033[1;32m # Verde
COLOR_WARNING := \033[1;33m # Amarelo
COLOR_ERROR := \033[1;31m   # Vermelho

# Regras principais
.PHONY: all apply destroy clean plan grafana prometheus

# Regra principal: por padrão, mostra os comandos disponíveis
all:
	@echo "$(COLOR_INFO)Comandos disponíveis:$(COLOR_RESET)"
	@echo "$(COLOR_SUCCESS)  make apply$(COLOR_RESET)       - Cria os recursos Terraform de forma faseada"
	@echo "$(COLOR_SUCCESS)  make destroy$(COLOR_RESET)     - Remove os recursos Terraform de forma faseada"
	@echo "$(COLOR_SUCCESS)  make clean$(COLOR_RESET)       - Remove arquivos temporários do Terraform"
	@echo "$(COLOR_SUCCESS)  make plan$(COLOR_RESET)        - Mostra o plano de execução completo"
	@echo "$(COLOR_SUCCESS)  make grafana$(COLOR_RESET)     - Realiza o port-forward para o Grafana"
	@echo "$(COLOR_SUCCESS)  make prometheus$(COLOR_RESET)  - Realiza o port-forward para o Prometheus"

# Criação dos recursos (apply)
apply: apply-vpc apply-eks apply-addons apply-all

apply-vpc:
	@echo "$(COLOR_INFO)==> Aplicando a infraestrutura de rede (VPC)...$(COLOR_RESET)"
	$(TF) apply $(TARGET_VPC) $(AUTO_APPROVE)
	@echo "$(COLOR_SUCCESS)VPC criada com sucesso.$(COLOR_RESET)"

apply-eks:
	@echo "$(COLOR_INFO)==> Aplicando o cluster EKS...$(COLOR_RESET)"
	$(TF) apply $(TARGET_EKS) $(AUTO_APPROVE)
	@echo "$(COLOR_SUCCESS)Cluster EKS criado com sucesso.$(COLOR_RESET)"

apply-addons:
	@echo "$(COLOR_INFO)==> Aplicando os addons Kubernetes...$(COLOR_RESET)"
	$(TF) apply $(TARGET_ADDONS) $(AUTO_APPROVE)
	@echo "$(COLOR_SUCCESS)Addons aplicados com sucesso.$(COLOR_RESET)"

apply-all:
	@echo "$(COLOR_INFO)==> Aplicando os demais recursos...$(COLOR_RESET)"
	$(TF) apply $(AUTO_APPROVE)
	@echo "$(COLOR_SUCCESS)Todos os recursos aplicados com sucesso.$(COLOR_RESET)"

# Destruição dos recursos (destroy)
destroy: destroy-addons destroy-eks destroy-vpc destroy-all

destroy-addons:
	@echo "$(COLOR_WARNING)==> Removendo os addons Kubernetes...$(COLOR_RESET)"
	$(TF) destroy $(TARGET_ADDONS) $(AUTO_APPROVE)
	@echo "$(COLOR_SUCCESS)Addons removidos com sucesso.$(COLOR_RESET)"

destroy-eks:
	@echo "$(COLOR_WARNING)==> Removendo o cluster EKS...$(COLOR_RESET)"
	$(TF) destroy $(TARGET_EKS) $(AUTO_APPROVE)
	@echo "$(COLOR_SUCCESS)Cluster EKS removido com sucesso.$(COLOR_RESET)"

destroy-vpc:
	@echo "$(COLOR_WARNING)==> Removendo a infraestrutura de rede (VPC)...$(COLOR_RESET)"
	$(TF) destroy $(TARGET_VPC) $(AUTO_APPROVE)
	@echo "$(COLOR_SUCCESS)VPC removida com sucesso.$(COLOR_RESET)"

destroy-all:
	@echo "$(COLOR_WARNING)==> Removendo os demais recursos...$(COLOR_RESET)"
	$(TF) destroy $(AUTO_APPROVE)
	@echo "$(COLOR_SUCCESS)Todos os recursos removidos com sucesso.$(COLOR_RESET)"

# Limpeza de arquivos temporários
clean:
	@echo "$(COLOR_INFO)==> Limpando arquivos temporários do Terraform...$(COLOR_RESET)"
	rm -rf .terraform/ terraform.tfstate terraform.tfstate.backup .terraform.lock.hcl
	@echo "$(COLOR_SUCCESS)Arquivos temporários limpos com sucesso.$(COLOR_RESET)"

# Mostra o plano de execução completo
plan:
	@echo "$(COLOR_INFO)==> Exibindo o plano de execução...$(COLOR_RESET)"
	$(TF) plan
	@echo "$(COLOR_SUCCESS)Plano exibido com sucesso.$(COLOR_RESET)"

# Comando para Port-Forward do Grafana
grafana:
	@echo "$(COLOR_INFO)==> Realizando port-forward para o Grafana...$(COLOR_RESET)"
	kubectl port-forward $$(kubectl get pods --selector app.kubernetes.io/name=grafana -n kube-prometheus-stack -o=name) -n kube-prometheus-stack --address 0.0.0.0 8080:3000
	@echo "$(COLOR_SUCCESS)Port-forward para Grafana disponível em http://localhost:8080$(COLOR_RESET)"

# Comando para Port-Forward do Prometheus
prometheus:
	@echo "$(COLOR_INFO)==> Realizando port-forward para o Prometheus...$(COLOR_RESET)"
	kubectl port-forward $$(kubectl get pods --selector app.kubernetes.io/name=prometheus -n kube-prometheus-stack -o=name) -n kube-prometheus-stack --address 0.0.0.0 9191:9090
	@echo "$(COLOR_SUCCESS)Port-forward para Prometheus disponível em http://localhost:9191$(COLOR_RESET)"
