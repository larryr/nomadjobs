job "installgui" {
  datacenters = ["lava"]
  type = "batch"

  group "installer" {
    constraint {
      attribute = "${attr.unique.hostname}"
      value     = "u1"
    }

    task "shell" {
      driver = "raw_exec"

      config {
        command = "bash"
        args = ["-v", "local/i.sh"]
      }
      template {
        data = <<EOH
          apt-get -y update
          apt-get -y upgrade
          apt-get -y install ubuntu-desktop
          apt-get -y install lightdm
          systemctl start lightdm.service
          shutdown -r now
        EOH
        destination = "local/i.sh"
      }
    }
  }
}
