# Dify + BAAI/bge-m3 Self-Hosted

Развёртывание [Dify](https://dify.ai) с моделью эмбеддингов [BAAI/bge-m3](https://huggingface.co/BAAI/bge-m3) через Docker Compose.

## Архитектура

| Сервис | Описание |
|---|---|
| `api` / `worker` / `worker_beat` | Dify backend (API + Celery workers) |
| `web` | Dify frontend (Next.js) |
| `db` | PostgreSQL 15 |
| `redis` | Redis 6 |
| `weaviate` | Векторная БД |
| `embedding` | HuggingFace TEI с BAAI/bge-m3 |
| `sandbox` | Песочница для выполнения кода |
| `plugin_daemon` | Менеджер плагинов |
| `ssrf_proxy` | SSRF-прокси (Squid) |
| `nginx` | Reverse proxy |

## Требования

- Docker 19.03+
- Docker Compose 2.x
- RAM: минимум 8 ГБ (bge-m3 ~2 ГБ + остальные сервисы)
- Диск: ~5 ГБ для модели bge-m3 (скачается при первом запуске)

## Быстрый старт

```bash
# 1. Отредактируйте .env (смените SECRET_KEY, пароли)
nano .env

# 2. Запустите всё
docker compose up -d

# 3. Дождитесь скачивания модели bge-m3 (первый запуск ~5-10 мин)
docker compose logs -f embedding

# 4. Откройте Dify
open http://localhost
```

## Подключение bge-m3 в Dify

После запуска модель bge-m3 доступна по адресу `http://embedding:80` внутри Docker-сети (или `http://localhost:8090` с хоста).

Чтобы подключить в Dify:

1. Зайдите в **Settings → Model Provider**
2. Добавьте провайдер **OpenAI-API-compatible** или **Text Embedding Inference**
3. Укажите URL: `http://embedding:80`
4. Выберите модель `BAAI/bge-m3`

## HTTPS

Для включения HTTPS:

1. Положите сертификат и ключ в `nginx/ssl/`
2. В `.env` установите:
   ```
   NGINX_HTTPS_ENABLED=true
   NGINX_SSL_CERT_FILENAME=your-cert.crt
   NGINX_SSL_CERT_KEY_FILENAME=your-cert.key
   ```
3. Перезапустите: `docker compose restart nginx`

## GPU-ускорение для bge-m3

Для использования GPU замените образ TEI в `docker-compose.yml`:

```yaml
embedding:
  image: ghcr.io/huggingface/text-embeddings-inference:1.8  # GPU-версия
  # ...
  deploy:
    resources:
      reservations:
        devices:
          - driver: nvidia
            count: 1
            capabilities: [gpu]
```

## Полезные команды

```bash
# Статус сервисов
docker compose ps

# Логи конкретного сервиса
docker compose logs -f api

# Перезапуск
docker compose restart

# Остановка
docker compose down

# Остановка с удалением данных
docker compose down -v
```
