# https://chris-lamb.co.uk/posts/starting-ipython-automatically-from-zsh

zmodload zsh/regex

math_regex='^[\d\-][\d\.\s\+\*\/\-]*$'

function math_precmd() {
	if [ "${?}" = 0 ]
	then
		return
	fi

	if [ -z "${math_command}" ]
	then
		return
	fi

	if whence -- "$math_command" 2>&1 >/dev/null
	then
		return
	fi

	if [ "${math_command}" -regex-match "${math_regex}" ]
	then
		echo
		ipython -i -c "_=${math_command}; print _"
	fi
}

function math_preexec() {
	typeset -g math_command="${1}"
}

typeset -ga precmd_functions
typeset -ga preexec_functions

precmd_functions+=math_precmd
preexec_functions+=math_preexec
