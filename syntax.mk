syntaxcheck: shellcheck $(syntax-checkers)

shellcheck:
	shellcheck $(SHELL_SCRIPTS) || :
