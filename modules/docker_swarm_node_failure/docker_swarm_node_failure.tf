resource "shoreline_notebook" "docker_swarm_node_failure" {
  name       = "docker_swarm_node_failure"
  data       = file("${path.module}/data/docker_swarm_node_failure.json")
  depends_on = [shoreline_action.invoke_check_failed_node,shoreline_action.invoke_node_setup_and_docker_restart,shoreline_action.invoke_down_node_scale_up_service]
}

resource "shoreline_file" "check_failed_node" {
  name             = "check_failed_node"
  input_file       = "${path.module}/data/check_failed_node.sh"
  md5              = filemd5("${path.module}/data/check_failed_node.sh")
  description      = "Identify the failed node(s) using Docker Swarm commands or monitoring tools, and verify if the node is still reachable or if it has completely gone down."
  destination_path = "/tmp/check_failed_node.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "node_setup_and_docker_restart" {
  name             = "node_setup_and_docker_restart"
  input_file       = "${path.module}/data/node_setup_and_docker_restart.sh"
  md5              = filemd5("${path.module}/data/node_setup_and_docker_restart.sh")
  description      = "If the node is still reachable, try restarting the Docker service or the node itself to see if it resolves the issue."
  destination_path = "/tmp/node_setup_and_docker_restart.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "down_node_scale_up_service" {
  name             = "down_node_scale_up_service"
  input_file       = "${path.module}/data/down_node_scale_up_service.sh"
  md5              = filemd5("${path.module}/data/down_node_scale_up_service.sh")
  description      = "If the node is completely down, remove it from the Swarm cluster and replace it with a new node, or scale up the existing nodes to ensure sufficient capacity to handle the workload."
  destination_path = "/tmp/down_node_scale_up_service.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_check_failed_node" {
  name        = "invoke_check_failed_node"
  description = "Identify the failed node(s) using Docker Swarm commands or monitoring tools, and verify if the node is still reachable or if it has completely gone down."
  command     = "`chmod +x /tmp/check_failed_node.sh && /tmp/check_failed_node.sh`"
  params      = ["NODE_NAME"]
  file_deps   = ["check_failed_node"]
  enabled     = true
  depends_on  = [shoreline_file.check_failed_node]
}

resource "shoreline_action" "invoke_node_setup_and_docker_restart" {
  name        = "invoke_node_setup_and_docker_restart"
  description = "If the node is still reachable, try restarting the Docker service or the node itself to see if it resolves the issue."
  command     = "`chmod +x /tmp/node_setup_and_docker_restart.sh && /tmp/node_setup_and_docker_restart.sh`"
  params      = ["NODE_IP_ADDRESS","NODE_HOSTNAME"]
  file_deps   = ["node_setup_and_docker_restart"]
  enabled     = true
  depends_on  = [shoreline_file.node_setup_and_docker_restart]
}

resource "shoreline_action" "invoke_down_node_scale_up_service" {
  name        = "invoke_down_node_scale_up_service"
  description = "If the node is completely down, remove it from the Swarm cluster and replace it with a new node, or scale up the existing nodes to ensure sufficient capacity to handle the workload."
  command     = "`chmod +x /tmp/down_node_scale_up_service.sh && /tmp/down_node_scale_up_service.sh`"
  params      = ["NODE_NAME","SERVICE_NAME"]
  file_deps   = ["down_node_scale_up_service"]
  enabled     = true
  depends_on  = [shoreline_file.down_node_scale_up_service]
}

