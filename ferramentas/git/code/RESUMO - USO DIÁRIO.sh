: 'RESUMO - COMANDOS MAIS USADOS'

# STATUS E INFORMAÇÕES ---------------------------------------------

# Ver status atual (arquivos modificados, staging, etc):
git status

# Ver status resumido (mais limpo):
git status -s
: '
M  = Modified (modificado)
A  = Added (adicionado ao staging)
?? = Untracked (não rastreado)
D  = Deleted (deletado)
'

# Ver diferenças não commitadas:
git diff

# Ver diferenças do que está no staging:
git diff --staged

# Ver histórico de commits:
git log
git log --oneline # Compacto (1 linha por commit)
git log --oneline --graph # Com gráfico visual
git log --oneline -n 5 # Últimos 5 commits
git log --author="John" # Commits de um autor
git log --since="2 weeks ago" # Commits das últimas 2 semanas
git log --grep="fix" # Buscar commits por palavra

# Ver quem modificou cada linha de um arquivo:
git blame arquivo.txt
git blame -L 10,20 arquivo.txt # Linhas 10 a 20

# ADICIONAR E COMMITAR (básico) ------------------------------------------

# Adicionar arquivos ao staging:
git add arquivo.txt # Arquivo específico
git add pasta/ # Pasta inteira
git add . # Tudo no diretório atual
git add *.py # Todos os arquivos .py
git add -A # Tudo (incluindo deletados)

# Remover arquivo do staging (antes do commit):
git reset HEAD arquivo.txt
git restore --staged arquivo.txt # Se o outro não funcionar / variação

# Commitar:
git commit -m "Mensagem descritiva do commit"

# Commitar pulando o staging (add + commit junto):
git commit -am "Mensagem" # Só funciona com arquivos já rastreados

# Editar mensagem do último commit:
git commit --amend -m "Nova mensagem corrigida" # Salva vidas

# Adicionar arquivo esquecido ao último commit:
git add arquivo-esquecido.txt
git commit --amend --no-edit # Mantém a mensagem anterior

# SINCRONIZAR COM GITHUB

# Enviar commits para o GitHub:
git push
git push origin main # Especificando branch

# Baixar atualizações do GitHub:
git pull
git pull origin main # Especificando branch

# Baixar sem fazer merge automático:
git fetch origin # Baixa mas não integra
git merge origin/main # Integra manualmente depois

# Ver branches remotas:
git branch -r

# Ver todas as branches (local + remota):
git branch -a

# DESFAZER MUDANÇAS (Salva vidas de desesperados)

# Descartar mudanças em arquivo específico (volta ao último commit):
git checkout -- arquivo.txt
git restore arquivo.txt # Se o outro não funcionar

# Descartar todas as mudanças não commitadas:
git checkout -- .
git restore . # Se o outro não funcionar / variação

# Desfazer último commit mas manter as mudanças:
git reset --soft HEAD~1 # Arquivos voltam para staging

# Desfazer último commit e descartar as mudanças:
git reset --hard HEAD~1 # As mudanças serão perdidas

# Desfazer os últimos 3 commits (mantendo mudanças):
git reset --soft HEAD~3

# Reverter um commit específico (cria novo commit que desfaz):
git revert hash-do-commit # Mais seguro que reset

# Ver hash dos commits:
git log --oneline

# BRANCHES (Uso diário) -----------------------------------------------

# Ver branches locais:
git branch

# Criar nova branch:
git branch nome-da-feature

# Mudar para outra branch:
git checkout nome-da-feature
git switch nome-da-feature # Se o outro não funcionar / variação

# Criar E mudar para nova branch (atalho):
git checkout -b nome-da-feature
git switch -c nome-da-feature # Se o outro não funcionar / variação

# Voltar para a branch anterior:
git checkout -
git switch - # Se o outro não funcionar / variação

# Deletar branch local:
git branch -d nome-da-feature # Só funciona se já fez merge
git branch -D nome-da-feature # Força o delete

# Enviar branch local para GitHub:
git push -u origin nome-da-feature # Primeira vez
git push # Próximas vezes

# Deletar branch remota no GitHub:
git push origin --delete nome-da-feature

# Fazer merge de outra branch na atual:
git merge nome-da-feature

# Cancelar merge em caso de conflito:
git merge --abort

# STASH (Guardar mudanças temporariamente) ----------------------------------

# Guardar mudanças não commitadas:
git stash
git stash save "Descrição do que guardei"

# Ver lista de stashes:
git stash list

# Recuperar último stash e remover da lista:
git stash pop

# Recuperar último stash mas manter na lista:
git stash apply

# Recuperar stash específico:
git stash pop stash@{2} # Recupera o 3º da lista (índice 2)

# Deletar último stash:
git stash drop

# Deletar stash específico:
git stash drop stash@{1}

# Deletar todos os stashes:
git stash clear

# Ver mudanças dentro de um stash:
git stash show -p stash@{0}

# LIMPEZA E MANUTENÇÃO ------------------------------------------------------

# Ver arquivos não rastreados:
git status

# Remover arquivos não rastreados (dry-run primeiro):
git clean -n # Mostra o que seria deletado
git clean -f # Deleta arquivos não rastreados
git clean -fd # Deleta arquivos E pastas

# Remover branches locais que já foram deletadas no remoto:
git fetch --prune
git fetch -p # Atalho

# Ver tamanho do repositório:
git count-objects -vH

# Otimizar repositório (garbage collection):
git gc

# ATALHOS ÚTEIS --------------------------------------------------------------

# Ver último commit:
git show

# Ver arquivo de um commit específico:
git show hash:caminho/arquivo.txt

# Pesquisar no código (em todos os commits):
git log -S "texto_procurado"
git log -S "função_antiga" --source --all

# Ver mudanças de ontem:
git log --since="yesterday"

# Ver suas contribuições do dia:
git log --author="$(git config user.name)" --since="today"

# Copiar commit de outra branch:
git cherry-pick hash-do-commit

# Ver diferença entre duas branches:
git diff main..feature-branch

# Criar atalhos personalizados:
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.unstage 'reset HEAD --'

# Usar os atalhos:
git st # Igual a: git status
git co main # Igual a: git checkout main
git br # Igual a: git branch
git ci -m "msg" # Igual a: git commit -m "msg"
git unstage arquivo.txt # Igual a: git reset HEAD arquivo.txt

