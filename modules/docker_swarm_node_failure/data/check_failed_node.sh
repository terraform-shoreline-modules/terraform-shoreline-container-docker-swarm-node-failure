

#!/bin/bash



# Set variables

NODE_NAME=${NODE_NAME}



# Identify the failed node(s)

docker node ls | grep $NODE_NAME



# Verify if the node is still reachable or completely down

docker node inspect $NODE_NAME | grep "Status"