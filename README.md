# 🐳 TP Distribuidos – Infraestructura con Docker

Este repositorio contiene los recursos necesarios para levantar el stack completo del proyecto TP Distribuidos – Grupo C usando Docker. Esto incluye:
- Base de datos MySQL con datos iniciales

- Servidor gRPC (Spring Boot)

- Cliente gRPC (Express)

- Frontend React

- MailHog para pruebas de correo

---

### ✅ Requisitos previos

- Tener Docker y Docker Compose instalados en tu máquina.

- Clonar los repositorios de [backend](https://github.com/MaximilianoCalahorra/TP-Distribuidos-GrupoC-backend) y [frontend](https://github.com/MaximilianoCalahorra/TP-Distribuidos-GrupoC-frontend) en la misma carpeta que este repo de infraestructura, ya que allí se encuentran los ```Dockerfile``` necesarios para levantar los servicios ```grpc-server```, ```grpc-client``` y ```frontend``` cuando ejecutes ```docker compose up --build -d```:

```bash
/TP-Distribuidos-GrupoC/
│
├─ TP-Distribuidos-GrupoC-backend/
│   ├─ grpc_server/
│   └─ grpc_client/
│
├─ TP-Distribuidos-GrupoC-frontend/
│
└─ TP-Distribuidos-GrupoC-docker/
```

⚠️ Asegurate de que los repos estén en la misma carpeta antes de levantar el stack, de lo contrario ```docker compose``` fallará al intentar construir las imágenes.

- Acceder a la carpeta del repositorio de Docker:

```bash
cd TP-Distribuidos-GrupoC-docker/
```

---

### ⚙️ Configuración del entorno

1. Copiar el archivo de ejemplo ```.env.example``` a ```.env```:

```bash
cp .env.example .env
```

2. Editar ```.env``` reemplazando:

- ```TU_CLAVE``` → contraseña de MySQL

- ```TU_USERNAME``` → usuario de MySQL

Ejemplo:

```bash
DATABASE_HOST=mysql
DATABASE_NAME=tp-distribuidos-grupoc
DATABASE_PASSWORD=mi_clave_segura
DATABASE_PORT=3306
DATABASE_USERNAME=root
FRONTEND_URL=http://frontend:80
CORS_ALLOWED_ORIGIN=http://frontend:80
GRPC_SERVER_URL=http://grpc-server:9090
COMPOSE_PROJECT_NAME=tp-sd-grupo-c
```

⚠️ Nunca subir tu ```.env``` con credenciales reales al repositorio.

---

### 🚀 Levantar el proyecto

Desde la carpeta del repo de infraestructura (```TP-Distribuidos-GrupoC-docker```) ejecutar:

```bash
# Construir y levantar todos los contenedores en segundo plano
docker compose up --build -d
```

Esto levantará los siguientes servicios:

- ```mysql``` → Base de datos

- ```grpc-server``` → Servidor gRPC

- ```grpc-client``` → Cliente gRPC

- ```frontend``` → Frontend React

- ```mailhog``` → MailHog (SMTP + web)

---

### 🔍 Verificación rápida de contenedores

```bash
docker compose ps
```

Muestra todos los contenedores levantados, sus puertos y estados. Útil para confirmar que ```mysql```, ```grpc-server```, ```grpc-client```, ```frontend``` y ```mailhog``` están activos.

---

### 💾 Cargar los datos iniciales en MySQL

1. Copiar el script SQL al contenedor de MySQL:

```bash
docker cp ./mysql-init/cargar_datos_iniciales.sql mysql:/tmp/
```

2. Ejecutar el script dentro del contenedor:

```bash
docker exec -i mysql mysql -u <usuario> -p<clave> tp-distribuidos-grupoc < ./mysql-init/cargar_datos_iniciales.sql
```
Reemplazar ```<usuario>``` y ```<clave>``` con los valores definidos en ```.env```.

3. (Opcional) Entrar al contenedor y verificar los datos:

```bash
docker exec -it mysql bash
mysql -u <usuario> -p<clave> tp-distribuidos-grupoc

# Dentro de MySQL, ejecutar:
SHOW TABLES;
SELECT * FROM roles;
SELECT * FROM usuarios;
```

---

### ⏹️ / ▶️ Detener y reiniciar el proyecto

#### Detener los contenedores (sin eliminar volúmenes ni imágenes)

```bash
docker compose stop
```
Esto detiene todos los contenedores del proyecto, pero **mantiene los volúmenes y la configuración**, para poder levantarlos de nuevo rápidamente.

#### Levantar los contenedores nuevamente

```bash
docker compose up -d
```

⚠️ Esto reutiliza las imágenes existentes y no vuelve a reconstruir nada.
Si querés reconstruir (por ejemplo, cambiaste algo en el Dockerfile), usarías:

```bash
docker compose up --build -d
```

#### 📜 Logs en tiempo real

```bash
docker compose logs -f
```
Ver todos los logs de los contenedores en tiempo real.
O de un servicio específico:

```bash
docker compose logs -f grpc-server
```
Útil para debug o verificar que los servicios se levantaron correctamente.

---

### 📦 Volúmenes y persistencia

El volumen ```db_data``` se utiliza para persistir los datos de MySQL:

```yaml
volumes:
  db_data:
```

Si querés reiniciar la base completamente, podés borrar el volumen:
```bash
docker volume rm tp-sd-grupo-c_db_data
```

---

### 🖥️ Acceso a MySQL desde host

MySQL se expone en el puerto ```3307``` en tu máquina local.
Para conectarte desde tu host con un cliente:

```bash
mysql -h 127.0.0.1 -P 3307 -u <usuario> -p
```
Reemplazá ```<usuario>``` y la contraseña definida en tu ```.env```.

---

### 📝 Notas finales

- Asegurate de levantar primero el contenedor de MySQL antes de ejecutar el script SQL.

- El frontend y el cliente gRPC dependen de que el servidor gRPC y MySQL estén activos. Docker Compose se encarga del orden con ```depends_on```, pero puede ser útil esperar unos segundos después de levantar los contenedores antes de acceder al frontend.

- La interfaz web de MailHog queda disponible en http://localhost:8025.

- Cualquier cambio en las variables de entorno debe reflejarse en ```.env.example``` para que otros desarrolladores puedan levantar el stack fácilmente.