#!/bin/sh
useradd -m $USER -u $UID -s /bin/bash
mkdir -p /workspace/.jupyter/ && ln -fs /workspace/.jupyter /home/$USER/.jupyter && chown -R $USER:$USER /workspace /home/$USER /opt/conda
export SHELL=/bin/bash
exec gosu $USER jupyter $*
