job "charla" {
  datacenters = ["dc1"]

  meta {
    version = "alpha-8"
  }

  group "elixir" {
    count = "2"

    network {
      mode = "bridge"

      port "http" {
        to = 443
      }

      port "vErlangen" {
        to = 8001
      }
    }

    service {
      name = "charla"
      port = "http"
    }

    service {
      name = "cluster"
      port = "vErlangen"
    }

    task "proxy" {
      driver = "docker"

      config {
        image = "nginx"
        ports = ["http"]
        volumes = [
          "config/nginx.conf:/etc/nginx/nginx.conf"
        ]
      }

      env {
        APP_PORT = "4000"
      }

      template {
        data = <<EOF
        worker_processes  1;
        events {
            worker_connections  1024;
        }
        http {
            include       mime.types;
            default_type  application/octet-stream;
            sendfile        on;
            keepalive_timeout  65;
            server {
                listen       443;
                location / {
                    proxy_pass http://localhost:{{ env "APP_PORT" }};
                }
            }
        }
        EOF
        destination = "config/nginx.conf"
      }

      resources {
        cpu = 50
        memory = 128
      }
    }

    task "phoenix" {
      driver = "docker"

      env {
        SECRET_KEY_BASE = "6+KIdQCSSDYFt5JHSfsN2M63IhkGnBHCuWS3Pk0ZWE6/YbNaWPfE6GC5W4DDFxjZ"
        DATABASE_URL = "ecto://postgres:postgres@10.0.2.15:5432/charla_dev"
        PORT = "4000"
        RELEASE_COOKIE = "don't tell anyone this"
        ERL_DIST_PORT = "8001"
      }

      template {
        data = <<-EOF
          # charlas
          {{ range service "cluster" }}{{ .Address }}:{{ .Port }}
          {{ end }}
        EOF
        change_mode = "restart"
        destination = "local/charlas.txt"
      }

      config {
        image = "charla-build-release:local"
        ports = ["vErlangen"]
      }

      resources {
        cpu = 100
        memory = 256
      }
    }
  }
}

