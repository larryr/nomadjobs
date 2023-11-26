job "db-trial" {

 type        = "service"

 group "db-trial-grp" {
   count = 1

   restart {
     attempts = 10
     interval = "5m"
     delay    = "25s"
     mode     = "delay"
   }

   volume "vol_nomad_glbal" {
     type      = "host"
     read_only = false
     source    = "nomad_global"
   }

   network {
     port "db" {
       static = 3306
     }
   }

   task "mtk-db-tsk" {
     driver = "docker"

     config {
       image = "bitnami/mysql:8.0"
     }

     volume_mount {
       volume      = "vol_nomad_global"
       destination = "/dbtrial"
       read_only   = false
     }
       
     env = {
       "MYSQL_ROOT_PASSWORD" = "hockey"
     }

     resources {
       cpu    = 500
       memory = 1024
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
   }
 }
}
