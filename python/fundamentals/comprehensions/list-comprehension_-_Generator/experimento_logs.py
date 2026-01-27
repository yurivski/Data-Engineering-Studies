"""
Simulação: List Comprehensions | Generators - Performance de tempo e memória.
Recomendo que executem este script no Google Collab caso a máquina não tenha muita memória.
"""

import time
import tracemalloc
from typing import List, Generator

def gerar_logs_lista(n: int) -> List[dict]:
    # Implementar geração de logs usando list comprehension
    return [
        {
            "id": i,
            "timestamp": f"2025-01-{i%28+1:02d} 14:00:00",
            "user": f"user_{i}",
            "action": "login" if i % 2 == 0 else "query"
        }
        for i in range(1, n + 1)
    ]

def gerar_logs_generator(n: int) -> Generator[dict, None, None]:
    # Implementar geração de logs usando generator
    for i in range(1, n + 1):
        yield {
            "id": i,
            "timestamp": f"2025-01-{i%28+1:02d} 14:00:00",
            "user": f"user_{i}",
            "action": "login" if i % 2 == 0 else "query"
        }

# Processamento

def processar_logs_lista(logs: List[dict]) -> dict:
    # Processa lista completa de logs
    total = len(logs)

    logins = 0
    queries = 0
    usuarios = set()

    for log in logs:
        usuarios.add(log["user"])
        if log["action"] == "login":
            logins += 1
        else:
            queries += 1

    return {
        "total_logs": total,
        "logins": logins,
        "queries": queries,
        "usuarios_unicos": len(usuarios)
    }


def processar_logs_generator(logs: Generator[dict, None, None]) -> dict:
    """
    Processa logs de um generator

    Mesma lógica da função anterior
    MAS processando item por item do generator
    """
    total = 0
    logins = 0
    queries = 0
    usuarios = set()

    # Iteramos diretamente no generator
    for log in logs:
        total += 1
        usuarios.add(log["user"])
        if log["action"] == "login":
            logins += 1
        else:
            queries += 1

    return {
        "total_logs": total,
        "logins": logins,
        "queries": queries,
        "usuarios_unicos": len(usuarios)
    }


# Medição de Performance

def medir_performance(funcao_gerar, funcao_processar, n: int, nome: str):
    # Mede tempo e memória de execução
    print(f"Testando: {nome}")
    print(f"Quantidade de logs: {n:,}")

    # Inicia medição de memória
    tracemalloc.start()
    inicio = time.time()

    # Gera os dados
    dados = funcao_gerar(n)

    # Processa os dados
    resultado = funcao_processar(dados)

    # Calcula tempo e memória
    tempo_total = time.time() - inicio
    memoria_atual, memoria_pico = tracemalloc.get_traced_memory()
    tracemalloc.stop()

    memoria_mb = memoria_pico / 1024 / 1024

    print()
    print(f"Resultado do processamento:")
    print(f"Total logs: {resultado['total_logs']:,}")
    print(f"Logins: {resultado['logins']:,}")
    print(f"Queries: {resultado['queries']:,}")
    print(f"Usuários únicos: {resultado['usuarios_unicos']:,}")
    print(f"Tempo: {tempo_total:.3f} segundos")
    print(f"Memória pico: {memoria_mb:.1f} MB")
    print()

    return resultado, tempo_total, memoria_mb

# Testes e Comparações

def main():
    # Executa testes comparativos

    volumes = [10_000, 100_000, 1_000_000]

    for volume in volumes:
        print(f"TESTE COM {volume:,} LOGS ---------------")
        print()
        # LISTA:
        _, tempo_lista, mem_lista = medir_performance(
            gerar_logs_lista,
            processar_logs_lista,
            volume,
            "LIST"
        )

        # GERADOR:
        _, tempo_gen, mem_gen = medir_performance(
            gerar_logs_generator,
            processar_logs_generator,
            volume,
            "GENERATOR"
        )
# Executa main()
if __name__ == "__main__":
    main()