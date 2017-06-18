#!/bin/bash
#
# env.sh
#
# Convenience script for loading and unloading a custom shell environment. I
# use it with projects to setup paths e.g. the Django manage script, and
# activating the Python virtualenv.
#
# Author: Emil Stenqvist <emsten@gmail.com>
#
# To load/unload:
#
#   $ source env.sh
#   $ # Do nice things...
#   $ env-deactivate
#

env_path="$(pwd)/$0"
base_path="$(dirname $env_path)"

function env-activate {

  if [[ ! -z $_ENV_CURRENT ]]; then
    echo "ERROR: env already activated: $env_path"
    echo "(do \`env-deactivate\` first)"
    return
  fi

  echo "-- Activating shell environment in $env_path"
  echo "(run 'env-deactivate' to restore environment)"
  echo

  export _ENV_CURRENT=$env_path
  export _ENV_OLD_PATH=$PATH

  ## Custom activation

  export PATH=$PATH:$base_path/scripts
  source $base_path/../env/bin/activate
  alias manage-example="python $base_path/manage.py"

}

function env-deactivate {
  echo "-- De-activating shell environment in $env_path"

  ## Custom de-activation

  unalias manage-example
  deactivate

  ##

  unset _ENV_CURRENT
  export PATH=$_ENV_OLD_PATH
  unset _ENV_OLD_PATH
}

env-activate
