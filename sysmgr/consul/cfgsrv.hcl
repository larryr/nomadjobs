job "consulcfgsrv" {
  datacenters = ["lava"]
  type = "sysbatch"

  group "cfgsrv" {
    constraint {
      attribute = "${node.class}"
      value     = "primary"
    }

    task "cfgsrv" {
      driver = "raw_exec"

      config {
        command = "sh"
        args = ["-c", "cp local/consul.hcl /etc/consul.d/."]
      }
      template {
        destination = "local/consul.hcl"
        data = <<EOH
client_addr =  "{{"{{"}} GetPrivateInterfaces | include \"network\" \"10.42.0.0/24\" | attr \"address\"}}"

server = true
bind_addr =  "{{"{{"}} GetPrivateInterfaces | include \"network\" \"10.42.0.0/24\" | attr \"address\"}}"

cert_file  = "/etc/consul.d/srvca/lava-server-consul-0.pem"
key_file   = "/etc/consul.d/srvca/lava-server-consul-0-key.pem"
auto_encrypt {
  allow_tls = true
}
bootstrap_expect = 1
EOH
      }
    }
  }
}
