job "consulcfgcli" {
  datacenters = ["lava"]
  type = "sysbatch"

  group "cfgcli" {
    constraint {
      attribute = "${node.class}"
      value     = "general"
    }
    constraint {
      attribute = "${attr.unique.hostname}"
      value = "n50"
    }

    task "cfgcli" {
      driver = "raw_exec"

      config {
        command = "bash"
        args = [
          "-v",
          "local/run.sh",
        ]
      }
      template {
        destination = "local/run.sh"
        data = <<EOH
cp local/consul.hcl /etc/consul.d/.
cp local/x.pem /etc/consul.d/consul-agent-ca.pem
systemctl restart consul
EOH
      }
      template {
        destination = "local/consul.hcl"
        data = <<EOH
server = false
bind_addr =  "{{"{{"}} GetPrivateInterfaces | include \"network\" \"10.42.0.0/24\" | attr \"address\"}}"
auto_encrypt {
  tls = true
}

EOH
      }
      template {
        destination = "local/x.pem"
        data = <<EOH
-----BEGIN CERTIFICATE-----
MIIC7TCCApSgAwIBAgIRANm4MoVDs31bFdvZWy/6/dwwCgYIKoZIzj0EAwIwgbkx
CzAJBgNVBAYTAlVTMQswCQYDVQQIEwJDQTEWMBQGA1UEBxMNU2FuIEZyYW5jaXNj
bzEaMBgGA1UECRMRMTAxIFNlY29uZCBTdHJlZXQxDjAMBgNVBBETBTk0MTA1MRcw
FQYDVQQKEw5IYXNoaUNvcnAgSW5jLjFAMD4GA1UEAxM3Q29uc3VsIEFnZW50IENB
IDI4OTM5ODg4MjM4NjA3NTQzNTA0MDIzNDEzOTgyOTc0MDk2MTI0NDAeFw0yMjEw
MDIxNjIyMzhaFw0yNzEwMDExNjIyMzhaMIG5MQswCQYDVQQGEwJVUzELMAkGA1UE
CBMCQ0ExFjAUBgNVBAcTDVNhbiBGcmFuY2lzY28xGjAYBgNVBAkTETEwMSBTZWNv
bmQgU3RyZWV0MQ4wDAYDVQQREwU5NDEwNTEXMBUGA1UEChMOSGFzaGlDb3JwIElu
Yy4xQDA+BgNVBAMTN0NvbnN1bCBBZ2VudCBDQSAyODkzOTg4ODIzODYwNzU0MzUw
NDAyMzQxMzk4Mjk3NDA5NjEyNDQwWTATBgcqhkjOPQIBBggqhkjOPQMBBwNCAASu
uDKTefyXv1Qa0yNkGMPG30CDIxOsquAViwqzuu5hnl405cb+kAZ2guHSRSNl1SMg
bEoTA6Bo0FjbZ+RdoZTzo3sweTAOBgNVHQ8BAf8EBAMCAYYwDwYDVR0TAQH/BAUw
AwEB/zApBgNVHQ4EIgQgHrkGxG0pWz+8C1Ur1i1WWZSbn9+2Hx9CMgvI1sXyyNww
KwYDVR0jBCQwIoAgHrkGxG0pWz+8C1Ur1i1WWZSbn9+2Hx9CMgvI1sXyyNwwCgYI
KoZIzj0EAwIDRwAwRAIgYdNQXasocu59/LLH597ienUOuQLXipy1U+jKbcyb7zMC
IH8JQfSSIPESTqVFkJbY3sJa/T902us/b5n6zItX5Ww9
-----END CERTIFICATE-----
EOH
      }
    }
  }
}
