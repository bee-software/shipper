# Purpleship configuration

By default, purpleship reads a configuration file located at `$HOME/.purpleshiprc`.
The path to this file can be controlled with the environment variable `PURPLESHIP_RC`.

## Options
### image_namespace
Docker image internal namespace.
Allows specifying the internal namespace for use in the audit process.

### image_registry_url
Docker image registry URL.
Allows audit process to remove registry URL from image names.