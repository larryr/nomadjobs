job "genfract" {
  datacenters = ["lava"]
  type = "service"

  group "genfract-grp" {
    count = 1

    constraint {
      attribute = "${node.class}"
      value = "general"
    }
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
        static = 4000
      }
    }

    task "genfract" {
      driver = "docker"

      config {
        image = "larryrau/genfract:latest"
        ports = ["client"]
      }

      resources {
        cpu    = 100
        memory = 128
      }

      service {
        provider = "consul"
        port     = "client"
        name     = "genfract"
        tags     = ["test"]
      }
    }
  }
}