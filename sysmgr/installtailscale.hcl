job "installtailscale" {
  datacenters = ["lava"]
  type = "batch"

  group "tsinstaller" {
    constraint {
      attribute = "${attr.unique.hostname}"
      value     = "n50"
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
        apt-get -y install curl
        curl -fsSL https://tailscale.com/install.sh | sh
        tailscale up --authkey tskey-auth-ktzhhP6CNTRL-6wy9KXDwCuCDygr5rtu5tCbSmu7iFxcr8
        EOH
        destination = "local/i.sh"
      }
    }
  }
}
