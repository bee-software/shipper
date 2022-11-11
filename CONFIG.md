# Shipper configuration

By default, shipper reads a configuration file located at `$HOME/.shipperrc`.
The path to this file can be controlled with the environment variable `SHIPPER_RC`.

## Options
### image_namespace
Docker image internal namespace.
Allows specifying the internal namespace for use in the audit process.

### image_registry_url
Docker image registry URL.
Allows audit process to remove registry URL from image names.