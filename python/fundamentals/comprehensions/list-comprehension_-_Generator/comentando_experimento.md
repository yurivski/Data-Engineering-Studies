# Arquivo "experimento_logs.py" Comentado.

É importante ler e entender os treinos que escrevi na pasta "learning" para ser capaz de "traduzir" o script do experimento realizado com 10K a 1M de logs.

*Obs.: Conteúdo para iniciantes em python na área de Engenharia de Dados.*

---

## Importações de bibliotecas:
***time:*** mede o tempo de execução (o cronômetro)  
***tracemalloc:*** rastreia a alocação de memória do python  
***from typing import List, Generator:*** indica o que entra e sai das funções  

Para um melhor entendimento do que acontece no código, temos que entender o que cada biblioteca faz e onde elas atuam:

---

### tracemalloc:

Esta ferramenta rastreia em tempo real cada vez que o python usa a memória RAM para guardar algum dado, seja dicionário de log ou listas.

Quando criamos a lista vazia: ``` list = [] ```, o python aloca um pequeno espaço na memória RAM. Conforme adicionamos itens, o python solicita mais memória ao sistema operacional automaticamente. Quando criamos a função  ```gerar_logs_lista ``` e a executamos, o "tracemalloc" rastreia quanto de memória foi alocado durante a criação da lista.   

No script, o python processa o que é usado no exato momento em que é executado ```memoria_atual``` e identifica daquele momento até onde se tornou mais pesado, exatamente no pico ```(memoria_mb)```.  

Quando usar essa ferramenta sempre lembre de usar ```stop()```, senão a própria ferramenta irá usar memória e comprometer o resultado do experimento. Para ficar claro: ```start()``` inicia a ferramenta, ```get_traced_memory()``` "escaneia" ou "captura" a estatística acumulada e ```stop()``` "desliga" a ferramenta para não usar memória.   

---

### from *typing* import *List, Generator*:

São os Type Hints, ele basicamente deixam claro o que você está enviando e o que espera receber na sintaxe, isso evita que o pipeline quebre no meio do caminho, eles ajudam a evitar erros de lógica.  

É basicamente uma ferramenta criada para facilitar a vida do ser humano ao ler o código que escrevemos. Sem eles o condigo continua funcionando, é como se você escrevesse "Porque" para iniciar uma pergunta mas sabemos que é "Por que", ou qualquer gíria de favelado quando põe legenda em um status do Whatsapp, a mensagem vai ser transmitida mas ficará um pouco confusa para ler e entender.

---

### "EXTRACT": Função construtora ou "Mock Data":

Aqui podemos avançar um pouco no entendimento de List Comprehension *(supondo que você ou já entendeu os conceitos)*, a função ```def gerar_logs_lista(n: int) -> List[dict]: ``` usa List Comprehension para gerar nossa lista com os dados: id, timestamp, user e login.  

Para ser mais específico: nós temos o dicionário ```{tudo que está dentro de colchetes}```, ```for i```: expressão de retorno/ loop e variável de iteração temporária, ```in```: indica a fonte dos dados e ```range(1, n + 1)``` a função que cria os logs da lista.  

Em ```"action": "login" if i % 2 == 0 else "query"``` é simples: se a expressão de retorno dividida por 2 for par ```if i % == 0``` a ação será ```login``` caso contrário (ou ímpar) ```query```.  

Como o resto das sintaxes foi comentada nos arquivos de treinos, a parte nova aqui é: ```f"2025-01-{i%28+1:02d} 14:00:00",```. a expressão ```i%28+1``` é o cálculo para a data não passar do dia 28, e ```02d``` significa que se o dia tem apenas um dígito, então coloque o zero na frente: dia 1 passa a ser dia 01.  

```i%28``` = restando 0 da divisão entre a expressão de retorno (i) por 28, deve ser acrescentado + 1. Não podemos esquecer que o python é uma das linguagens de programação que começa a contar a partir do 0. Então, nesse contexto o cálculo `i%28+1` garante dias entre 1 e 28 (não 0 a 27).  

Por exemplo:   
- i=1: 1%28 = 1, +1 = 2 (dia 02)   
- i=28: 28%28 = 0, +1 = 1 (dia 01)   
- i=29: 29%28 = 1, +1 = 2 (dia 02)   

O operador % (módulo) retorna o resto da divisão.
Quando i é múltiplo de 28, o resto é 0, por isso somamos +1.

```for i in range(1, n + 1) ``` finaliza o loop. Para quem não sabe, "1, n + 1" é como se você escrevesse "range(1, 10)".

---
### "TRANSFORM": Processamento dos Dados:

