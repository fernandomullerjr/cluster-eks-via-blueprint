

# LAB 001 - EKS via Blueprint

## Descrição
Projeto que cria um Cluster EKS via Terraform usando Blueprint do EKS.<br/>
Já efetua a criação da estrutura de RBAC (ClusterRole, ClusterRoleBinding, ClusterRole), aplicando os devidos manifestos.<br/>
Também adiciona 2 usuários(usuário root e um usuário comum) como administradores, fazendo uso do "Teams", que é um recurso que facilita a criação de acesso ao cluster.<br/>

## Blueprint
Blueprint utilizado como referência:<br/>
<https://catalog.workshops.aws/eks-blueprints-terraform/en-US><br/>

## Teams
Um pouco mais sobre o Teams:<br/>
<https://aws-ia.github.io/terraform-aws-eks-blueprints/teams/><br/>



## Procedimento para uso básico

## **Introdução**

Este projeto utiliza um **Makefile** para facilitar a criação e destruição de recursos Terraform de forma faseada. O objetivo é evitar problemas de dependência entre módulos e simplificar a execução dos comandos mais comuns.

As cores no terminal ajudam a identificar o progresso das etapas, separando mensagens informativas, de sucesso e de alerta.

---

## **Pré-requisitos**

Antes de usar o Makefile, certifique-se de que:
1. O **Terraform** esteja instalado na sua máquina:
   ```bash
   terraform -v
   ```
2. Você tenha configurado as credenciais da AWS corretamente.
3. O arquivo `terraform.tfstate` e os módulos estejam configurados no diretório do projeto.

---

## **Comandos disponíveis**

### **1. `make all`**
Exibe os comandos disponíveis no Makefile e uma breve descrição do que cada um faz.

---

### **2. `make apply`**
Executa a criação dos recursos Terraform em três etapas:
1. **Rede (VPC):** Cria a infraestrutura de rede.
2. **Cluster EKS:** Cria o cluster Kubernetes.
3. **Recursos adicionais:** Aplica todos os demais recursos configurados no Terraform.

**Exemplo de uso:**
```bash
make apply
```

---

### **3. `make destroy`**
Executa a destruição dos recursos Terraform em ordem inversa:
1. **Cluster EKS:** Remove o cluster Kubernetes.
2. **Rede (VPC):** Remove a infraestrutura de rede.
3. **Recursos adicionais:** Remove os recursos restantes.

**Exemplo de uso:**
```bash
make destroy
```

---

### **4. `make clean`**
Remove arquivos temporários gerados pelo Terraform, como:
- `.terraform/`
- `terraform.tfstate`
- `terraform.tfstate.backup`
- `.terraform.lock.hcl`

**Exemplo de uso:**
```bash
make clean
```

---

### **5. `make plan`**
Exibe o plano de execução do Terraform, detalhando as ações que serão realizadas (criação, atualização ou destruição de recursos).

**Exemplo de uso:**
```bash
make plan
```

---

## **Execução faseada: Por que usar?**

O Makefile divide a execução em fases para:
1. **Evitar dependências:** Alguns recursos, como a VPC, precisam estar disponíveis antes de criar o cluster EKS.
2. **Garantir controle:** Permite ajustar ou depurar cada fase separadamente.
3. **Prevenir erros:** Uma execução completa pode falhar devido a dependências não satisfeitas. A execução faseada reduz esse risco.

---

## **Exemplo de fluxo de uso**

1. **Aplicar recursos:**
   ```bash
   make apply
   ```

2. **Remover recursos:**
   ```bash
   make destroy
   ```

3. **Limpar arquivos temporários:**
   ```bash
   make clean
   ```

4. **Exibir o plano de execução:**
   ```bash
   make plan
   ```

---

### **Exemplo de saída no terminal**

**Para `make apply`:**
```plaintext
==> Aplicando a infraestrutura de rede (VPC)...
VPC criada com sucesso.
==> Aplicando o cluster EKS...
Cluster EKS criado com sucesso.
==> Aplicando os demais recursos...
Todos os recursos aplicados com sucesso.
```

**Para `make destroy`:**
```plaintext
==> Removendo o cluster EKS...
Cluster EKS removido com sucesso.
==> Removendo a infraestrutura de rede (VPC)...
VPC removida com sucesso.
==> Removendo os demais recursos...
Todos os recursos removidos com sucesso.
```

---

## **Cores no terminal**

As cores no terminal ajudam a identificar o progresso:
- **Azul (Informação):** Início de uma fase ou etapa.
- **Verde (Sucesso):** Etapa concluída com sucesso.
- **Amarelo (Aviso):** Etapas delicadas, como destruição de recursos.

---

## **Contribuições**

Se encontrar problemas ou desejar melhorar o Makefile, sinta-se à vontade para abrir uma *pull request* ou relatar um *issue*.

---

Com este **Makefile** e **README**, o gerenciamento de recursos Terraform se torna mais prático e seguro! 🎯