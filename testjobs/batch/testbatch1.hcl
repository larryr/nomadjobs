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
        destination = "local/install.sh"
        data = <<EOH
        ---

          bind_port:   {{ env "NOMAD_PORT_db" }}
          scratch_dir: {{ env "NOMAD_TASK_DIR" }}
          node_id:     {{ env "node.unique.id" }}
          node_class:  {{ env "node.class" }}
        EOH
      }

    }
  }
}
