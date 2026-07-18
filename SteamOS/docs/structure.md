Explain the philosophy.

```md
# Repository Structure

Each application owns its own installer.

Configuration files live inside the repository and are symlinked into the correct
locations.

Nothing is edited in-place except:

- /etc/fstab