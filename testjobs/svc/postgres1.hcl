job "postgres1" {
  datacenters = ["lava"]

  group "postgres1-grp" {
    count = 1

    constraint {
      attribute = "${node.class}"
      value = "general"
    }
    constraint {
      attribute = "${attr.unique.hostname}"
      value = "n2"
    }

    restart {
      attempts = 10
      interval = "5m"
      delay = "25s"
      mode = "delay"
    }

    network {
      port "pg" {
        static = 5432
      }
    }

    task "postgres1" {
      driver = "docker"
      config {
        image = "postgres"
        network_mode = "host"
        ports = ["pg"]
      }
      env {
        POSTGRES_USER="root"
        POSTGRES_PASSWORD="root"
      }

      logs {
        max_files     = 5
        max_file_size = 15
      }

      resources {
        cpu = 1000
        memory = 1024
      }
      service {
        provider = "nomad"
        name = "postgres"
        tags = ["test"]
        port = "pg"

        check {
          name     = "alive"
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }

  }

  update {
    max_parallel = 1
    min_healthy_time = "5s"
    healthy_deadline = "3m"
    auto_revert = false
    canary = 0
  }
}