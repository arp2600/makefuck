default:
	@echo "Please specify a target"

include math.makefile

tests: math_tests
	@echo "all tests passed"
