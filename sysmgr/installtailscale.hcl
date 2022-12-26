job "installtailscale" {
  datacenters = ["lava"]
  type = "batch"

  group "tsinstaller" {
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
        apt-get -y install curl
        curl -fsSL https://tailscale.com/install.sh | sh
        tailscale up --authkey tskey-auth-kUtkG57CNTRL-NnTLjCuirbhRnxXpRswhah4mWJGGyo3TD
        EOH
        destination = "local/i.sh"
      }
    }
  }
}
