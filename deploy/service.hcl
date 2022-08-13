variable "telegram_bot_token" {
  type        = string
  description = "Telegram bot token"
}

variable "admin_id" {
  type        = number
  description = "Administrator ID"
}

locals {
  rss_bot_version = "2.0.0-alpha-11-en"
}

# https://www.nomadproject.io/docs/job-specification/job
job "rss-bot" {
  type        = "service"
  datacenters = ["primary-dc"]
  namespace   = "apps"

  # https://www.nomadproject.io/docs/job-specification/group
  group "rss-bot" {
    count = 1

    volume "persistent-data" {
      type      = "host"
      source    = "persistent-data"
      read_only = false
    }

    task "make-storage-directory" { # make a sub-dir in the persistent data for the app
      driver = "docker"

      lifecycle {
        hook    = "prestart"
        sidecar = false
      }

      volume_mount {
        volume      = "persistent-data"
        destination = "/data"
      }

      config {
        image = "alpine:latest"
        args  = ["install", "--verbose", "-d", "-m", "0777", "-o", "nobody", "-g", "nogroup", "/data/rss-bot"]
      }
    }

    task "rss-bot" {
      driver = "docker"

      volume_mount {
        volume      = "persistent-data"
        destination = "/data"
      }

      # https://www.nomadproject.io/docs/drivers/docker
      config {
        image = "ghcr.io/tarampampam/rssbot:${ local.rss_bot_version }"

        args = [
          "--admin", convert(var.admin_id, string),
          "--database", "/data/rss-bot/rss-bot.json",
          var.telegram_bot_token,
        ]
      }

      # https://www.nomadproject.io/docs/job-specification/template#consul-kv
      template {
        data = <<-EOH
        {{ range ls "apps/bots/telegram-rss/environment" }}
        {{ .Key }}={{ .Value }}
        {{ end }}
        EOH

        destination = "local/environment"
        env         = true
      }

      # https://www.nomadproject.io/docs/job-specification/resources
      resources {
        cpu        = 50 # in MHz
        memory     = 10 # in MB
        memory_max = 64 # in MB
      }

      # https://www.nomadproject.io/docs/job-specification/service
      service {
        name = "telegram-rss-bot"
        tags = ["telegram", "bot"]
      }
    }
  }
}
