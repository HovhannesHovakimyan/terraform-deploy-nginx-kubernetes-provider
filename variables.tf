variable "kub_deploy_params" {
  default = {
    name                                  = "scalable-nginx-example"
    label                                 = "ScalableNginxExample"
    replica_count                         = "4"
    match_label                           = "ScalableNginxExample"
    template_label                        = "ScalableNginxExample"
    template_container_image              = "nginx:latest"
    template_container_name               = "example"
    template_container_port               = 80
    template_container_res_cpu_limit      = "0.5"
    template_container_res_memory_limit   = "512Mi"
    template_container_res_cpu_request    = "250m"
    template_container_res_memory_request = "50Mi"
  }
  type = object(
    {
      name                                  = string
      label                                 = string
      replica_count                         = string
      match_label                           = string
      template_label                        = string
      template_container_image              = string
      template_container_name               = string
      template_container_port               = number
      template_container_res_cpu_limit      = string
      template_container_res_memory_limit   = string
      template_container_res_cpu_request    = string
      template_container_res_memory_request = string
    }
  )
}

variable "kub_service_params" {
  default = {
    name        = "nginx-demo"
    port        = 80
    target_port = 80
    type        = "LoadBalancer"
  }
  type = object(
    {
      name        = string
      port        = number
      target_port = number
      type        = string
    }
  )
}