# VPN Spawner

Spawn your own VPN server with one command.

## Requirements

- [Terraform](https://www.terraform.io/)
- [Ansible](https://www.ansible.com/)
- [gcloud](https://cloud.google.com/sdk/gcloud/)

## Usage

1. Clone this repository.

```bash
git clone https://github.com/iamludal/vpn-spawner.git
```

2. Authenticate yourself to the Google Cloud SDK.

```bash
gcloud auth login
```

3. Set your project ID using the `GCLOUD_PROJECT_ID` environment variable.

```bash
export GCLOUD_PROJECT_ID=[your_project_id]
```

4. Spawn your VPN server.

```bash
./spawn.sh
```

4. Connect to your VPN server by opening the generated `client.ovpn` file in a VPN client.

5. Once you're done, destroy your VPN server.

```bash
./destroy.sh
```
