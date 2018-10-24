## Usage
```yaml
version: "3.7"
services:
  db:
    build:
      context: ./db
    image: demoapp/db
    volumes:
      - db_master:/var/lib/postgresql
      - path_to_your_confs_folder:/var/lib/postgresql/confs # for example ./confs
      - path_to_your_init_files:/var/lib/postgresql/init.d # for example ./init.d
    secrets:
      - db_cert

volumes:
  db_master:

secrets:
  db_cert:
    file: path_to_your_cert_file
    # example cert file content:
        # dbname   = demo_db
        # username = demo_admin
        # password = demo_pwd
```