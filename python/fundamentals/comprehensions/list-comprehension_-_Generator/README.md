## List Comprehensions | Generator

*Nota: A pasta "learning" contem arquivos .py com diferentes treinos de diferentes níveis para praticar. Em cada arquivo de treino há comentários e técnicas de interpretação para ler e entender as sintaxes que eu uso nos meus estudos.*

*Os detalhes do experimento realizado no arquivo experimento_logs.py estão no arquivo comentando_experimento.md*

---

Os usos dos conceitos fundamentais de List Comprehensions e Generators envolve o contexto onde será utilizado no seu script. Tudo depende basicamente da quantidade de registros armazenados e quantos registros queremos listar. 

Em ambientes onde precisamos gerar centenas de milhares de registros, o mais adequado para a tarefa é usar Geradores, o uso de memória RAM com Geradores é incrivelmente menor nesse contexto. Por exemplo, usando a função range() como iterável e adicionando um argumento de 500.000 registros, ela não ocupa quase nada de memória e não armazena os números. Ela guarda apenas 3 informações:
- início (ex: 0)
- fim (ex: 500000)
- passo (ex: 1)

Quando você pede o próximo número, range() calcula qual é, 
não busca de uma lista. Por isso range(10) e range(1000000) 
ocupam a mesma quantidade de memória. Por isso range() é por definição uma função “preguiçosa”. 

O contrário acontece ao gerarmos uma lista com o mesmo argumento. São 500.000 registros armazenados pelo python e processados na RAM. Vou mostrar na prática isso com um experimento onde analisarei três cenários, vou gerar respectivamente: 10.000, 100.000 e 1.000.000 de registros, com lista e gerador.

Neste exemplo eu medi a memória e o tempo de execução de cada processamento:

```
TESTE COM 10,000 LOGS ---------------

Testando: LIST
Quantidade de logs: 10,000

Resultado do processamento:
Total logs: 10,000
Logins: 5,000
Queries: 5,000
Usuários únicos: 10,000
Tempo: 0.259 segundos
Memória pico: 3.8 MB

Testando: GENERATOR
Quantidade de logs: 10,000

Resultado do processamento:
Total logs: 10,000
Logins: 5,000
Queries: 5,000
Usuários únicos: 10,000
Tempo: 0.336 segundos
Memória pico: 1.0 MB

TESTE COM 100,000 LOGS ---------------

Testando: LIST
Quantidade de logs: 100,000

Resultado do processamento:
Total logs: 100,000
Logins: 50,000
Queries: 50,000
Usuários únicos: 100,000
Tempo: 2.437 segundos
Memória pico: 37.9 MB

Testando: GENERATOR
Quantidade de logs: 100,000

Resultado do processamento:
Total logs: 100,000
Logins: 50,000
Queries: 50,000
Usuários únicos: 100,000
Tempo: 1.689 segundos
Memória pico: 9.8 MB

TESTE COM 1,000,000 LOGS ---------------

Testando: LIST
Quantidade de logs: 1,000,000

Resultado do processamento:
Total logs: 1,000,000
Logins: 500,000
Queries: 500,000
Usuários únicos: 1,000,000
Tempo: 15.352 segundos
Memória pico: 368.7 MB

Testando: GENERATOR
Quantidade de logs: 1,000,000

Resultado do processamento:
Total logs: 1,000,000
Logins: 500,000
Queries: 500,000
Usuários únicos: 1,000,000
Tempo: 13.570 segundos
Memória pico: 81.5 MB
```
---
***Nota: execute o arquivo experimento_logs.py para consolidar o entendimento da execução desse script.***

---

### Para simplificar a análise do resultado, vou comparar 10K e 1M logs.

---
**Tempo | Memória (10.000 logs):  
List Comprehension: 0.132 segundos | 3.8 MB  
Generator: 0.119 segundos | 1.0 MB** 

Tempo:  
Diferença: 0.132 - 0.119 = 0.013 segundos
Melhoria: (0.013 / 0.132) × 100 = 9.8%

Memória:  
(1 - 1.0/3.8) × 100 = 74%

O Generator foi 9.8% mais rápido que List.

---

**Tempo | Memória (1.000.000 logs):  
List Comprehension: 13.849 segundos | 368.7 MB  
Generator: 13.542 segundos | 81.5 MB**

Tempo:  
Diferença: 13.849 - 13.542 = 0.307 segundos
Melhoria: (0.307 / 13.849) × 100 = 2.2%

Memória:  
Redução: (1 - 81.5/368.7) × 100 = 78%

O Generator foi 2.2% mais rápido que List.

*Obs.: Os percentuais entre os dois volumes de logs são independentes e não podem ser subtraídos diretamente, pois referem-se à escalas diferentes.*

---

**Podemos concluir que:**

**TEMPO:**   
Conforme o volume aumenta, a diferença percentual de velocidade diminui (9.8% para 2.2%). Com grandes volumes, tanto List quanto Generator gastam a maior parte do tempo processando os dados, e não gerando.

**MEMÓRIA:**  
Generator é consistentemente mais econômico (74-78% menos memória), independente do volume. Esta é sua principal vantagem.

Por exemplo: banco de dados de instituição pública, é generator obrigatório. Ao processar logs de banco de dados de instituição pública (que podem ter milhões de registros), usar Generator é praticamente obrigatório devido à limitação de memória.

---
#### Fórmula usada:

$$\text{Tempo: Melhoria \%} = \left( \frac{\text{Tempo Lento} - \text{Tempo Rápido}}{\text{Tempo Lento}} \right) \times 100$$


$$\text{Memória: Redução \%} = \left( 1 - \frac{\text{Memória Leve}}{\text{Memória Pesada}} \right) \times 100$$
---

### Resumo de quando usar List Comprehension e Generator:

### List Comprehension

- Volume pequeno de dados (< 100.000 itens)
- Você precisa acessar os dados múltiplas vezes
- Operações que exigem índice ou acesso aleatório
- Performance de tempo é crítica e memória não é problema

### Generator

- Volume grande de dados (> 100.000 itens)
- Você processa os dados uma única vez
- Memória RAM é limitada
- Trabalhando com streams ou pipelines de dados
- ETL (Extract, Transform, Load) em bancos de dados grandes

---