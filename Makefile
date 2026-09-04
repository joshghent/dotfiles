.PHONY: test
test:
	@command -v fish >/dev/null && ./test_fish_env.fish || echo "fish not installed, skipping fish env tests"
	./test.sh
