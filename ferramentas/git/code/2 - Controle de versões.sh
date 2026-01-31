: '2 - Controle de Versões'

# Configurações iniciais ----------------------------------------

# Configurção do nome e email (global)
git config --global user.name ""
git config --global user.email ""

# Confirmar as confirgurações:
git config --list

# Confirmar usuário e email:
git config user.name
git config user.email

# Configuração opcional para editor padrão:
git config --global core.editor "vim"
git config --global core.editor "nano"
git config --global core.editor "code --wait"

# Variações (ramificação) - Importante:
git config --global init.defaultBranch main

# Iniciar GIT (Aguarde a mensagem: Initialized empty Git repository)

git init

# Primeiro commit --------------------------------------------

# Ver status:
git status

# Adicionando arquivos:
git add . # Adiciona tudo
git add nome_do_arquivo.extensao # Arquivo específico
git add nome_da_pasta/ # Pasta específica

# Fazer commit
git commit -m ""

# Salvar credenciais (opcional):
git config --global credential.helper cache # Padrão, salva por 15min
git config --global credential.helper 'cache --timeout=3600'
git config --global credential.helper 'cache --timeout=7200' # Salva por 2h
git config --global credential.helper store # Salva no disco (permanentemente) 


# Ver histórico de commits:
git log # Último commit
git log --oneline # Ver compacto
git log --graph --oneline # Ver com gráfico

# Desfazer mudanças (remover commits) -----------------------------

# Antes de "add" (descartar mudanças locais):
git checkout -- arquivo.txt

# Depois de "add" (tirar do staging)
git reset HEAD arquivo.txt

# Depois de "commit" (reverte o último commit mas mantém mudanças (mantém arquivos))
git reset --soft HEAD~1


: '# Depois de "commit" (reverte o último commit e descarta mudanças.
Descarta mudanças permanentemente, só use se quer apagar tudo. '

git reset --hard HEAD~1 
