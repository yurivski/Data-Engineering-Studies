: '4 - Comandos Úteis'

# Ver diferenças não commitadas:
git diff

# Ver diferenças entre commits:
git diff HEAD~1 HEAD

# Ver arquivos modificados:
git status --short

# Ver histórico de um arquivo específico:
git log -- caminho/do/arquivo.txt

# Buscar em commits:
git log --grep="palavra-chave"

# Desfazer último commit mas manter mudanças:
git reset --soft HEAD~1

# Editar mensagem do último commit:
git commit --amend -m "Nova mensagem"

# Adicionar arquivo esquecido no último commit:
git add arquivo-esquecido.txt
git commit --amend --no-edit

# Ver quem modificou cada linha de um arquivo:
git blame arquivo.txt

# Criar tag (release):
git tag v1.0.0
git push origin v1.0.0

# Clonar repositório:
git clone https://github.com/usuario/repo.git

# Atualizar repositório local:
git pull

# Guardar mudanças temporariamente (stash):
git stash                    # Guarda mudanças
git stash list              # Ver stashes
git stash pop               # Recupera último stash
git stash clear             # Limpa todos stashes