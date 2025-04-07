Claro, Luan! Aqui está uma documentação prática e passo a passo para o seu projeto, incluindo códigos e dicas para resolver problemas comuns. Essa documentação pode ser adicionada diretamente ao `README.md` do seu repositório no GitHub.

---

# **Flask App with Docker Swarm and Load Balancing**

Este projeto demonstra como implantar uma aplicação Flask simples em um cluster Docker Swarm com balanceamento de carga usando Nginx.

---

## **Índice**

1. [Pré-requisitos](#pré-requisitos)
2. [Estrutura do Projeto](#estrutura-do-projeto)
3. [Passo a Passo](#passo-a-passo)
4. [Possíveis Problemas e Soluções](#possíveis-problemas-e-soluções)
5. [Códigos](#códigos)

---

## **Pré-requisitos**

Antes de começar, certifique-se de ter os seguintes requisitos instalados:

- Docker: [Instalação Oficial](https://docs.docker.com/get-docker/)
- Docker Compose
- Python 3.x (opcional, para testar localmente)
- Git (opcional, para clonar o repositório)

---

## **Estrutura do Projeto**

```
flask-docker-swarm/
│
├── app.py                     # Código da aplicação Flask (Hello World)
├── requirements.txt           # Dependências da aplicação Flask
├── Dockerfile                 # Configuração para criar a imagem Docker
├── docker-compose.yml         # Configuração do Docker Swarm e serviços
├── nginx.conf                 # Configuração do Nginx como Load Balancer
└── README.md                  # Documentação do projeto
```

---

## **Passo a Passo**

### **1. Clone o Repositório**

Clone este repositório para sua máquina local:

```bash
git clone https://github.com/seuusuario/flask-docker-swarm.git
cd flask-docker-swarm
```

---

### **2. Construir e Enviar a Imagem Docker**

1. Construa a imagem Docker:
   ```bash
   docker build -t myusername/myapp:latest .
   ```

2. Faça login no Docker Hub:
   ```bash
   docker login
   ```

3. Envie a imagem para o Docker Hub:
   ```bash
   docker push myusername/myapp:latest
   ```

---

### **3. Inicializar o Docker Swarm**

1. Verifique se o Docker Swarm já está ativo:
   ```bash
   docker info | grep "Swarm"
   ```

   Se estiver inativo, inicialize o Swarm:
   ```bash
   docker swarm init
   ```

   **Dica:** Se o comando falhar porque o Docker não consegue encontrar um IP automaticamente, especifique manualmente o IP da interface de rede:
   ```bash
   docker swarm init --advertise-addr <SEU_IP>
   ```

2. Verifique se o Swarm está ativo:
   ```bash
   docker node ls
   ```

---

### **4. Implantar o Stack**

Implante o stack usando o `docker-compose.yml`:
```bash
docker stack deploy -c docker-compose.yml myapp
```

---

### **5. Verificar os Serviços Ativos**

1. Liste os serviços implantados:
   ```bash
   docker service ls
   ```

2. Verifique os logs dos serviços:
   ```bash
   docker service logs myapp_web
   ```

---

### **6. Testar a Aplicação**

Acesse a aplicação no navegador ou via `curl`:
```bash
curl http://localhost
```

**Dica:** Se houver problemas com o `localhost`, use o IP local da máquina:
```bash
curl http://<SEU_IP>
```

---

## **Possíveis Problemas e Soluções**

### **Problema 1: Conflito na Porta 80**
Se outro serviço (como o Apache2) estiver ocupando a porta 80:

1. Verifique se o Apache2 está ativo:
   ```bash
   sudo systemctl status apache2
   ```

2. Desative o Apache2 temporariamente:
   ```bash
   sudo systemctl stop apache2
   ```

### **Problema 2: Erro ao Inicializar o Docker Swarm**
Se o Docker Swarm não conseguir detectar automaticamente o IP da interface de rede:

1. Especifique o IP manualmente:
   ```bash
   docker swarm init --advertise-addr <SEU_IP>
   ```

### **Problema 3: Balanceamento Não Funciona**
Se as requisições não forem distribuídas entre as réplicas:

1. Verifique os logs das réplicas:
   ```bash
   docker service logs myapp_web
   ```

2. Certifique-se de que o Nginx está configurado corretamente no `nginx.conf`.

---

## **Códigos**

### **1. `app.py`**

```python
from flask import Flask
import os

app = Flask(__name__)

@app.route('/')
def hello_world():
    container_id = os.getenv('HOSTNAME', 'unknown')
    return f'Hello, World! This is replica: {container_id}'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
```

---

### **2. `requirements.txt`**

```
flask==2.3.2
```

---

### **3. `Dockerfile`**

```dockerfile
FROM python:3.9-slim
WORKDIR /app
COPY . /app
RUN pip install --no-cache-dir -r requirements.txt
EXPOSE 5000
CMD ["python", "app.py"]
```

---

### **4. `nginx.conf`**

```nginx
events {}

http {
    upstream flask_app {
        server web:5000;
    }

    server {
        listen 80;

        location / {
            proxy_pass http://flask_app;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }
}
```

---

### **5. `docker-compose.yml`**

```yaml
version: '3.8'

services:
  web:
    image: luandocs/flask-docker-swarm-load-balancing:latest
    deploy:
      replicas: 3
      restart_policy:
        condition: any
    ports:
      - "5000:5000"
  
  nginx:
    image: nginx
    ports:
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
```

---

## **Dicas Adicionais**

1. **Adicionar Mais Nós ao Cluster**:
   Para adicionar mais nós ao Docker Swarm, execute o seguinte comando no nó gerenciador:
   ```bash
   docker swarm join-token worker
   ```
   Copie o comando gerado e execute-o nos nós trabalhadores.

2. **Forçar IPv4**:
   Use o IP local (`http://127.0.0.1`) ao invés de `localhost` para evitar problemas com resolução de DNS.

3. **Monitoramento**:
   Use ferramentas como `docker stats` ou `docker service ps` para monitorar o desempenho e o status dos serviços.

---

## **Contribuição**

Contribuições são bem-vindas e incentivadas! Se você deseja contribuir para este projeto, siga os passos abaixo:

1. **Fork o Repositório**:
   Clique no botão "Fork" no GitHub para criar uma cópia do repositório na sua conta.

2. **Clone o Repositório Forkado**:
   ```bash
   git clone https://github.com/seuusuario/flask-docker-swarm.git
   cd flask-docker-swarm
   ```

3. **Crie uma Branch para suas Alterações**:
   ```bash
   git checkout -b feature/nome-da-sua-feature
   ```

4. **Faça suas Alterações**:
   Implemente suas melhorias ou correções no código.

5. **Commit e Push suas Alterações**:
   ```bash
   git add .
   git commit -m "Descrição das alterações realizadas"
   git push origin feature/nome-da-sua-feature
   ```

6. **Abra um Pull Request (PR)**:
   Volte ao repositório original no GitHub e clique em "Compare & Pull Request". Descreva suas alterações e envie o PR.

**Dicas para Contribuição**:
- Certifique-se de que suas alterações seguem o padrão de código do projeto.
- Teste suas alterações localmente antes de enviar o PR.
- Documente suas mudanças, se necessário, para facilitar a revisão.

---

## **Licença**

Este projeto está licenciado sob a **MIT License**. Isso significa que você pode usar, modificar e distribuir o código livremente, desde que inclua a licença original e os avisos de direitos autorais.

Para mais detalhes, consulte o arquivo [LICENSE](LICENSE) no repositório.

**Resumo da Licença MIT**:
- Permissão é concedida para uso, cópia, modificação, fusão, publicação, distribuição, sublicenciamento e/ou venda de cópias do software.
- O software é fornecido "como está", sem garantias de qualquer tipo, expressas ou implícitas.

Se você precisar de uma licença diferente, entre em contato comigo.

---

## **Contato**

Se tiver dúvidas ou sugestões, entre em contato:

- **Nome**: Luan Castro
- **Email**: luandecastrosilva@gmail.com
- **LinkedIn**: [linkedin.com/in/luancastrosilva](https://www.linkedin.com/in/luancastrosilva/)
- **GitHub**: [github.com/luangitdev](https://github.com/luangitdev)