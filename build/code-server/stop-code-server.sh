#!/bin/bash

ps -ef | grep '[c]ode-server' | grep -v "stop-code\|start-code" | awk '{print $2}' | xargs kill -9 >/dev/null 2>&1
echo "Stopped any code-server processes"
exit 0