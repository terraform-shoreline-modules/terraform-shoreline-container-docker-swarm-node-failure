
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Docker Swarm Node Failure
---

A Docker Swarm Node Failure incident occurs when one or more nodes in a Docker Swarm cluster become unresponsive or go down, resulting in the failure of the applications or services running on those nodes. This can cause a disruption in the availability and performance of the application or service, and may require immediate action from the DevOps team to diagnose and fix the issue.

### Parameters
```shell
export CONTAINER_ID="PLACEHOLDER"

export SERVICE_NAME="PLACEHOLDER"

export NODE_NAME="PLACEHOLDER"

export NODE_HOSTNAME="PLACEHOLDER"

export NODE_IP_ADDRESS="PLACEHOLDER"
```

## Debug

### Check the status of the Docker service on the affected node
```shell
systemctl status docker
```

### Check the logs for any errors or warnings related to the Docker service
```shell
journalctl -u docker.service
```

### List all the running containers on the affected node
```shell
docker ps
```

### Inspect the logs of a specific container to look for any error messages
```shell
docker logs ${CONTAINER_ID}
```

### Check the health status of a specific service running on the Docker Swarm cluster
```shell
docker service ps ${SERVICE_NAME}
```

### Check the status of the Docker Swarm cluster and its nodes
```shell
docker node ls
```

### Check the status of the Docker Swarm manager nodes
```shell
docker node ls --filter role=manager
```

### Check the Docker Swarm events for any recent changes or failures
```shell
docker swarm events
```

## Repair

### Identify the failed node(s) using Docker Swarm commands or monitoring tools, and verify if the node is still reachable or if it has completely gone down.
```shell


#!/bin/bash



# Set variables

NODE_NAME=${NODE_NAME}



# Identify the failed node(s)

docker node ls | grep $NODE_NAME



# Verify if the node is still reachable or completely down

docker node inspect $NODE_NAME | grep "Status"


```

### If the node is still reachable, try restarting the Docker service or the node itself to see if it resolves the issue.
```shell


#!/bin/bash



# Set the node hostname and IP address

NODE_HOSTNAME=${NODE_HOSTNAME}

NODE_IP=${NODE_IP_ADDRESS}



# Check if the node is reachable

ping -c 1 $NODE_IP > /dev/null 2>&1

if [ $? -eq 0 ]; then

  echo "Node is reachable."

else

  echo "Node is not reachable. Exiting."

  exit 1

fi



# Restart the Docker service on the node

ssh $NODE_HOSTNAME "systemctl restart docker"

if [ $? -eq 0 ]; then

  echo "Docker service restarted successfully on the node."

else

  echo "Failed to restart Docker service on the node. Please check logs for more information."

  exit 1

fi


```

### If the node is completely down, remove it from the Swarm cluster and replace it with a new node, or scale up the existing nodes to ensure sufficient capacity to handle the workload.
```shell
bash

#!/bin/bash



# Define the variables for the script

NODE=${NODE_NAME}

SWARM_SERVICE=${SERVICE_NAME}



# Check if the node is down

if [ $(docker node ls | grep $NODE | grep -c Down) -ne 0 ]; then

    # Remove the failed node from the Swarm cluster

    docker node rm $NODE



    # Scale up the existing nodes to ensure sufficient capacity

    docker service scale $SWARM_SERVICE=+1

fi


```