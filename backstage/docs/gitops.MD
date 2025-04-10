- [GitOps - Apresentação](#gitops---apresentação)
- [Principais características do GitOps](#principais-características-do-gitops)
  - [1. Configuração Declarativa](#1-configuração-declarativa)
  - [2. Controle de Versão](#2-controle-de-versão)
  - [3. Fluxos de Trabalho Automatizados](#3-fluxos-de-trabalho-automatizados)
  - [4. Reconciliação Contínua](#4-reconciliação-contínua)
  - [5. Segurança e Conformidade](#5-segurança-e-conformidade)
  - [6. Escalabilidade e Resiliência](#6-escalabilidade-e-resiliência)
- [Modelos de abordagens com GitOps](#modelos-de-abordagens-com-gitops)
  - [1. Modelo baseado em Pull](#1-modelo-baseado-em-pull)
  - [2. Modelo baseado em Push](#2-modelo-baseado-em-push)
    - [Vantagens](#vantagens)
    - [Desvantagens](#desvantagens)

# GitOps - Apresentação

GitOps é uma prática de operações de TI que usa repositórios Git como fonte de verdade para a gestão e automação de infraestrutura e aplicativos. Ele permite a automação de fluxos de trabalho de CI/CD e facilita a governança, auditoria e segurança das operações.

Principais benefícios do GitOps:

- Consistência e padronização : usar o Git como única fonte de verdade garante que todas as alterações sejam rastreadas e possam ser auditadas.

- Implantações automatizadas : alterações no repositório acionam fluxos de trabalho automatizados para implantar e configurar a infraestrutura.

- Colaboração aprimorada : os recursos de colaboração do Git, como solicitações de pull e revisões de código, aprimoram a colaboração da equipe.

- Segurança aprimorada : todas as alterações são registradas no Git, fornecendo uma trilha de auditoria detalhada e facilitando o controle de acesso baseado em funções.

# Principais características do GitOps

## 1. Configuração Declarativa

A configuração declarativa é um princípio fundamental do GitOps. Em vez de especificar os passos exatos para atingir um estado desejado, a configuração descreve apenas o estado final que deve ser alcançado.

- Estado final descrito em arquivos de configuração: O código de infraestrutura, como Kubernetes YAMLs, Helm charts, ou outros arquivos de configuração, é versionado no repositório Git.

- Automatização da gestão de estado: Ferramentas GitOps podem garantir que o estado da infraestrutura ou aplicativo esteja sempre alinhado com o estado declarado no repositório Git.

## 2. Controle de Versão

GitOps tira proveito do Git, que já é um sistema de controle de versão amplamente utilizado, para gerenciar e versionar configurações de infraestrutura e aplicativos.

- Auditoria e rastreabilidade: Cada mudança realizada é registrada como um commit, permitindo auditoria completa e rastreamento de quem fez as mudanças e por quê.

- Rollback fácil: Em caso de falhas, é possível reverter para versões anteriores com facilidade, proporcionando segurança e confiabilidade.

- Colaboração: Equipes podem colaborar em mudanças de infraestrutura de forma mais eficaz usando práticas conhecidas de gerenciamento de código.

## 3. Fluxos de Trabalho Automatizados

GitOps promove a automação em todos os estágios de gerenciamento de infraestrutura e aplicativos.

- Integração contínua e entrega contínua (CI/CD): Mudanças feitas no repositório Git disparam automaticamente pipelines de CI/CD que aplicam essas mudanças na infraestrutura e nos aplicativos.

- Fluxos de trabalho consistentes e previsíveis: A automação reduz erros humanos e garante que todos os processos sigam um fluxo de trabalho controlado, desde a criação de novos recursos até atualizações e deploys.
  
## 4. Reconciliação Contínua

A reconciliação contínua é o processo pelo qual o sistema de GitOps monitora constantemente a infraestrutura e os aplicativos para garantir que eles correspondam ao estado descrito no repositório Git.

- Monitoramento constante: Ferramentas GitOps, como ArgoCD ou Flux, constantemente verificam se o estado atual da infraestrutura e aplicativos está de acordo com as configurações do Git.

- Correção automática: Se uma discrepância for detectada, o sistema pode automaticamente corrigir o estado da infraestrutura para alinhá-la com o que está no Git.

## 5. Segurança e Conformidade

A segurança é uma característica central do GitOps, já que a infraestrutura e os aplicativos são gerenciados através de um repositório Git.

- Controle de acesso baseado em Git: O controle de acesso ao repositório Git permite que apenas usuários autorizados possam modificar configurações, garantindo que as alterações sejam feitas de forma controlada.

- Auditabilidade: A capacidade de auditar mudanças feitas diretamente no repositório Git, sem a necessidade de outras ferramentas, aumenta a segurança e conformidade.
  
## 6. Escalabilidade e Resiliência

GitOps facilita a gestão de ambientes em grande escala, principalmente em sistemas distribuídos como Kubernetes.

- Gerenciamento de múltiplos clusters: É possível gerenciar múltiplos clusters e ambientes de forma centralizada através de um único repositório Git.

- Resiliência a falhas: Caso algo dê errado, a reconciliação contínua pode restaurar automaticamente o estado desejado, garantindo a continuidade e resiliência do sistema.

# Modelos de abordagens com GitOps

## 1. Modelo baseado em Pull

O modelo baseado em pull oferece detecção de desvios e autocorreção, pois o cluster "puxa" continuamente o estado desejado do Git.

## 2. Modelo baseado em Push

A abordagem baseada em push depende de ferramentas de CI/CD para enviar atualizações para o cluster sempre que as alterações forem confirmadas.

### Vantagens

- Simples: Com ferramentas de CI/CD para implementar essa abordagem - não há necessidade de um operador GitOps adicional, como o ArgoCD
  
- One-Stop-Shop: As ferramentas de CI/CD simplificam todo o processo para você criar, testar e implantar seu aplicativo.

### Desvantagens

- Não é um verdadeiro pull-based: Ao contrário das ferramentas GitOps baseadas em pull, como o Argo CD, essa abordagem não tem "reconciliação contínua". Isso significa que o estado do cluster não é monitorado automaticamente e reconciliado com o estado desejado no Git.

- Sem detecção de desvio: Se alguém modificar manualmente os recursos no cluster, essas alterações não serão revertidas automaticamente para corresponder ao repositório Git. Isso pode levar a desvios de configuração ao longo do tempo.

- Segurança: Para permitir que o GitHub Actions seja implantado no seu cluster, você deve armazenar as credenciais do cluster em segredos do GitHub ou usar um método de autenticação baseado em OIDC. Ambas as abordagens exigem um manuseio cuidadoso para evitar riscos à segurança.
