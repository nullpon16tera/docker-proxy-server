run:
	docker-compose -f "docker-compose.yml" up -d --build

down:
	docker-compose -f "docker-compose.yml" down

up:
	docker-compose -f "docker-compose.yml" up -d --build

network:
	docker network create shared

setup:network
	docker-compose -f "docker-compose.yml" up -d --build

restart:down
	docker-compose -f "docker-compose.yml" up -d --build