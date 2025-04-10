- [ArgoCD - GitOps baseado em pull](#argocd---gitops-baseado-em-pull)
  - [Vantagens](#vantagens)
- [Produtos - Argo](#produtos---argo)
- [ArgoCD](#argocd)
  - [Formas de acesso](#formas-de-acesso)
    - [CLI](#cli)
    - [UI](#ui)
  - [Funcionamento](#funcionamento)
  - [Formas de deploy de aplicações](#formas-de-deploy-de-aplicações)
  - [Funcionalidades e Features](#funcionalidades-e-features)
    - [Breaking Glass](#breaking-glass)
    - [Feature Flag](#feature-flag)
    - [Sync](#sync)
    - [Pruning](#pruning)
    - [Self-Healing](#self-healing)
    - [Sync Options](#sync-options)
- [Argo Events](#argo-events)
  - [O que é o Argo Events?](#o-que-é-o-argo-events)
    - [Funcionalidades](#funcionalidades)
    - [Vantagens](#vantagens-1)
    - [Desvantagens](#desvantagens)
- [Argo Rollouts](#argo-rollouts)
  - [O que é o Argo Rollouts?](#o-que-é-o-argo-rollouts)
    - [Funcionalidades](#funcionalidades-1)
      - [Deployment Blue Green](#deployment-blue-green)
      - [Implemente a Lógica de Implantação Blue-Green](#implemente-a-lógica-de-implantação-blue-green)
      - [Alternando Entre os Ambientes Azul e Verde](#alternando-entre-os-ambientes-azul-e-verde)
      - [Testes e Validação](#testes-e-validação)
      - [Principais Lições](#principais-lições)
    - [Vantagens](#vantagens-2)
    - [Desvantagens](#desvantagens-1)
- [Argo Workflows](#argo-workflows)
  - [O que é o Argo Workflows?](#o-que-é-o-argo-workflows)
    - [Funcionalidades](#funcionalidades-2)
    - [Vantagens](#vantagens-3)
    - [Desvantagens](#desvantagens-2)
- [Comparativo entre Argo CD, Argo Events, Argo Workflows e Argo Rollouts](#comparativo-entre-argo-cd-argo-events-argo-workflows-e-argo-rollouts)
  - [1. Argo CD](#1-argo-cd)
  - [2. Argo Events](#2-argo-events)
  - [3. Argo Workflows](#3-argo-workflows)
  - [4. Argo Rollouts](#4-argo-rollouts)
    - [Quando Usar Cada Ferramenta](#quando-usar-cada-ferramenta)
    - [Resumo](#resumo)

# ArgoCD - GitOps baseado em pull

Argo CD é uma ferramenta declarativa de entrega contínua GitOps para Kubernetes.
O Argo CD segue o padrão GitOps de usar repositórios Git como fonte de verdade para definir o estado desejado do aplicativo.
Definições, configurações e ambientes de aplicativos devem ser declarativos e controlados por versão. A implantação de aplicativos e o gerenciamento do ciclo de vida devem ser automatizados, auditáveis ​​e fáceis de entender.
O Argo CD automatiza a implantação dos estados de aplicativo desejados nos ambientes de destino especificados. As implantações de aplicativo podem rastrear atualizações para branches, tags ou ser fixadas em uma versão específica de manifestos em um commit do Git.

![Visão geral UI](argocd-ui.webp)

[Documentação oficial](https://argo-cd.readthedocs.io/en/stable/)

## Vantagens

- Autorreparação: Reverta automaticamente os estados do cluster se eles se desviarem.  
- Reconciliação contínua: Observe seu repositório Git para ver se há alterações de configuração 24 horas por dia, 7 dias por semana, recorrente a cada 3 minutos caso ocorra mudanças no Hash do commit em um repositório e um branch específico.
- Painel de controle visual: Para verificar os status e os registros do aplicativo.

# Produtos - Argo

- [ArgoCD](#argocd)
- [Argo Events](#argo-events)
- [Argo Rollouts](#argo-rollouts)
- [Argo Workflows](#argo-workflows)

# ArgoCD

[Repositório oficial Argo CD](https://github.com/argoproj/argo-cd)

**Releases:**
[![Release Version](https://img.shields.io/github/v/release/argoproj/argo-cd?label=argo-cd)](https://github.com/argoproj/argo-cd/releases/latest)
[![Artifact HUB](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/argo-cd)](https://artifacthub.io/packages/helm/argo/argo-cd)
[![SLSA 3](https://slsa.dev/images/gh-badge-level3.svg)](https://slsa.dev)

**Code:**
[![Integration tests](https://github.com/argoproj/argo-cd/workflows/Integration%20tests/badge.svg?branch=master)](https://github.com/argoproj/argo-cd/actions?query=workflow%3A%22Integration+tests%22)
[![codecov](https://codecov.io/gh/argoproj/argo-cd/branch/master/graph/badge.svg)](https://codecov.io/gh/argoproj/argo-cd)
[![CII Best Practices](https://bestpractices.coreinfrastructure.org/projects/4486/badge)](https://bestpractices.coreinfrastructure.org/projects/4486)
[![OpenSSF Scorecard](https://api.securityscorecards.dev/projects/github.com/argoproj/argo-cd/badge)](https://scorecard.dev/viewer/?uri=github.com/argoproj/argo-cd)

## Formas de acesso

### CLI

O ArgoCD possui uma interface gráfica, mas também é possível interagir com ele através de comandos. Para isso, precisamos instalar o `argocd` CLI.

Para instalar o argo cli basta seguir este [passo a passo](https://argo-cd.readthedocs.io/en/stable/cli_installation/) de acordo com seu SO.

### UI

Para acessar via UI basta fazer um port forward e ter acesso a senha inicial de admin e a senha inicial no recurso secret chamado `argocd-initial-admin-secret` e decriptar em base64

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

## Funcionamento

1. Sync aplica a cada 3 minutos
2. Sync não aplica sob o mesmo HASH commit
3. Exemplificar Sync com alterações manuais

## Formas de deploy de aplicações

1. Helm
2. Manifest YAML
3. Repository

## Funcionalidades e Features

### Breaking Glass

Durante situações críticas é possível que seja necessário intervenções manuais para troubleshooting, alterações temporárias ou outras necessidades. Algumas práticas tornam possível que algumas alterações sejam permitidas como:

- Ignorar certas mudanças de *Applications*

```yaml
apiVersion: argoproj.io/v1alpha1
kind: ApplicationSet
spec:
  ignoreApplicationDifferences:
    - jsonPointers:
        - /spec/source/targetRevision
    - name: some-app
      jqPathExpressions:
        - .spec.source.helm.values
```

### Feature Flag

- Permitir temporariamente toggling auto-sync

```yaml
apiVersion: argoproj.io/v1alpha1
kind: ApplicationSet
spec:
  ignoreApplicationDifferences:
    - jsonPointers:
        - /spec/syncPolicy
```

Práticas de para troubleshooting: A [Documentação oficial](https://argo-cd.readthedocs.io/en/stable/operator-manual/applicationset/Controlling-Resource-Modification/) tem mais detalhes sobre medidas a serem tomadas para viabilizar situações de crise.

### Sync

- Por padrão, o ArgoCD verifica repositórios Git a cada 3 minutos para detectar mudanças nos manifests.  
- O ArgoCD pode sincronizar automaticamente os aplicativos quando detecta diferenças entre os manifests desejados no Git e o estado atual no cluster:  
  - Não há mais necessidade de sincronização manual.  
  - As pipelines de CI/CD não precisam mais de acesso direto.
- NOTAS:
  - Uma sincronização automatizada será realizada apenas se o aplicativo estiver 'OutOfSync' (Fora de Sincronização).
  - A sincronização automática não tentará realizar uma nova sincronização se a tentativa anterior contra o mesmo commit-SHA e parâmetros tiver falhado.
  - O rollback (retrocesso) não pode ser realizado em um aplicativo com a sincronização automatizada habilitada.

### Pruning

- Padrão - Sem poda: Quando a sincronização automatizada está habilitada, por padrão, para segurança, a sincronização automatizada não excluirá recursos quando o ArgoCD detectar que os recursos não estão mais definidos no Git.
- A poda pode ser habilitada para excluir recursos automaticamente como parte da sincronização automatizada.

### Self-Healing

- Por padrão, as alterações feitas no cluster ao vivo não acionam a sincronização automatizada.
- O ArgoCD possui um recurso que permite a auto-cura quando o estado do cluster ao vivo se desvia do estado do Git.

Exemplo: Tentar mudar manualmente o número de réplicas com a auto-cura habilitada não terá efeito.

### Sync Options

- No prune
  - No prune - recurso específico
- Disable kubectl validation
  - Disable kubectl validation - Application level
  - Disable kubectl validation - recurso específico
- Selective sync
- Prune last
- Replace Resources
  - Replace Resources - recurso específico
- Fail on Shared resource
  - Fail on Shared resource - recurso específico

---

# Argo Events

## O que é o Argo Events?

O Argo Events é uma ferramenta de orquestração de eventos para Kubernetes que facilita a automação de fluxos de trabalho baseados em eventos. Ele permite que os desenvolvedores criem sistemas baseados em eventos em Kubernetes, disparando ações (como *workflows*, *jobs*, ou outras operações) em resposta a eventos, seja a partir de fontes externas (como Webhooks, filas de mensagens, ou APIs), ou de eventos internos do Kubernetes (como mudanças em objetos ou estados de recursos).

### Funcionalidades

- Orquestração de Eventos: O Argo Events permite orquestrar eventos a partir de diversas fontes, como Webhooks, sistemas de mensagens (Kafka, NATS), eventos do Kubernetes (como criação de pods, alterações de estado em recursos, etc.) e muito mais.
  
- Gateways e Sensors: O Argo Events possui componentes principais chamados Gateways e Sensors:
  - Gateways: Conectam-se a fontes externas, como Webhooks ou filas de mensagens, e capturam os eventos.
  - Sensors: São responsáveis por monitorar esses eventos e, uma vez detectado um evento, disparam ações específicas, como execução de um *Workflow* do Argo ou a criação de um *Job* Kubernetes.

- Integração com Argo Workflows: Argo Events se integra diretamente com Argo Workflows, permitindo que eventos externos acionem fluxos de trabalho de maneira automatizada.

- Escalabilidade: Como é uma solução Kubernetes-native, Argo Events pode ser escalado horizontalmente, permitindo a captura e processamento de um grande número de eventos em clusters Kubernetes.

- Filtragem e Condicionalidade: Oferece suporte para definir regras e condições para filtrar eventos antes de disparar ações, garantindo que apenas os eventos relevantes acionem os processos.

- Eventos Programados: Suporta a execução de tarefas baseadas em eventos que podem ser acionadas por cronogramas (usando o formato Cron), o que permite automação de tarefas em horários específicos.
  
### Vantagens

- Automação Baseada em Eventos: Permite criar soluções de automação reativas, onde ações são tomadas automaticamente com base em eventos, melhorando a agilidade e reduzindo a intervenção manual.

- Integração Transparente com Kubernetes: Argo Events é nativo do Kubernetes, o que facilita sua integração com outras ferramentas do ecossistema Kubernetes, como Argo Workflows, Prometheus, e outros sistemas de mensageria.

- Alta Escalabilidade: Aproveitando os recursos do Kubernetes, o Argo Events pode ser escalado facilmente para lidar com uma grande quantidade de eventos, tornando-o ideal para sistemas de alta carga e grande volume de dados.

- Flexibilidade: Suporta múltiplos tipos de fontes de eventos e permite uma configuração altamente customizável para os diferentes casos de uso, desde eventos internos até fontes externas.

- Facilidade de Integração: Integra-se facilmente com sistemas de terceiros, como Kafka, AWS SNS, ou GitHub Webhooks, permitindo uma integração fluida com diversas plataformas e ferramentas.

### Desvantagens

- Curva de Aprendizado: Embora muito poderoso, Argo Events pode ser complexo para equipes novas em Kubernetes e orquestração de eventos. A configuração de Gateways, Sensors e regras de eventos pode ser desafiadora no início.

- Dependência do Kubernetes: Como o Argo Events é uma solução nativa para Kubernetes, ele não pode ser utilizado em ambientes fora do Kubernetes, o que pode limitar sua adoção em infraestruturas que não sejam baseadas em Kubernetes.

- Complexidade nas Configurações: A configuração e a gestão dos eventos podem se tornar complexas, especialmente em sistemas de grande escala, onde há muitas fontes de eventos e interações entre elas. Isso pode resultar em maior complexidade operacional.

- Monitoramento e Debug: Embora o Argo Events integre-se bem com outras ferramentas de observabilidade do Kubernetes, pode ser desafiador diagnosticar problemas ou realizar debug de fluxos de eventos complexos sem as ferramentas adequadas para rastrear e visualizar todos os eventos e ações.

---

# Argo Rollouts

## O que é o Argo Rollouts?

Argo Rollouts é uma ferramenta de gerenciamento de implementações contínuas (CD) para Kubernetes, projetada para facilitar o controle de versões e a realização de lançamentos de novas versões de aplicativos. Ele fornece uma maneira eficiente de realizar *deployments* avançados, como *blue/green*, *canary* e *rolling updates*, além de permitir a automação do processo de lançamento de software, garantindo maior controle e confiabilidade.

### Funcionalidades

- Canary Deployments: Permite a liberação gradual de novas versões para um subconjunto de usuários, garantindo que novas versões sejam testadas em produção de maneira controlada.
  
- Blue/Green Deployments: Facilita a migração entre versões de aplicativos com a possibilidade de manter uma versão "blue" estável e uma nova versão "green" para testes, reduzindo o tempo de inatividade.

- Rolling Updates: Realiza atualizações de forma gradual para evitar interrupções, permitindo que o tráfego seja distribuído entre versões antigas e novas conforme o rollout progride.

- Rollback Automático: Caso a versão atual não atenda às expectativas ou cause falhas, o Argo Rollouts permite realizar rollback automático para a versão anterior de forma rápida.

- Monitoramento e Visualização: Integra-se com ArgoCD e outras ferramentas de observabilidade, permitindo monitorar e visualizar o status dos *rollouts* em tempo real, além de fornecer métricas detalhadas.

- Estratégias de Avaliação: Possui suporte para integrações com ferramentas de métricas, como Prometheus, para realizar avaliação do desempenho da nova versão durante os *canary deployments*, ajustando automaticamente a quantidade de tráfego direcionado à nova versão com base nos resultados de métricas.

#### Deployment Blue Green

A estratégia Blue-Green não é suportada pelo *Deployment* nativo do Kubernetes, mas está disponível por meio de controladores de terceiros do Kubernetes. Este exemplo demonstra como implementar o *blue-green deployment* usando o [Argo Rollouts](https://github.com/argoproj/argo-rollouts):

1. Instale o controlador Argo Rollouts: https://github.com/argoproj/argo-rollouts#installation
2. Crie uma aplicação de exemplo e sincronize-a.

```bash
argocd app create --name blue-green --repo https://github.com/argoproj/argocd-example-apps --dest-server https://kubernetes.default.svc --dest-namespace default --path blue-green && argocd app sync blue-green
```

Após a sincronização da aplicação, você pode acessá-la usando o serviço `blue-green-helm-guestbook`.

3. Alterar o parâmetro da versão da imagem para acionar o processo de *blue-green deployment*:

```bash
argocd app set blue-green -p image.tag=0.2 && argocd app sync blue-green
```

Agora a aplicação está executando simultaneamente as imagens `ks-guestbook-demo:0.1` e `ks-guestbook-demo:0.2`. A imagem `ks-guestbook-demo:0.2` ainda é considerada *blue*, estando disponível apenas por meio do serviço de pré-visualização `blue-green-helm-guestbook-preview`.

4. Promova a imagem `ks-guestbook-demo:0.2` para *green* patchando o recurso `Rollout`:

```bash
argocd app patch-resource blue-green --kind Rollout --resource-name blue-green-helm-guestbook --patch '{ "status": { "verifyingPreview": false } }' --patch-type 'application/merge-patch+json'
```

Isso promove a imagem `ks-guestbook-demo:0.2` para o status *green* e o `Rollout` exclui a réplica antiga que executa a imagem `ks-guestbook-demo:0.1`.

#### Implemente a Lógica de Implantação Blue-Green
A lógica de implantação blue-green permitirá alternar facilmente entre os ambientes azul e verde.

Modifique o Modelo Helm para Blue-Green
No arquivo deployment.yaml dentro do seu Helm chart, modifique a especificação de implantação para usar a variável de ambiente do arquivo values.yaml:


```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "my-app.fullname" . }}-{{ .Values.environment }}
  labels:
    app: {{ include "my-app.name" . }}
    environment: {{ .Values.environment }}
spec:
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      app: {{ include "my-app.name" . }}
      environment: {{ .Values.environment }}
  template:
    metadata:
      labels:
        app: {{ include "my-app.name" . }}
        environment: {{ .Values.environment }}
    spec:
      containers:
        - name: {{ .Chart.Name }}
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
          ports:
            - containerPort: 80
```

Nesta configuração, o nome e os rótulos da implantação mudam dependendo se o ambiente é azul ou verde.

#### Alternando Entre os Ambientes Azul e Verde
Para implementar a alternância blue-green, atualize o arquivo values.yaml para mudar o ambiente:

Para o ambiente azul:

`environment: blue`

Para o ambiente verde:

`environment: green`

Você pode alternar manualmente os ambientes atualizando o arquivo de valores e sincronizando as mudanças no Argo CD. Alternativamente, automatize o processo por meio de hooks do Argo CD ou scripts personalizados.

Exemplo de Comando de Sincronização do Argo CD
Para sincronizar as alterações após modificar o ambiente para verde:

`argocd app sync my-app`

Isso implantará o ambiente verde, e você poderá direcionar o tráfego para ele assim que for verificado.

#### Testes e Validação
Uma vez que o ambiente verde esteja implantado, você pode testar a funcionalidade da aplicação. Se tudo funcionar como esperado, atualize o ingress para apontar para o ambiente verde. Se ocorrerem problemas, você pode reverter para o ambiente azul sincronizando a configuração azul.

Implementar implantações blue-green com Argo CD e Helm fornece um mecanismo poderoso para implantações sem tempo de inatividade. Ao aproveitar as práticas GitOps com o Argo CD e o sistema de templates do Helm, você pode gerenciar implantações complexas no Kubernetes, minimizando riscos e tempo de inatividade. A flexibilidade dessa configuração permite alternar facilmente entre ambientes, garantindo implementações suaves e a capacidade de se recuperar rapidamente de qualquer problema.

#### Principais Lições

- O Argo CD e o Helm permitem a automação de implantações blue-green com Kubernetes, permitindo a alternância perfeita entre ambientes.

- Ao gerenciar suas implantações de forma declarativa por meio do Git, você mantém total controle sobre o processo de implantação e minimiza intervenções manuais.

- As implantações blue-green reduzem significativamente o risco de erros e tempo de inatividade, tornando-as ideais para aplicações críticas.

### Vantagens

- Controle e Segurança: Oferece um controle granular sobre o processo de implantação, o que reduz os riscos associados a lançamentos em produção.
  
- Redução de Downtime: Estratégias como *blue/green* e *canary* ajudam a minimizar o tempo de inatividade durante a implantação, garantindo que as versões antigas e novas possam coexistir até que o tráfego seja totalmente redirecionado para a nova versão.

- Rollback Rápido: Em caso de problemas, é possível reverter rapidamente para a versão anterior, com mínimo impacto no ambiente de produção.

- Facilidade de Integração: Integra-se facilmente com outras ferramentas do ecossistema Kubernetes, como ArgoCD, Helm e Prometheus, permitindo uma implementação contínua mais robusta.

- Automação de Deployments: Argo Rollouts automatiza a aplicação das melhores práticas de deployment, reduzindo o risco de erro humano.

### Desvantagens

- Curva de Aprendizado: Para equipes novas no Kubernetes ou em práticas de CD avançadas, pode haver uma curva de aprendizado para entender e configurar corretamente o Argo Rollouts e suas estratégias de implantação.

- Complexidade de Configuração: Embora ofereça flexibilidade, o Argo Rollouts pode exigir configurações complexas, especialmente ao integrar com ferramentas de monitoramento e métricas, o que pode ser desafiador para equipes com pouca experiência.

- Sobreposição de Funcionalidade: Para ambientes que já utilizam outras ferramentas de CD e gerenciamento de versões, a introdução do Argo Rollouts pode redundar em funcionalidades, gerando sobrecarga e complexidade desnecessária.

- Dependência do Kubernetes: O Argo Rollouts é projetado para ambientes Kubernetes, o que significa que não pode ser usado em clusters fora do Kubernetes, limitando sua aplicabilidade em outros tipos de infraestrutura.

---

# Argo Workflows

## O que é o Argo Workflows?

O Argo Workflows é uma plataforma de orquestração de workflows para Kubernetes, que permite definir, gerenciar e executar pipelines complexas de tarefas dentro de um cluster Kubernetes. É uma solução para automação de processos, como execução de testes, implantações contínuas, geração de relatórios e qualquer outro fluxo de trabalho que envolva a execução de múltiplos passos ou tarefas interdependentes. Ele é projetado para ser altamente escalável, flexível e fácil de integrar com outros serviços e ferramentas dentro do ecossistema Kubernetes.

### Funcionalidades

- Definição de Workflows como Código (YAML): O Argo Workflows permite que workflows complexos sejam definidos como arquivos YAML, com cada tarefa sendo representada por um step que pode ser executado em paralelo ou sequencialmente.
  
- Execução de Workflows em Kubernetes: Todos os workflows são executados nativamente dentro de clusters Kubernetes, o que significa que eles podem aproveitar os recursos de escalabilidade e flexibilidade do Kubernetes.

- Tarefas Paralelas e Condicionais: Suporta a execução de tarefas de maneira paralela e a definição de dependências entre elas, garantindo maior flexibilidade. Também permite a execução condicional de tarefas, com base nos resultados de tarefas anteriores.

- Suporte a Containers e Pods: As tarefas dentro de um workflow podem ser executadas como containers ou pods, permitindo a execução de código em qualquer ambiente que suporte containers, como Docker.

- Integração com Outras Ferramentas do Kubernetes: O Argo Workflows integra-se facilmente com outras ferramentas do Kubernetes, como Argo CD, Argo Events, Prometheus e Helm, permitindo a criação de pipelines complexas que interagem com todo o ecossistema Kubernetes.

- Visualização de Workflows: O Argo Workflows oferece uma interface de usuário gráfica para visualização e monitoramento de workflows, facilitando o acompanhamento de execução e diagnóstico de falhas.

- Suporte a Artefatos: Permite que artefatos sejam passados entre as tarefas do workflow, facilitando o compartilhamento de dados entre diferentes etapas.

### Vantagens

- Escalabilidade e Flexibilidade: Como é construído sobre o Kubernetes, o Argo Workflows aproveita a escalabilidade horizontal do Kubernetes, permitindo a execução de workflows em larga escala.

- Orquestração Completa de Tarefas: Permite a criação de pipelines de CI/CD, automação de testes, processamento de dados e outras tarefas complexas que envolvem múltiplas etapas e dependências.

- Integração Nativa com Kubernetes: O Argo Workflows se integra perfeitamente com o ecossistema Kubernetes, permitindo a execução de tarefas em containers, escalabilidade automática e uso de outros recursos do Kubernetes.

- Suporte a Execução Paralela e Condicional: Facilita a execução de workflows complexos com múltiplas tarefas que podem ser executadas em paralelo, além de suportar a execução condicional de etapas.

- Visualização e Monitoramento: A interface gráfica do Argo Workflows oferece uma visão clara do status do workflow, facilitando o acompanhamento da execução e a solução de problemas.

- Código Declarativo: Workflows são definidos como arquivos YAML, o que os torna facilmente versionáveis, reutilizáveis e documentados, promovendo práticas como Infrastructure as Code (IaC).

### Desvantagens

- Curva de Aprendizado: Para equipes novas em Kubernetes ou em orquestração de workflows, o Argo Workflows pode ter uma curva de aprendizado significativa, especialmente ao lidar com a complexidade de workflows grandes e interdependentes.

- Complexidade de Configuração: A configuração de workflows pode se tornar complexa, especialmente quando lidamos com múltiplas dependências, execução paralela de tarefas e condições de sucesso/erro entre etapas.

- Sobrecarga de Recursos: Workflows de longa execução ou com muitas tarefas paralelas podem consumir uma quantidade significativa de recursos no cluster Kubernetes, o que pode impactar o desempenho e a capacidade do cluster se não for gerenciado adequadamente.

- Falta de Suporte a Outras Plataformas: O Argo Workflows é nativo do Kubernetes e, portanto, só pode ser executado em ambientes Kubernetes, limitando sua aplicabilidade em infraestruturas não baseadas em Kubernetes.

- Dependência de Contêineres: Como o Argo Workflows executa tarefas dentro de containers e pods, é necessário ter o ambiente do Kubernetes configurado corretamente para garantir a execução adequada dos workflows.

---

# Comparativo entre Argo CD, Argo Events, Argo Workflows e Argo Rollouts

## 1. Argo CD

- Objetivo:  
Argo CD é uma ferramenta de deploy contínuo (CD) para Kubernetes. Ele gerencia o estado desejado dos aplicativos em um cluster Kubernetes e realiza deploys automáticos quando há mudanças no repositório de código (por exemplo, Git).
  
- Quando usar:  
Utilize o Argo CD quando você precisa de uma solução GitOps para gerenciar o ciclo de vida dos seus aplicativos no Kubernetes. É ideal para ambientes que exigem uma configuração declarativa e deseja realizar deploys automáticos e monitoramento do estado do aplicativo.
  
- Recursos principais:
  - Deploys baseados em Git.
  - Sincronização automática de clusters.
  - Visualização do estado do aplicativo.
  - Rollback de versões anteriores.
  - Suporte a múltiplos clusters Kubernetes.

## 2. Argo Events

- Objetivo:  
Argo Events é uma ferramenta para orquestrar eventos e gatilhos no Kubernetes. Ele permite que você crie automações baseadas em eventos, como mudanças em repositórios Git, mensagens de filas, ou até mesmo webhooks.
  
- Quando usar:  
Use o Argo Events quando precisar orquestrar fluxos de trabalho baseados em eventos. Ele é ideal quando há necessidade de responder a mudanças em tempo real, como o acionamento de deploys, notificações, ou execuções de tarefas quando certos eventos ocorrem (ex. push no Git, fila de mensagens, etc).
  
- Recursos principais:
  - Integração com Git, Kafka, HTTP, NATS, entre outros.
  - Gatilhos (triggers) para iniciar fluxos de trabalho ou pipelines.
  - Suporte a eventos personalizados.
  - Automação do fluxo de trabalho com base em eventos externos.

## 3. Argo Workflows

- Objetivo:  
Argo Workflows é uma ferramenta para orquestrar fluxos de trabalho complexos no Kubernetes. Ele permite definir workflows como DAGs (Grafos Acíclicos Dirigidos) de tarefas que podem ser executadas de forma paralela ou sequencial.
  
- Quando usar:  
Utilize o Argo Workflows quando precisar orquestrar processos complexos no Kubernetes que envolvem várias tarefas interdependentes, como pipelines de CI/CD, tarefas de processamento de dados ou automações de fluxo de trabalho mais complexas.
  
- Recursos principais:
  - Definição de workflows como DAGs.
  - Suporte a tarefas paralelas e dependências.
  - Execução de tarefas em containers.
  - Armazenamento de logs e artefatos.
  - Suporte a loops e condições.

## 4. Argo Rollouts

- Objetivo:  
Argo Rollouts é uma ferramenta para realizar deploys avançados e controlados no Kubernetes. Ela permite implementar estratégias de deployment como blue/green, canary, e rolling updates de maneira mais robusta, fornecendo uma maneira mais granular de controle sobre as versões de aplicativos.

- Quando usar:  
Utilize o Argo Rollouts quando precisar realizar deploys mais sofisticados que exigem controle fino sobre a liberação de novas versões de software, como testes A/B, validação incremental e mitigação de riscos em produção.

- Recursos principais:
  - Estratégias de deploy avançadas (Blue/Green, Canary, Rolling Updates).
  - Monitoramento e métricas de deploy.
  - Controle de versão e rollback.
  - Integração com métricas de saúde e monitoração.

---

### Quando Usar Cada Ferramenta

1. Argo CD:  
   Use quando precisar de deploy contínuo e uma abordagem GitOps para gerenciar seus aplicativos Kubernetes com foco em estado desejado. Ideal para ambientes com múltiplos clusters e necessidade de visibilidade clara do estado dos aplicativos.

2. Argo Events:  
   Use quando precisar orquestrar fluxos de trabalho baseados em eventos. Ideal para automatizar a execução de tarefas ou processos em resposta a eventos externos como notificações, webhooks ou mudanças em repositórios.

3. Argo Workflows:  
   Use para orquestrar fluxos de trabalho complexos no Kubernetes, especialmente quando há necessidade de dependências entre tarefas ou quando for necessário executar múltiplas tarefas paralelas ou sequenciais.

4. Argo Rollouts:  
   Use quando precisar de deploys avançados com controle de versão refinado, estratégias de rollout (blue/green, canary) e monitoramento da performance de novos releases. Ideal para liberar novas versões com menor risco.

---

### Resumo

| Ferramenta       | Objetivo                                                                 | Uso Ideal                                           |
|------------------|--------------------------------------------------------------------------|-----------------------------------------------------|
| Argo CD      | Deploy contínuo e GitOps                                                | Gerenciar o estado de aplicativos em múltiplos clusters Kubernetes |
| Argo Events  | Orquestração de eventos e gatilhos                                        | Automação de tarefas baseadas em eventos externos   |
| Argo Workflows| Orquestração de fluxos de trabalho complexos no Kubernetes               | Orquestrar pipelines, CI/CD, ou tarefas interdependentes |
| Argo Rollouts| Deploys avançados com estratégias de release controladas (Blue/Green, Canary) | Gerenciar releases sofisticados e rollbacks seguros  |

Cada ferramenta do Argo tem um foco específico no ciclo de vida do Kubernetes, e a escolha entre elas depende das necessidades do seu pipeline e do grau de controle que você deseja ter sobre os processos de deploy, eventos ou workflows no seu cluster.