job "nats1" {
  datacenters = ["lava"]

  group "test-nats" {
    count = 1

    constraint {
      attribute = "${node.class}"
      value = "general"
    }
    constraint {
      attribute = "${attr.unique.hostname}"
      value = "n4"
    }

    restart {
      attempts = 3
      interval = "5m"
      delay    = "10s"
      mode     = "delay"
    }
    network {
      port "client" {
        static = 4222
      }
    }

    task "nats" {
      driver = "docker"

      config {
        image = "nats"

        args = [
          "-js"
        ]

        ports = ["client"]
      }

      resources {
        cpu    = 1000
        memory = 600
      }

      service {
        provider = "nomad"
        port     = "client"
        name     = "nats"
        tags     = ["test"]

      }
    }
  }
}