job "db-trial" {

  type        = "service"
  group "mysql-server" {
    count = 1

    
    constraint {
      attribute = "${attr.unique.hostname}"
      value = "n50"
    }

    network {
      port "db" {
        static = 3306
      }
    }


    task "mysql-server" {
       driver = "docker"
       config {
         image = "mysql/mysql-server:8.0"
         port_map {
           db = 3306
         }
         volumes = [
           "docker-entrypoint-initdb.d/:/docker-entrypoint-initdb.d/",
         ]
       }

       service {
         provider = "consul"
         name = "dbtrial"
         port = "db"

         check {
           type     = "tcp"
           interval = "10s"
           timeout  = "2s"
         }
       }

       template {
         data = <<EOH
CREATE DATABASE dbwebappdb;
CREATE USER 'dbwebapp'@'%' IDENTIFIED BY 'dbwebapp';
GRANT ALL PRIVILEGES ON dbwebappdb.* TO 'dbwebapp'@'%';
         EOH
         destination = "/docker-entrypoint-initdb.d/db.sql"
      }
      resources {
        cpu = 500
        memory = 1024

      }
    }
  }
}
