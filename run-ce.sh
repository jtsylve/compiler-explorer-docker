#!/bin/bash

# Update compiler explorer and run
(cd /opt/compiler-explorer && git pull)
(cd /opt/compiler-explorer && make)
