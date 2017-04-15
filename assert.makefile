define ASSERT_EQ
$(if $(2),\
$(if $(filter-out $(1),$(2)),\
$(error test "$(1) == $(2)" failed)),\
$(error test "$(1) == $(2)" failed))
endef
