all: build

help:
	@echo ""
	@echo "-- Help Menu"
	@echo ""
	@echo "   1. make build        - build the compiler-explorer image"
	@echo "   2. make start        - start compiler-explorer container"
	@echo "   3. make stop         - stop compiler-explorer container"
	@echo "   4. make logs         - view logs"
	@echo "   5. make purge        - stop and remove the container"

build:
	@docker build --tag=jtsylve/compiler-explorer:$(shell git describe --abbrev=0 2>/dev/null || echo untagged) .

start:
	@echo "Starting Compiler Explorer container..."
	@docker start compiler-explorer 2>/dev/null || \
	    docker run --name=compiler-explorer -p 10240:10240 -d \
		    jtsylve/compiler-explorer:latest >/dev/null
	@echo "Please be patient. This could take a while if new dependencies are needed..."
	@echo "Compiler Explorer will be available at http://localhost:10240"
	@echo "Type 'make logs' for the logs"

stop:
	@echo "Stopping Compiler Explorer..."
	@docker stop compiler-explorer >/dev/null

purge: stop
	@echo "Removing Compiler Explorer container..."
	@docker rm -v compiler-explorer >/dev/null

logs:
	@docker logs -f compiler-explorer