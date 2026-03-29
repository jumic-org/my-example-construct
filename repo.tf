terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

# Configure the GitHub Provider
provider "github" {
  owner = "jumic-org"
}

variable "enable_branch_protection" {
  type    = bool
  default = true
}

resource "github_repository" "example" {
  name        = "my-example-construct"
  description = "My Example Construct"

  visibility         = "public"
  allow_auto_merge   = true
  allow_merge_commit = false
  allow_rebase_merge = false
  allow_squash_merge = true

  vulnerability_alerts = true
  allow_update_branch = true
  has_issues = true
}

resource "github_repository_dependabot_security_updates" "example" {
  repository = github_repository.example.name
  enabled    = true

}

resource "github_repository_ruleset" "example" {
  count       = var.enable_branch_protection ? 1 : 0
  name        = "main"
  repository  = github_repository.example.name
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["~DEFAULT_BRANCH"]
      exclude = []
    }
  }

  rules {
    required_linear_history = true
    non_fast_forward = true

    pull_request {
      allowed_merge_methods = ["squash"]
    }
    merge_queue {
      max_entries_to_build              = 1
      max_entries_to_merge              = 1
      min_entries_to_merge              = 1
      check_response_timeout_minutes    = 60
      min_entries_to_merge_wait_minutes = 1
      merge_method                      = "SQUASH"
    }

    required_status_checks {
      required_check {
        context = "Validate semantic format"
      }
      required_check {
        context = "Check formatting"
      }
      required_check {
        context = "Lint code"
      }
      required_check {
        context = "Install dependencies"
      }
      required_check {
        context = "Build project"
      }
    }
  }
}
