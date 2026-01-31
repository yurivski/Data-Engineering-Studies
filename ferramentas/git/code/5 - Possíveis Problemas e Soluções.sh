: '5 - Possíveis Problemas e Soluções'

# Erro: "failed to push some refs"
git pull origin main --rebase
git push origin main

# Erro: "Authentication failed"
: 'Solução 1: Usar Personal Access Token
   Solução 2: Configurar SSH'

# Erro: "Permission denied (publickey)"
# Configurar chave SSH:
ssh-keygen -t ed25519 -C "johndoe@exemplo.com" # Ou aquele email seguro com números que o GitHub fornece
cat ~/.ssh/id_ed25519.pub  # Copiar e adicionar no GitHub

# Desfazer git init (remover repositório):
rm -rf .git

# Limpar histórico de commits (começar do zero):
rm -rf .git
git init
git add .
git commit -m "Initial commit"
git remote add origin URL
git push -u origin main --force

# Reverter arquivo para versão anterior:
git checkout HEAD -- arquivo.txt

# Desfazer merge:
git merge --abort

# Ver configurações Git:
git config --list --show-origin
