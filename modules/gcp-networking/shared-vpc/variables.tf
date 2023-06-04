variable "project_id" {
   type        = string
   description = "The id of the Host VPC project" 
 }

 variable "service_projects_list" {
  type        = list(string)
  description = "The IDs of the projects that will serve as a Shared VPC service project."
  
}
