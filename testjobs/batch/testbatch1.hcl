job "testbatch1" {
  datacenters = ["lava"]
  type = "batch"

  group "cmds" {
    constraint {
      attribute = "${attr.unique.hostname}"
      value = "g1"
    }
    task "shell" {
      driver = "raw_exec"

      config {
        command = "sh"
        args = ["-c", "pwd; ls -l"]
      }
      template {
        data = <<EOH
        ---

          bind_port:   {{ env "NOMAD_PORT_db" }}
          scratch_dir: {{ env "NOMAD_TASK_DIR" }}
          node_id:     {{ env "node.unique.id" }}
          service_key: {{ key "service/my-key" }}
        EOH
        destination = "local/install.sh"
      }

    }
  }
}
