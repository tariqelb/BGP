all:
	@docker build -t alpine-busybox -f Dockerfile.alpine .
	@docker build -t frr-b-o-is -f Dockerfile.frr .

clean:
	@docker stop `docker ps -aq` 2>/dev/null || true
	@docker rm -f `docker ps -aq` 2>/dev/null || true
	@docker rmi -f `docker images -aq` 2>/dev/null || true

clean_all: clean
	@docker system prune -a -f

re: clean_all all