.PHONY: dev test lint format build docker

dev:      ## run with auto-restart on file changes (needs watchexec)
	watchexec -r -e cr -- crystal run src/app.cr

test:
	KEMAL_ENV=test crystal spec

lint:
	crystal run lib/ameba/bin/ameba.cr

format:
	crystal tool format src spec

build:
	shards build --release

docker:
	docker build -t app .
