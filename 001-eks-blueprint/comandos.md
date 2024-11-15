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

# 3. Aplicar os demais recursos dependentes
terraform apply -auto-approve
```

### **Explicação**
1. **`terraform apply -target=module.vpc`:**  
   Este comando cria exclusivamente a infraestrutura de rede (VPC) que será usada pelo cluster EKS. Executá-lo isoladamente é importante porque o cluster EKS depende da VPC estar configurada corretamente.

2. **`terraform apply -target=module.eks_blueprints`:**  
   Após a criação da VPC, o próximo passo é provisionar o cluster EKS. Isso inclui o controle de planos de dados e nós de trabalho, usando o módulo `eks_blueprints`. Este comando garante que apenas os recursos relacionados ao EKS sejam criados neste momento.

3. **`terraform apply`:**  
   Finalmente, os recursos adicionais que dependem do EKS e da VPC são aplicados. Este comando utiliza o restante do plano Terraform, assegurando que todas as dependências já estejam configuradas.

---

## **Destruição do Cluster**

### **Comandos**
```bash
# 1. Destruir os recursos do cluster EKS
terraform destroy -target=module.eks_blueprints -auto-approve

# 2. Destruir a infraestrutura de rede (VPC)
terraform destroy -target=module.vpc -auto-approve

# 3. Remover os demais recursos
terraform destroy -auto-approve
```

### **Explicação**
1. **`terraform destroy -target=module.eks_blueprints`:**  
   Este comando remove os recursos do cluster EKS, como nós de trabalho e controladores. É crucial destruir o cluster antes da VPC, pois o EKS depende da rede para funcionar.

2. **`terraform destroy -target=module.vpc`:**  
   Após destruir o cluster, a infraestrutura de rede (VPC) é removida. Como o cluster já foi apagado, a VPC pode ser destruída sem causar conflitos.

3. **`terraform destroy`:**  
   Por último, quaisquer recursos adicionais que não foram destruídos nos passos anteriores são removidos. Isso garante que o ambiente seja completamente limpo.

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