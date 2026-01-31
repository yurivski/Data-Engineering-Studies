: '3 - Ramificação'

# Configurar a branch padrão:
git config --global init.defaultBranch main

# Estabelecer o rastreamento entre branches local e remota:
git push -u origin main

# Ver branches existentes:
git branch # Local
git branch -r # Remoto
git branch -a # Todas

# Criar nova branch:
git branch nome-da-branch

# Mudar para outra branch:
git checkout nome-da-branch

# Criar e mudar para nova branch (atalho):
git checkout -b nome-da-branch

# Deletar branch local:
git branch -d nome-da-branch # Padrão (só deleta se já mergeada)
git branch -D nome-da-branch # Força deleção

# Deletar branch remota:
git push origin --delete nome-da-branch

# Estabelecer rastreamento entre branch local e remota:
git push -u origin main # Primeira vez
git push # Próximas vezes

# Atualizar branch local com remota:
git pull origin main

# Merge de branches:
git checkout main # Vai para branch destino
git merge nome-da-branch # Traz mudanças da outra branch

# Ver diferenças entre branches:
git diff main..outra-branch