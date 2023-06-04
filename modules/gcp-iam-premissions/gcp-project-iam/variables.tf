variable "project_iam_role_bindings" {

  default = {
    "project1" = {
      "role1" : ["member1", "member2", "member5"],
      "role2" : ["member3", "member2"],
    },
    "project2" = {
      "role3" : ["member1", "member4"],
      "role2" : ["member5"],
    }
  }
}
