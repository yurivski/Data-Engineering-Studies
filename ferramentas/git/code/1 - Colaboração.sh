: ' 1 - Colaboração'

# Conexão local com o GitHub:
git remote add origin https://github.com/link-completo-do-repositorio.git

# verificar remote:
git remote -v
: ' 
O resultado deve ser a sequência de exemplo:
origin https://github.com/link-completo-do-repositorio.git (fetch)
origin https://github.com/link-completo-do-repositorio.git (push)
'

# Push inicial (você precisa do "Personal access Token (PAT)" ou "SSH" do seu repositório):
: '
Quando executar o comando vai pedir usuário e senha:
Username for '...' 
Password for '...' [Cole_o_token_aqui]
' 
git push -u origin main

# Para verificar se já está autenticado:
git config credential.helper

# Se der erro "branch main não existe":
git branch -M main  # Renomeia branch atual para main

# Se der erro "remote origin já existe":
git remote remove origin  # Remove o remote antigo
git remote add origin https://github.com/usuario/repositorio.git

# Publicar no repositório:
git push