job "consulcfgall" {
  datacenters = ["lava"]
  type = "sysbatch"

  group "cfgall" {

    task "cfgall" {
      driver = "raw_exec"

      config {
        command = "sh"
        args = ["-c", "/usr/bin/cp local/common.hcl /etc/consul.d/."]
      }
      template {
        destination = "local/common.hcl"
        data = <<EOH
datacenter = "lava"
data_dir = "/opt/consul"

ui_config{
  enabled = true
}
encrypt = "bDZipN4JRjeBEn3z1zAmU+qpf6Z66b/NvJqz2yo/Veo="

http_config {
  response_headers {
    Access-Control-Allow-Origin = "*"
  }
}
verify_incoming = true
verify_outgoing = true
verify_server_hostname = true

log_level = "INFO"

ca_file = "/etc/consul.d/consul-agent-ca.pem"

retry_join = ["maas.lava.home"]

EOH
      }
    }
  }
}
