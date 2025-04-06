# Usa uma imagem oficial do Python como base
FROM python:3.9-slim

# Define o diretório de trabalho dentro do container
WORKDIR /app

# Copia os arquivos da aplicação para o container
COPY . /app

# Instala dependências
RUN pip install --no-cache-dir -r requirements.txt

# Expõe a porta 500 para acessar a aplicação
EXPOSE 5000

# Comando para executar a aplicação
CMD [ "python", "app.py" ]
