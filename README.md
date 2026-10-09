<div align="center">
  <h1>💎 crystal-api-starter</h1>
  <p><strong>A modern JSON API starter for Crystal.</strong><br/>
  Ruby-like syntax, compiled speed, and a single static binary in a tiny `FROM scratch` Docker image.</p>

  <p>
    <a href="https://github.com/stijnwtf/crystal-api-starter/actions/workflows/ci.yml"><img src="https://github.com/stijnwtf/crystal-api-starter/actions/workflows/ci.yml/badge.svg" alt="CI" /></a>
    <a href="https://crystal-lang.org"><img src="https://img.shields.io/badge/crystal-1.21-000000" alt="Crystal 1.21" /></a>
    <a href="LICENSE"><img src="https://img.shields.io/github/license/stijnwtf/crystal-api-starter" alt="MIT license" /></a>
    <a href="https://github.com/stijnwtf/crystal-api-starter/stargazers"><img src="https://img.shields.io/github/stars/stijnwtf/crystal-api-starter?style=social" alt="GitHub stars" /></a>
  </p>
</div>

## What's inside

| | |
| --- | --- |
| 🚀 **[Kemal](https://kemalcr.com)** | Fast, Sinatra-style routing |
| 🧱 **Typed JSON** | `JSON::Serializable` models and request structs, validation with clear errors |
| 🔒 **Thread-safe store** | In-memory, mutex-guarded, easy to swap for Postgres or SQLite |
| 🧪 **Specs** | Request specs with [spec-kemal](https://github.com/kemalcr/spec-kemal) |
| 🧹 **Linting** | [Ameba](https://github.com/crystal-ameba/ameba) + `crystal tool format` |
| 🐳 **Docker** | Static binary in a `FROM scratch` image |
| 🤖 **CI** | Format, lint, specs and Docker build on every push |

## Quick start

```bash
git clone https://github.com/stijnwtf/crystal-api-starter my-api
cd my-api
shards install
crystal run src/app.cr     # http://localhost:3000
```

Needs [Crystal](https://crystal-lang.org/install/) 1.21+ (`brew install crystal`).

```console
$ curl -X POST localhost:3000/tasks -d '{"title":"Try Crystal"}'
{"id":1,"title":"Try Crystal","completed":false,"created_at":"2026-10-09T09:29:56Z"}
```

## Commands

| Command | Does |
| --- | --- |
| `make dev` | Run with auto-restart ([watchexec](https://github.com/watchexec/watchexec)) |
| `make test` | Run specs |
| `make lint` | Run Ameba |
| `make format` | Format code |
| `make build` | Optimized binary in `bin/app` |
| `make docker` | Build the production image |

## API

| Method | Path | Body | Response |
| --- | --- | --- | --- |
| `GET` | `/health` | | `{"status","version"}` |
| `GET` | `/tasks` | | `Task[]` |
| `GET` | `/tasks/:id` | | `Task` or `404` |
| `POST` | `/tasks` | `{"title"}` | `201 Task`, `400` or `422` |
| `PATCH` | `/tasks/:id` | `{"title"?, "completed"?}` | `Task`, `404` or `422` |
| `DELETE` | `/tasks/:id` | | `204` or `404` |

## Structure

```
src/
├── app.cr            entry: config, JSON error handlers, server start
├── store.cr          thread-safe in-memory store
├── models/task.cr    Task model, request bodies, validation
└── routes/           one file per resource
spec/                 request specs
```

Add a resource: create `src/models/thing.cr` and `src/routes/things.cr`. Both folders are required with a glob, so no wiring needed.

## Deploy

```bash
docker build -t my-api .
docker run -p 3000:3000 my-api
```

Configure the port with `PORT` (default `3000`).

If this saved you time, a ⭐️ helps others find it.

## License

[MIT](LICENSE)
