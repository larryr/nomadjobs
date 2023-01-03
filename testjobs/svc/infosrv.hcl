job "infosrv-job" {
  datacenters = ["lava"]
  type = "system"

  group "infosrv-grp" {
    count = 1

    constraint {
      attribute = "${attr.kernel.name}"
      value = "linux"
    }

    restart {
      attempts = 3
      interval = "5m"
      delay    = "10s"
      mode     = "delay"
    }
    network {
      port "client" {
        static = 9999
      }
    }

    task "infosrv" {
      driver = "docker"
      config {
        image = "larryrau/infosrv:latest"
        ports = ["client"]
      }

      resources {
        cpu    = 100
        memory = 128
      }

      service {
        provider = "consul"
        port     = "client"
        name     = "infosrv"
        tags     = ["test"]
      }

      env {
        INFOSRV_TESTENV = "sample-env-var"
      }
    }
  }
}
