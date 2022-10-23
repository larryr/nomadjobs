job "topcua1" {
  datacenters = ["lava"]

  group "test-opcua" {
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
      port "srv" {
        static = 50000
      }
      port "http" {
        static = 8080
      }
    }

    task "plc" {
      driver = "docker"

      config {
        image = "mcr.microsoft.com/iotedge/opc-plc:latest"

        args = [
          "--loglevel=verbose"
        ]

        ports = ["srv","http"]
      }

      resources {
        cpu    = 1000
        memory = 600
      }

      service {
        provider = "nomad"
        port     = "srv"
        name     = "opcua"
        tags     = ["test"]

      }
    }
  }
}