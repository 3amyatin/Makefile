SHELL = bash
.ONESHELL:
.SHELLFLAGS = -eu -o pipefail -c
.DELETE_ON_ERROR:


RED = $(shell tput setaf 1)
GREEN = $(shell tput setaf 2)
RESET = $(shell tput sgr0)

print-target = @printf "\n$(GREEN)************************************** $(RESET)$(shell echo $@ | tr '[:lower:]' '[:upper:]')$(GREEN) **************************************$(RESET)\n"

.PHONY: menu create login recreate init plan apply destroy clean

menu:
	$(call print-target)
	@echo "Select a target to run:"; \
	echo "s) Create $(GREEN)S$(RESET)andbox"; \
	echo "r) $(GREEN)R$(RESET)ecreate sandbox"; \
	echo "c) Clean"; \
	echo "q) Quit"; \
	echo -n "Enter your choice: "; \
	stty -echo -icanon; \
	choice=$$(dd bs=1 count=1 2>/dev/null); \
	stty echo icanon; \
	
	case $$choice in \
		c) $(MAKE) clean ;; \
		q) echo "Goodbye!"; exit ;; \
		r) $(MAKE) recreate ;; \
		s) $(MAKE) sandbox ;; \
		*) echo "Invalid choice. Try again." ;; \
	esac; \

login:
	$(call print-target)
	echo aws sso login

sandbox:
	#fix @
	@if [ ! -d "sandbox" ]; then \
		mkdir -p sandbox; \
		cd sandbox; \
		touch .keep; \
		cd - >/dev/null; \
	else \
		echo "Sandbox environment already exists."; \
	fi

create: sandbox
	$(call print-target)

recreate:
	$(call print-target)
	$(MAKE) clean
	$(MAKE) create

init: sandbox
	$(call print-target)
	@echo "terraform init & validate"

plan: init 
	$(call print-target)
	@echo terraform plan

apply: plan
	$(call print-target)
	@echo terraform apply

destroy: plan
	$(call print-target)
	@echo terraform destroy

clean:
	$(call print-target)
	@if [ -d "sandbox" ]; \
		then rm -rf sandbox; \
		else echo "there is no sandbox to clean"; \
	fi