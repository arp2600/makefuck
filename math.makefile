include assert.makefile

define IS_EQUAL
$(if $(2),\
$(if $(filter-out $(1),$(2)),\
,TRUE),)
endef

# Increment unsigned value
define MATH_INCREMENT_UVALUE
$(strip\
$(if $(filter $(1),0),1,\
$(eval MATH_INCREMENT_COUNT := )\
$(call MATH_INCREMENT_ULOOP,$(1))\
$(words $(MATH_INCREMENT_COUNT))))
endef

define MATH_INCREMENT_ULOOP
$(if $(word $(1),$(MATH_INCREMENT_COUNT)),\
$(eval MATH_INCREMENT_COUNT += .),\
$(eval MATH_INCREMENT_COUNT += .)$(call MATH_INCREMENT_ULOOP,$(1))\
)
endef

# Decrement unsigned value
define MATH_DECREMENT_UVALUE
$(strip\
$(if $(filter $(1),0),1,\
$(eval MATH_DECREMENT_COUNT := )\
$(call MATH_DECREMENT_ULOOP,$(1))\
$(words $(MATH_DECREMENT_COUNT))))
endef

define MATH_DECREMENT_ULOOP
$(if $(word $(1),$(MATH_DECREMENT_COUNT)),\
$(eval MATH_DECREMENT_COUNT :=\
$(wordlist 2,$(words $(MATH_DECREMENT_COUNT)),$(MATH_DECREMENT_COUNT))),\
$(eval MATH_DECREMENT_COUNT += .)$(call MATH_DECREMENT_ULOOP,$(1))\
)
endef

# Increment value
# if value is negative,
#   if value is -1
#     return 0 
#   else
#     return -decrement_uvalue(value)
# else
#   return increment_uvalue(value)
define INCREMENT_VALUE
$(strip $(if $(findstring -,$(1)),\
$(if $(filter-out -1,$(1)),\
-$(call MATH_DECREMENT_UVALUE,$(subst -,,$(1))),\
0),\
$(call MATH_INCREMENT_UVALUE,$(1))))
endef

# Decrement value
# if value is negative,
#   return -increment_uvalue(value)
# else
#   if value != 0
#     return decrement_uvalue(value) 
#   else
#     return -1
define DECREMENT_VALUE
$(strip $(if $(findstring -,$(1)),\
-$(call MATH_INCREMENT_UVALUE,$(subst -,,$(1))),\
$(if $(filter-out 0,$(1)),\
$(call MATH_DECREMENT_UVALUE,$(1)),\
-1)))
endef

math_tests: increment_uvalue decrement_uvalue increment_value decrement_value
	@echo "math tests passed"

increment_uvalue:
	$(call ASSERT_EQ,1,$(call MATH_INCREMENT_UVALUE,0))
	$(call ASSERT_EQ,5,$(call MATH_INCREMENT_UVALUE,4))
	$(call ASSERT_EQ,10,$(call MATH_INCREMENT_UVALUE,9))
	$(call ASSERT_EQ,11,$(call MATH_INCREMENT_UVALUE,10))
	$(call ASSERT_EQ,111,$(call MATH_INCREMENT_UVALUE,110))

decrement_uvalue:
	$(call ASSERT_EQ,0,$(call MATH_DECREMENT_UVALUE,1))
	$(call ASSERT_EQ,3,$(call MATH_DECREMENT_UVALUE,4))
	$(call ASSERT_EQ,8,$(call MATH_DECREMENT_UVALUE,9))
	$(call ASSERT_EQ,9,$(call MATH_DECREMENT_UVALUE,10))
	$(call ASSERT_EQ,10,$(call MATH_DECREMENT_UVALUE,11))
	$(call ASSERT_EQ,110,$(call MATH_DECREMENT_UVALUE,111))

increment_value:
	$(call ASSERT_EQ,1,$(call INCREMENT_VALUE,0))
	$(call ASSERT_EQ,0,$(call INCREMENT_VALUE,-1))
	$(call ASSERT_EQ,-1,$(call INCREMENT_VALUE,-2))
	$(call ASSERT_EQ,-9,$(call INCREMENT_VALUE,-10))

decrement_value:
	$(call ASSERT_EQ,9,$(call DECREMENT_VALUE,10))
	$(call ASSERT_EQ,0,$(call DECREMENT_VALUE,1))
	$(call ASSERT_EQ,-1,$(call DECREMENT_VALUE,0))
	$(call ASSERT_EQ,-2,$(call DECREMENT_VALUE,-1))
	$(call ASSERT_EQ,-10,$(call DECREMENT_VALUE,-9))

