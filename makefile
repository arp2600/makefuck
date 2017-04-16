default:
	@echo "Please specify a target"

include math.makefile

tests: math_tests
	@echo "all tests passed"

COMMA := ,
define SPACE_PROGRAM_STRING
$(strip\
$(subst ],] ,\
$(subst [,[ ,\
$(subst $(COMMA),$(COMMA) ,\
$(subst .,. ,\
$(subst -,- ,\
$(subst +,+ ,\
$(subst <,< ,\
$(subst >,> ,\
$(1))))))))))
endef

define RUN_PROGRAM
$(eval INSRUCTION := $(word $(PROGRAM_COUNTER),$(PROGRAM)))
$(if $(INSRUCTION),\
$(call RUN_INSTRUCTION,$(INSRUCTION))\
$(eval PROGRAM_COUNTER := $(call INCREMENT_VALUE,$(PROGRAM_COUNTER)))\
$(call RUN_PROGRAM))
endef

define RUN_INSTRUCTION
$(if $(filter-out >,$(1)),\
$(if $(filter-out <,$(1)),\
$(if $(filter-out +,$(1)),\
$(if $(filter-out -,$(1)),\
$(if $(filter-out .,$(1)),\
$(if $(filter-out $(COMMA),$(1)),\
$(if $(filter-out [,$(1)),\
$(if $(filter-out ],$(1)),,\
$(info run ])),\
$(info run [)),\
$(info run $(COMMA))),\
$(call PRINT_BYTE)),\
$(call DECREMENT_STACK_VALUE)),\
$(call INCREMENT_STACK_VALUE)),\
$(call DECREMENT_STACK_COUNTER)),\
$(call INCREMENT_STACK_COUNTER))
endef

define PRINT_BYTE
$(info $(word $(PROGRAM_STACK_COUNTER),$(PROGRAM_STACK)))
endef

define INCREMENT_STACK_COUNTER
$(eval PROGRAM_STACK_COUNTER := $(call INCREMENT_VALUE,$(PROGRAM_STACK_COUNTER)))\
$(if $(word $(PROGRAM_STACK_COUNTER),$(PROGRAM_STACK)),,\
$(eval PROGRAM_STACK += 0))
endef

define DECREMENT_STACK_COUNTER
$(eval PROGRAM_STACK_COUNTER := $(call DECREMENT_VALUE,$(PROGRAM_STACK_COUNTER)))
endef

define INCREMENT_STACK_VALUE
$(eval CURRENT_VALUE := $(word $(PROGRAM_STACK_COUNTER),$(PROGRAM_STACK)))\
$(eval NEW_VALUE := $(call INCREMENT_VALUE,$(CURRENT_VALUE)))\
$(eval PROGRAM_STACK := $(call SET_STACK_ELEMENT,$(PROGRAM_STACK_COUNTER),$(NEW_VALUE),$(PROGRAM_STACK)))
endef

define DECREMENT_STACK_VALUE
$(eval CURRENT_VALUE := $(word $(PROGRAM_STACK_COUNTER),$(PROGRAM_STACK)))\
$(eval NEW_VALUE := $(call DECREMENT_VALUE,$(CURRENT_VALUE)))\
$(eval PROGRAM_STACK := $(call SET_STACK_ELEMENT,$(PROGRAM_STACK_COUNTER),$(NEW_VALUE),$(PROGRAM_STACK)))
endef

define SET_STACK_ELEMENT
$(strip\
$(eval SSE_SET_INDEX := $(1))\
$(eval SSE_VALUE := $(2))\
$(eval SSE_STACK := $(3))\
$(eval SSE_OUTPUT := )\
$(call SET_STACK_ELEMENT_LOOP)\
$(SSE_OUTPUT))
endef

define SET_STACK_ELEMENT_LOOP
$(eval SSE_INDEX := $(words $(SSE_OUTPUT) 0))\
$(eval SSE_ELEMENT := $(word $(SSE_INDEX),$(SSE_STACK)))\
$(eval SSE_TRUTH := $(call IS_EQUAL,$(SSE_INDEX),$(SSE_SET_INDEX)))\
$(if $(SSE_ELEMENT),\
$(if $(SSE_TRUTH),\
$(eval SSE_OUTPUT += $(SSE_VALUE)),\
$(eval SSE_OUTPUT += $(SSE_ELEMENT)))\
$(call SET_STACK_ELEMENT_LOOP)\
,)
endef

PROGRAM := +>++>+++>++++<<<.>.>.>.<<<->-->--->----<<<.>.>.>.
PROGRAM := $(call SPACE_PROGRAM_STRING,$(PROGRAM))
PROGRAM_COUNTER := 1
PROGRAM_STACK := 0
PROGRAM_STACK_COUNTER := 1

scratch:
	$(call RUN_PROGRAM)
	$(info stack dump:)
	$(info $(PROGRAM_STACK))
	@echo scratch

