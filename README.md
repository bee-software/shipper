# Purpleship.sh

Simple container deployment tool based on Docker and Docker Compose.

## Usage
Invoke purpleship with the path to a shipping label

    $ ship.sh <shipping_label>

### Using the built-in examples

Some example shipping labels are provided in the `examples` directory.

    $ ship.sh examples/basic

It is also possible configure purpleship via an rc file located at `$HOME/.purpleshiprc`.

    $ cat $HOME/.purpleshiprc
    image_namespace=demo
    image_registry_url=images.demo.example.com

The path to the rc file can also be controlled via the `PURPLESHIP_RC` environment variable.

    $ export PURPLESHIP_RC=/opt/demo/.purpleshiprc
    $ ship.sh examples/basic

## Configuration

See `CONFIG.md` for all configuration options.