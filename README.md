# Simple-HTTPS-Proxy

## Initial setup

### Config

- Edit [`nginx/conf.d/default.conf`](nginx/conf.d/default.conf)
  - replace `yourdomain.com` with your actual domain on line `3`, `17`, `19` and `20`.
  - replace `http://backend_service:backend_port` with your actual backend location on line `23`.
- Edit [`firstrun.sh`](firstrun.sh)
  - replace `yourdomain.com` with your actual domain on line `3`

### First run

On a linux machine run:
```bash
./firstrun.sh
```
this will start the containers and generate a new key.
> This requires you to have the nginx server accessible via the domain you configured in [#Config](#config)
