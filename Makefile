
COMPILE  := $(CXX) -I. -Wall -Wextra -g $(CXXFLAGS)
OPTIMIZE := -DNDEBUG -O2

LIB_BOOST_TEST := -lboost_unit_test_framework

all:
	@echo This library is a C++ header file only.

.bin:
	mkdir -p .bin

test: test-without-optimization test-with-optimization test-with-cpp98 test-with-cpp11

test-without-optimization: test/test.cpp timsort.hpp .bin
	$(COMPILE) $(LIB_BOOST_TEST) $< -o .bin/$@
	time ./.bin/$@

test-with-optimization: test/test.cpp timsort.hpp .bin
	$(COMPILE) $(OPTIMIZE) $(LIB_BOOST_TEST) $< -o .bin/$@
	time ./.bin/$@

test-with-cpp98: test/test.cpp timsort.hpp .bin
	$(COMPILE)  $(LIB_BOOST_TEST) -std=c++98 $< -o .bin/$@
	time ./.bin/$@

test-with-cpp11: test/test.cpp timsort.hpp .bin
	$(COMPILE) $(LIB_BOOST_TEST) -std=c++11 $< -o .bin/$@
	time ./.bin/$@

bench: example/bench.cpp timsort.hpp .bin
	$(CXX) -v
	$(COMPILE) $(OPTIMIZE) -std=c++11 $< -o .bin/$@
	./.bin/$@

coverage:
	make test-with-cpp11 CXXFLAGS="-coverage -O0"
	gcov test.gcda | grep -A 1 "File './timsort.hpp'"
	mv timsort.hpp.gcov coverage.txt
	rm -rf *.gc*

clean:
	rm -rf *~ .bin coverage.txt

.PHONY: test bench coverage clean
