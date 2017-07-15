# The MIT License (MIT)
#
# Copyright (c) 2014 Sameer Naik
# Copyright (c) 2017 Joe T. Sylve, Ph.D.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

all: build

TAG := $(shell git describe 2>/dev/null || echo untagged)

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
	@docker build --tag=jtsylve/compiler-explorer:$(TAG) .

start:
	@echo "Starting Compiler Explorer container..."
	@docker start compiler-explorer 2>/dev/null || \
	    docker run --name=compiler-explorer -p 10240:10240 -d \
		    jtsylve/compiler-explorer:$(TAG) >/dev/null
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