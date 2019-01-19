# Pleroma Ansible Roles

This project is a collection of [Ansible](http://ansible.com) roles designed to install one or
more [Pleroma](https://pleroma.social) instances behind an [Nginx](http://nginx.org) reverse proxy.

## Example Playbook

The following example configures two Pleroma instances on one host and uses an Nginx reverse proxy to route based on
domain name. The second site is optional.

```yaml
- hosts: pleroma
  roles:
    - role: pleroma
      pleroma_user: "pleroma_example"
      pleroma_link_host: "example.social"
      pleroma_port: 4000
      pleroma_signup_open: "true"

- hosts: pleroma
  roles:
    - role: pleroma
      pleroma_user: "pleroma_test"
      pleroma_link_host: "test.social"
      pleroma_port: 4001
      pleroma_signup_open: "true"
```

## Example Ansible Vars

The following variables would go into Ansible `group_vars`, for example, and connects to an AWS RDS PostgreSQL database.

```yaml
nginx_conf_src:    "roles/pleroma/templates/pleroma.nginx.conf.j2"
nginx_enable_ssl:  Yes
nginx_server_name: "{{pleroma_link_host}}"

pleroma_link_scheme: "https"
pleroma_db_host: "pleroma.123123.us-east-1.rds.amazonaws.com"
pleroma_db_passwd: "pleDbPass123"
pleroma_db_superpass: "dbpass123"
pleroma_secret_key: "secret123"
```
