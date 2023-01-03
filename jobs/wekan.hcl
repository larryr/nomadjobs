job "wekanjob" {
  datacenters = ["lava"]
  type = "system"

  group "wekan" {
    count = 1

    constraint {
      attribute = "${attr.kernel.name}"
      value = "linux"
    }
    constraint {
      attribute = "${attr.unique.hostname}"
      value = "n0"
    }

    restart {
      attempts = 3
      interval = "5m"
      delay    = "10s"
      mode     = "delay"
    }
    network {
      port "client" {
        static = 7777
      }
    }

    task "wekan" {
      driver = "docker"
      config {
        image = "wekanteam/wekan:latest"
        ports = ["client"]
      }

      resources {
        cpu    = 200
        memory = 128
      }

      service {
        provider = "consul"
        port     = "client"
        name     = "wekan"
        tags     = ["test"]
      }

      env {
        INFOSRV_TESTENV = "sample-env-var"
      }
    }
  }
}
