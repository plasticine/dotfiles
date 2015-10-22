eval "$(docker-machine env default)"
export DOCKER_IP="$(docker-machine ip $DOCKER_MACHINE_NAME)"
