provider "github" {
  token = var.github_token
  owner = var.github_organization
}

variable "repository_name" {
  type = string
}

variable "collaborator_user" {
  type = string
  default = ""
}

variable "team_slug" {
  type = string
  default = ""
}

variable "permission" {
  type = string
  default = "push"  # Can be "pull", "push", or "admin"
}

# Conditional block for adding a user or team
resource "github_repository_collaborator" "user_access" {
  count      = var.collaborator_user != "" ? 1 : 0
  repository = var.repository_name
  username   = var.collaborator_user
  permission = var.permission
}

resource "github_team_repository" "team_access" {
  count      = var.team_slug != "" ? 1 : 0
  team_id    = lookup(data.github_teams.all_teams.teams, var.team_slug).id
  repository = var.repository_name
  permission = var.permission
}

# Data source to fetch all teams for the organization
data "github_teams" "all_teams" {
  org = var.github_organization
}
