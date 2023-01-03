job "wekandb-job" {
  datacenters = ["lava"]

  group "wekandb-grp" {
    count = 1

    constraint {
      attribute = "${node.class}"
      value = "general"
    }
    constraint {
      attribute = "${attr.unique.hostname}"
      value = "n50"
    }

    restart {
      attempts = 10
      interval = "5m"
      delay    = "25s"
      mode     = "delay"
    }
    network {
      port "mongoport" {
        static = 27017
      }
      port "client" {
        static = 7777
        to = 8080
      }
    }

    service {
      provider = "consul"
      port     = "mongoport"
      name     = "wekandb"
      tags     = ["wekan"]

      check {
        name = "alive"
        type = "tcp"
        interval = "10s"
        timeout  = "2s"
      }
    }
    service {
      provider = "consul"
      port     = "client"
      name     = "wekan"
      tags     = ["wekan"]
    }

    volume "vol_nomad_global" {
      type  = "host"
      read_only = false
      source    = "nomad_global"
    }

    task "wekandb" {
      driver = "docker"

      # mount nomad vol into container instance
      volume_mount {
        volume      = "vol_nomad_global"
        destination = "/data"
        read_only   = false
      }

      config {
        image = "mongo:6"
        ports = ["mongoport"]
      }

      resources {
        cpu    = 800
        memory = 600
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
        memory = 600
      }

      env {
        INFOSRV_TESTENV = "sample-env-var"
        WRITEABLE_PATH = "/data/wekanfiles"
        MONGO_URL = "mongodb://${NOMAD_HOST_ADDR_mongoport}/wekan"
        ROOT_URL = "http://${NOMAD_HOST_ADDR_client}"
        CARD_OPENED_WEBHOOK_ENABLED = "false"
        BIGEVENTS_PATTERN = "NONE"
        BROWSER_POLICY_ENABLED = "true"
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