```
def processar_logs_lista(logs: List[dict]) -> dict:   
```
```total = len(logs)```: Primeiramente lembre-se que esse comando não funciona no Generator, não dá para saber algo que ainda está sendo "gerado".   

Esse é um comando instantâneo, como a lista já está carregada na memória, então o python já sabe o tamanho dela.   

```usuarios = set()```: esta é uma das linhas mais importantes, o ```set()``` é uma estrutura de dados que não permite duplicatas. Esse comando faz referência à sintaxe logo abaixo: ```usuarios.add(log["user"])``` toda vez que o loop passar por aqui ele verifica se o "user" já está dentro do set(), se for usuário novo, ele entra, se não o python simplesmente ignora.  

### Por exemplo:   
**Se usássemos uma lista:**   
usuarios = []   
usuarios.append("user_1")   
usuarios.append("user_1")  # Observe que duplicou!   
print(len(usuarios))  # 2 (contaria duplicado)   

**Com set():**   
usuarios = set()   
usuarios.add("user_1")   
usuarios.add("user_1")  # o duplicado seria ignorado automaticamente.   
print(len(usuarios))  # 1 (apenas únicos)   

Ao final ```"usuarios_unicos": len(usuarios)``` retorna a quantidade de usuários únicos. É como se você usasse a "COUNT(DISTINCT user)" no SQL.

```for log in logs:```: esse é o loop ao qual me referi antes, que passa por ```usuarios.add(log["user"])``` e ```set()``` verifica se é usuário novo.  

```logins += 1``` e ```logins += 1``` são apenas acumuladores, ```if``` e ```else``` separam o que é acesso ao "login" do que é "queries".   

Enfim a função termina devolvendo um dicionário formatado em ```return {...}```. Normalmente usamos isso em pipelines porque é mais fácil passar para um banco de dados ou para um dashboard.   

---
### Medição de Performace:

```
def medir_performance(funcao_gerar, funcao_processar, n: int, nome: str):
```  

Esta é uma função genérica, não importa se você está testando List ou Generator, ela simplesmente recebe essas funções como uma "ferramenta".   

Os argumentos: ```(funcao_gerar, funcao_processar, ...)```, nesta função o python substitui o nome genérico "funcao_gerar" pela função real da lista criada anteriormente.   

```time.time() - inicio```: marca o tempo exato que o pipeline levou para rodar, em ```(f"Tempo: {tempo_total:.3f} segundos")``` o ".3f" no print pede para mostrar 3 casas decimais.   

Podemos notar o ```tracemalloc.stop()``` como eu falei no início.  

Uma parte também interessante: ```memoria_mb = memoria_pico / 1024 / 1024```, aqui pedimos para a memória de devolver o resultado em Bytes. Então o python divide por 1024 uma vez e divide de novo por 1024:  

Divide por 1024 uma vez = kilobytes (KB).   
Divide por 1024 de novo = Megabytes (MB).   

---

*Nota: "1024" é o número que mais se aproxima de "1000" dentro da lógica binária. Contando de 10 em 10 até mil para nós meros humanos é fácil ("10" porque me refiro à contagem nos dedos), isso significa 10 elevado ao cubo (na base 10). No entanto, PCs contam na base 2, ou seja, tudo é potência de 2, então 2 elevado a 10 = 1024, pois "kilo" significa 1000 para nós.*   

*Resumindo: Divide por 1024 uma vez = KB, divide por 1024 duas vezes = MB, três vezes = GB.*  

*(detalhar mais que isso renderia um livro, sugiro pesquisar sobre "unidades de informação (ICE - JEDEC)" ou "diferença entre MB e MiB").*

---

Note o ": , " em ```{resultado['total_logs']:,}"```, aqui formatamos "1000000" por 1,000,000.  

---

### Testes e Comparações:   

```for volume in volumes:```: criamos um loop para testar os ```volumes = [10_000, 100_000, 1_000_000]```.   

Se você analisou o script com atenção, então deve ter observado o "_," que deve deixar os perfeccionistas bastante incomodados. Esta é uma forma de manter o código limpo (por ironia), com ela, nós sinalizamos ao python "eu sei que retorna o dicionário, mas por hora quero o tempo e a memória", no momento é apenas isso que nos interessa.   


Para finalizar:   
```
if __name__ == "__main__":
    main()
```
Executamos a função main().  

---

Todo o texto que escrevi com as explicações o mais detalhada possível, foi focado para o melhor entendimento de usuários comuns, que estão iniciando os estudos. Tentei ser o mais técnico e informal possível para a melhor compreensão dos códigos.   

Se alguém mais experiente identificou algum erro meu, ficarei feliz em receber o feedback.