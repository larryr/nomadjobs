job "testbatch1" {
  datacenters = ["lava"]
  type = "batch"

  group "cmds" {
    task "shell" {
      driver = "exec"

      config {
        command = "sh"
        args = ["-c", "pwd; ls -l"]
      }
    }
  }
}
