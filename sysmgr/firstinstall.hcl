job "firstinstall" {
  datacenters = ["lava"]
  type = "batch"

  group "installer" {
    constraint {
      attribute = "${attr.unique.hostname}"
      value     = "g1"
    }

    task "shell" {
      driver = "raw_exec"

      config {
        command = "bash"
        args = ["-v", "local/i.sh"]
      }
      template {
        data = <<EOH
        ---
          apt-get -y update
          apt-get -y install ca-certificates curl gnupg lsb-release
          mkdir -p /etc/apt/keyrings
          sudo mkdir -p /etc/apt/keyrings
          # add docker gpg key
          curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
          # setup docker repo
          echo \
          "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
          $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
          apt-get -y update
          apt-get -y install docker-ce containerd.io
        EOH
        destination = "local/i.sh"
      }
    }
  }
}
