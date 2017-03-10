#!/usr/bin/env zsh

setopt EXTENDED_GLOB
for template_file in "${ZDOTDIR:-${HOME}}"/.zim/templates/^zshrc(.N); do
  cp "$template_file" "${ZDOTDIR:-${HOME}}/.${template_file:t}"
done
