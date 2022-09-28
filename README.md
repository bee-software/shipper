# Purpleship.sh

Simple container deployment tool based on Docker and Docker Compose.

## Usage
Invoke purpleship with the path to a shipping label

    $ ship.sh <shipping_label>

### Using the built-in examples

Some example shipping labels are provided in the `examples` directory.

    $ ship.sh examples/basic


## Configuration

Purpleship can be configured using a `.purpleshiprc` file. The file must be located in the working directory.
Additionally, a global configuration file can be placed in `$HOME/.purpleshiprc`.
The global configuration file will be used as a fallback.

    $ cat $HOME/.purpleshiprc
    image_namespace=demo
    image_registry_url=images.demo.example.com

The path to the global configuration file can also be controlled via the `PURPLESHIP_RC` environment variable.

    $ export PURPLESHIP_RC=/opt/demo/.purpleshiprc
    $ ship.sh examples/basic

See `CONFIG.md` for all configuration options.

## Contributors

Special shoutout to François Perron, Jonathan Provost and Philippe Godin for contributing 
to this project prior to it's open source release. Thank you for believing in simple software =)