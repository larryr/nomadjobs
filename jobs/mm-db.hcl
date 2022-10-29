job "mmdb-job" {
  datacenters = ["lava"]

  group "mm=db-grp" {
    count = 1

    constraint {
      attribute = "${node.class}"
      value = "general"
    }
    constraint {
      attribute = "${attr.unique.hostname}"
      value = "n5"
    }

    restart {
      attempts = 10
      interval = "5m"
      delay    = "25s"
      mode     = "delay"
    }
    network {
      port "pg" {
        static = 5432
      }
    }

    service {
      provider = "nomad"
      port     = "pg"
      name     = "mmdb"
      tags     = ["mm"]

      check {
        name = "alive"
        type = "tcp"
        interval = "10s"
        timeout  = "2s"
      }
    }

    volume "vol_nomad_global" {
      type  = "host"
      read_only = false
      source    = "nomad_global"
    }

    task "mmdb" {
      driver = "docker"

      # mount nomad vol into container instance
      volume_mount {
        volume = "vol_nomad_global"
        destination = "/data"
        read_only   = false
      }

      env {
        POSTGRES_USER="mmdb"
        POSTGRES_PASSWORD="mmdb"
        POSTGRES_DB="mmdb"
        PGDATA = "/data/mmdb"
      }
      config {
        image = "postgres:15"
        ports = ["pg"]
      }

      resources {
        cpu    = 1000
        memory = 600
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