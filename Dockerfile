# Use uma imagem Node.js como base
FROM node:18-alpine

# Defina o diretório de trabalho dentro do container
WORKDIR /app

# Copie o package.json e package-lock.json (ou yarn.lock) para o container
COPY package*.json ./

# Instale as dependências do Angular
RUN npm install

# Copie o restante dos arquivos do projeto Angular para o container
COPY . .

# Construa a aplicação Angular para produção
RUN npm run build

# Use uma imagem Nginx para servir os arquivos estáticos do Angular
FROM nginx:stable-alpine

# Exponha a porta 80 para acesso à aplicação Angular
EXPOSE 80

# Remova a configuração padrão do Nginx
RUN rm /etc/nginx/conf.d/default.conf

# Copie a configuração personalizada do Nginx (opcional, veja o Passo 4)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copie os arquivos de build do Angular para a pasta de arquivos estáticos do Nginx
COPY --from=0 /app/dist/app-agenda /usr/share/nginx/html

# Comando para iniciar o Nginx
CMD ["nginx", "-g", "daemon off;"]
