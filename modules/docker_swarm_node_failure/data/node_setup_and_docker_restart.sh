

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