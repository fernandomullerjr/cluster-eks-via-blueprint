```markdown
# **RESUMO - Comandos para Criar e Destruir o Cluster EKS**

Este guia explica o processo de criação e destruição de um cluster EKS utilizando o Terraform. A execução é feita em etapas para garantir que os recursos sejam criados ou removidos de forma controlada, evitando erros de dependência entre os módulos. 

---

## **Criação do Cluster**

### **Comandos**
```bash
# 1. Criar a infraestrutura de rede (VPC)
terraform apply -target=module.vpc -auto-approve

# 2. Criar os recursos do cluster EKS (com o módulo eks_blueprints)
terraform apply -target=module.eks_blueprints -auto-approve

# 3. Aplicar os addons configurados no cluster EKS
terraform apply -target=module.addons -auto-approve

# 4. Aplicar os demais recursos dependentes
terraform apply -auto-approve
```

### **Explicação**
1. **`terraform apply -target=module.vpc`:**  
   Cria a infraestrutura de rede necessária para o cluster, garantindo que todas as sub-redes, gateways e rotas estejam configuradas antes de avançar.

2. **`terraform apply -target=module.eks_blueprints`:**  
   Configura o cluster EKS utilizando o módulo `eks_blueprints`. Isso inclui o controle do plano de dados e dos nós de trabalho.

3. **`terraform apply -target=module.addons`:**  
   Instala os addons configurados, como Prometheus, Grafana e dashboards, utilizando o `values-stack.yaml` para personalizar as opções.

4. **`terraform apply`:**  
   Conclui a aplicação de todos os recursos restantes que dependem da infraestrutura e do cluster criados nas etapas anteriores.

---

## **Destruição do Cluster**

### **Comandos**
```bash
# 1. Remover os addons configurados no cluster
terraform destroy -target=module.addons -auto-approve

# 2. Destruir os recursos do cluster EKS
terraform destroy -target=module.eks_blueprints -auto-approve

# 3. Destruir a infraestrutura de rede (VPC)
terraform destroy -target=module.vpc -auto-approve

# 4. Remover os demais recursos
terraform destroy -auto-approve
```

### **Explicação**
1. **`terraform destroy -target=module.addons`:**  
   Remove os addons instalados, garantindo que dependências relacionadas aos serviços, como Prometheus e Grafana, sejam removidas antes de destruir o cluster.

2. **`terraform destroy -target=module.eks_blueprints`:**  
   Apaga o cluster EKS, incluindo os nós de trabalho e recursos relacionados ao Kubernetes.

3. **`terraform destroy -target=module.vpc`:**  
   Após a remoção do cluster, a infraestrutura de rede (VPC) é destruída sem causar dependências não resolvidas.

4. **`terraform destroy`:**  
   Finaliza a remoção de quaisquer recursos restantes, limpando o ambiente.

---

## **Por que executar em etapas?**

- **Evitar erros de dependência:**  
  O Terraform organiza os recursos em um grafo de dependências. Forçar a aplicação ou destruição sem seguir a ordem correta pode resultar em falhas devido a recursos que ainda não existem ou já foram destruídos.

- **Isolamento de erros:**  
  Separar a criação e remoção em etapas facilita identificar problemas específicos com módulos como VPC ou EKS, permitindo depuração mais eficiente.

- **Manutenção da infraestrutura:**  
  Alguns recursos (como VPCs) têm dependências complexas. Executar etapas separadas ajuda a manter a consistência e integridade do ambiente.

---

## Observações Importantes

1. **Uso do `-auto-approve`**:
   - Remove a necessidade de confirmação manual
   - Útil em ambientes de CI/CD
   - Use com cautela em ambientes de produção

2. **Uso do `-target`**:
   - Permite executar ações em módulos específicos
   - Ajuda a controlar a ordem de criação/destruição
   - Importante para gerenciar dependências complexas


## **Observações Finais**

1. **Automatização:**  
   Este processo pode ser automatizado com scripts, mas é importante manter o controle para evitar erros.

2. **Planejamento:**  
   Antes de cada etapa, considere executar `terraform plan` para revisar as alterações que serão feitas.

3. **Uso do `-auto-approve`**:
   - Remove a necessidade de confirmação manual
   - Útil em ambientes de CI/CD
   - Use com cautela em ambientes de produção

4. **Segurança:**  
   Evite armazenar arquivos sensíveis, como estados ou variáveis, em locais não seguros.

5. **Uso do `-target`**:
   - Permite executar ações em módulos específicos
   - Ajuda a controlar a ordem de criação/destruição
   - Importante para gerenciar dependências complexas

Seguindo este guia, você terá maior controle sobre a criação e destruição do cluster EKS, minimizando erros e maximizando a eficiência operacional.
```