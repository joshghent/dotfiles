if status is-interactive
    # Commands to run in interactive sessions can go here
end
set -Ux PATH /opt/homebrew/bin $PATH
set -x DOCKER_HOST unix://$HOME/.colima/docker.sock

