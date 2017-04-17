default:
	$(call RUN_PROGRAM)
	@(echo )

include math.makefile
include program.makefile

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
$(call MAYBE_JUMP_BACKWARD)),\
$(call MAYBE_JUMP_FORWARD)),\
$(call READ_INPUT)),\
$(call PRINT_BYTE)),\
$(call DECREMENT_STACK_VALUE)),\
$(call INCREMENT_STACK_VALUE)),\
$(call DECREMENT_STACK_COUNTER)),\
$(call INCREMENT_STACK_COUNTER))
endef

define READ_INPUT
$(eval INPUT := $(shell ./echoin))\
$(info read $(INPUT) from stdin)\
$(eval PROGRAM_STACK := $(call SET_STACK_ELEMENT,$(PROGRAM_STACK_COUNTER),$(INPUT),$(PROGRAM_STACK)))
endef

define MAYBE_JUMP_FORWARD
$(eval CURRENT_VALUE := $(word $(PROGRAM_STACK_COUNTER),$(PROGRAM_STACK)))\
$(eval TRUTH := $(call IS_EQUAL,0,$(CURRENT_VALUE)))\
$(if $(TRUTH),$(call JUMP_FORWARD_LOOP))
endef

define JUMP_FORWARD_LOOP
$(eval TRUTH := $(call IS_EQUAL,],$(word $(PROGRAM_COUNTER),$(PROGRAM))))\
$(if $(TRUTH),,\
$(eval PROGRAM_COUNTER := $(call INCREMENT_VALUE,$(PROGRAM_COUNTER)))\
$(call JUMP_FORWARD_LOOP))
endef

define MAYBE_JUMP_BACKWARD
$(eval CURRENT_VALUE := $(word $(PROGRAM_STACK_COUNTER),$(PROGRAM_STACK)))\
$(eval TRUTH := $(call IS_EQUAL,0,$(CURRENT_VALUE)))\
$(if $(TRUTH),,$(call JUMP_BACKWARD_LOOP))
endef

define JUMP_BACKWARD_LOOP
$(eval TRUTH := $(call IS_EQUAL,[,$(word $(PROGRAM_COUNTER),$(PROGRAM))))\
$(if $(TRUTH),,\
$(eval PROGRAM_COUNTER := $(call DECREMENT_VALUE,$(PROGRAM_COUNTER)))\
$(call JUMP_BACKWARD_LOOP))
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

PROGRAM := $(call SPACE_PROGRAM_STRING,$(PROGRAM))
PROGRAM_COUNTER := 1
PROGRAM_STACK := 0
PROGRAM_STACK_COUNTER := 1

