# Rede Terraform AWS

Projeto Terraform para provisionamento de uma estrutura base de rede na AWS, com foco em reutilização, clareza e maturidade suficiente para servir como base pessoal de novos ambientes.

## O que este projeto cria

Este projeto provisiona os seguintes recursos:

- 1 VPC
- 1 Internet Gateway
- Subnets públicas distribuídas por Availability Zones (AZs) definidas
- Subnets privadas distribuídas por Availability Zones (AZs) definidas
- 1 route table pública com rota default para Internet Gateway
- 1 route table privada
- Associações entre subnets e route tables
- 1 NAT Gateway opcional
- 1 Elastic IP opcional para o NAT Gateway

## Objetivo

O objetivo deste projeto é criar uma base de rede AWS simples, reutilizável e previsível para:

- ambientes pessoais
- laboratórios
- futuros projetos
- referência para consultas e reuso

## Características da implementação

- Estrutura modular
- Separação entre subnets públicas, privadas e NAT Gateway
- Distribuição de subnets por AZ
- NAT Gateway opcional
- DNS support e DNS hostnames configuráveis
- Tags padrão no provider
- Backend remoto em S3 para state
- Outputs úteis para integração com outros projetos

## Estrutura esperada

```text
.
├── main.tf
├── variables.tf
├── outputs.tf
├── providers.tf
├── locals.tf
├── terraform.tfvars
├── terraform.tfvars.sample
└── modules
    ├── public_subnet
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── private_subnet
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── nat_gateway
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

## Comportamento da arquitetura

### Quando `create_nat_gateway = false`

O projeto cria:

- VPC
- Internet Gateway
- subnets públicas
- subnets privadas
- route table pública com saída para internet
- route table privada sem saída default para internet

Neste cenário:

- recursos em subnet pública podem ter acesso à internet
- recursos em subnet privada não terão saída para internet por default

### Quando `create_nat_gateway = true`

Além dos recursos acima, o projeto também cria:

- 1 Elastic IP
- 1 NAT Gateway
- rota default na route table privada apontando para o NAT Gateway

Neste cenário:

- recursos em subnet pública continuam saindo pela internet via Internet Gateway
- recursos em subnet privada passam a ter saída para internet via NAT Gateway

## Resiliência por Availability Zone

As subnets são criadas com base em uma lista explícita de AZs, por exemplo:

```hcl
selected_azs = ["us-east-1a", "us-east-1b", "us-east-1c"]
```

Isso garante previsibilidade no provisionamento e melhora a resiliência da arquitetura, evitando dependência implícita da seleção automática de AZ pela AWS.

## Variáveis principais

| Variável | Tipo | Descrição |
|---|---|---|
| `regiao` | `string` | Região AWS onde os recursos serão criados |
| `perfil` | `string` | Perfil AWS CLI utilizado na autenticação |
| `vpc_block` | `string` | Bloco CIDR da VPC |
| `vpc_name` | `string` | Nome lógico da VPC |
| `selected_azs` | `list(string)` | Lista de Availability Zones que receberão subnets |
| `create_nat_gateway` | `bool` | Define se o NAT Gateway será criado |
| `support_dns` | `bool` | Habilita DNS support na VPC |
| `dns_hostnames` | `bool` | Habilita DNS hostnames na VPC |

## Exemplo de uso

```bash
terraform init
terraform plan
terraform apply
```

Para destruir:

```bash
terraform destroy
```

## Outputs esperados

O projeto expõe outputs úteis, como:

- ID da VPC
- ID do Internet Gateway
- mapa de subnets públicas por AZ
- mapa de subnets privadas por AZ
- IP público do NAT Gateway, quando criado

## Tabela de custo médio por recurso

> Observação:
> Os valores abaixo são apenas estimativas de ordem de grandeza e podem variar por região, data, uso e tráfego.
> Em geral, os recursos de rede básicos têm custo muito baixo ou nulo por si só.
> O principal ponto de atenção de custo neste projeto é o NAT Gateway.

| Recurso | Criado sempre? | Custo médio estimado | Prioridade de subida | Observação |
|---|---|---:|---|---|
| VPC | Sim | Muito baixo / geralmente sem custo direto | Essencial | Base de toda a rede |
| Internet Gateway | Sim | Muito baixo / geralmente sem custo direto | Essencial | Necessário para internet nas subnets públicas |
| Subnets públicas | Sim, conforme AZs definidas | Muito baixo / geralmente sem custo direto | Essencial | Estrutura de entrada pública |
| Subnets privadas | Sim, conforme AZs definidas | Muito baixo / geralmente sem custo direto | Essencial | Estrutura isolada para workloads internos |
| Route table pública | Sim | Muito baixo / geralmente sem custo direto | Essencial | Rota default para IGW |
| Route table privada | Sim | Muito baixo / geralmente sem custo direto | Essencial | Base de roteamento privado |
| Associações de route table | Sim | Muito baixo / geralmente sem custo direto | Essencial | Associação entre subnet e route table |
| Elastic IP do NAT | Apenas com NAT habilitado | Baixo custo recorrente | Condicional | Só faz sentido junto com NAT |
| NAT Gateway | Apenas com NAT habilitado | Médio a alto custo mensal | Opcional / Situacional | Principal item de custo da arquitetura |
| Tráfego de saída | Depende do uso | Variável | Situacional | Pode gerar custo mesmo com estrutura simples |

## Prioridade recomendada de provisionamento

| Nível | Itens |
|---|---|
| Essencial | VPC, Internet Gateway, subnets, route tables, associations |
| Recomendado | DNS support, DNS hostnames, tags padrão |
| Condicional | NAT Gateway e Elastic IP |
| Futuro / Evolução | VPC Endpoints, NACLs, Flow Logs, múltiplas route tables privadas, HA de NAT por AZ |

## Quando usar NAT Gateway

Use `create_nat_gateway = true` quando você precisar que workloads em subnets privadas:

- baixem pacotes da internet
- acessem APIs públicas
- façam updates do sistema operacional
- consumam repositórios externos sem exposição direta

Se isso não for necessário, manter o NAT desabilitado ajuda a reduzir custos.

## Observações de design

### Pontos positivos do projeto

- modularização clara
- separação de responsabilidades
- comportamento previsível por AZ
- ativação opcional do NAT
- fácil reuso em novos ambientes

### Limitações conhecidas

- atualmente há apenas uma route table pública compartilhada
- atualmente há apenas uma route table privada compartilhada
- o NAT é único, não distribuído por AZ
- em cenários altamente críticos, o ideal seria evoluir para:
  - uma subnet pública por AZ
  - uma subnet privada por AZ
  - um NAT Gateway por AZ
  - route tables privadas por AZ

## Boas práticas para uso

- validar sempre o `terraform plan` antes do `apply`
- usar `terraform.tfvars.sample` como base e manter `terraform.tfvars` fora do versionamento, se necessário
- evitar habilitar NAT Gateway sem necessidade real
- revisar CIDRs e AZs antes do provisionamento
- usar tags consistentes para facilitar organização e rastreabilidade

## Exemplo de configuração

```hcl
regiao             = "us-east-1"
perfil             = "terraform"
vpc_name           = "main"
vpc_block          = "10.0.0.0/16"
selected_azs       = ["us-east-1a", "us-east-1b", "us-east-1c"]
create_nat_gateway = true
support_dns        = true
dns_hostnames      = true
```

## Licença

Uso pessoal e reutilização livre conforme sua necessidade.
