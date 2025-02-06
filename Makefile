# Setting SHELL to bash allows bash commands to be executed by recipes.
# This is a requirement for 'setup-envtest.sh' in the test target.
# Options are set to exit when a recipe line exits non-zero or a piped command fails.
SHELL = /usr/bin/env bash -o pipefail
.SHELLFLAGS = -ec

all: submodule up listen notes

##@ General

# The help target prints out all targets with their descriptions organized
# beneath their categories. The categories are represented by '##@' and the
# target descriptions by '##'. The awk commands is responsible for reading the
# entire set of makefiles included in this invocation, looking for lines of the
# file as xyz: ## something, and then pretty-format the target and help. Then,
# if there's a line with ##@ something, that gets pretty-printed as a category.
# More info on the usage of ANSI control characters for terminal formatting:
# https://en.wikipedia.org/wiki/ANSI_escape_code#SGR_parameters
# More info on the awk command:
# http://linuxcommand.org/lc3_adv_awk.php

help: ## Display this help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

submodule: ## Update submodule
	@echo "Updating submodule, please wait..."
	@git submodule update --init --recursive

up: ## Start docker compose
	@echo "Starting docker compose, please wait..."
	@docker compose up -d

down: ## Stop docker compose
	@echo "Stopping docker compose, please wait..."
	@docker compose down
listen-emqx: ## Listen to the message from EMQX
	@echo "Running the following commands to see the message from EMQX"
	@docker logs -f mqttx
listen-kafka: ## Listen to the message from Kafka consumer
	@echo "Running the following commands to see the message from kafka consumer"
	@docker exec -it kafka kafka-console-consumer.sh --topic my-vehicles --from-beginning --bootstrap-server localhost:9092

notes:
	@echo "Running the following commands to see the message from MQTTX"
	@echo '```'
	@echo "docker logs -f mqttx"
	@echo '```'
	@echo "Running the following commands to see the message from kafka consumer"
	@echo '```'
	@echo "docker exec -it kafka kafka-console-consumer.sh --topic my-vehicles --from-beginning --bootstrap-server localhost:9092"
	@echo '```'
	@echo "If you want to view the Grafana dashboard, you can open http://localhost:3000 in your browser, and login with admin:public"
