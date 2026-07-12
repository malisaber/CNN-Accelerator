CXX ?= g++
TARGET ?= build/Text-Converter
CLI11_HEADER := include/CLI11.hpp
CLI11_URL ?= https://github.com/CLIUtils/CLI11/releases/download/v2.6.2/CLI11.hpp
CLI11_FALLBACK ?= ../Code-Converter/include/CLI11.hpp

SRC_DIR := src
INC_DIR := include
BUILD_DIR := build

SRCS := $(wildcard $(SRC_DIR)/*.cpp)
OBJS := $(SRCS:$(SRC_DIR)/%.cpp=$(BUILD_DIR)/%.o)
DEPS := $(OBJS:.o=.d)

CXXFLAGS ?= -std=c++17 -O2 -Wall -Wextra -I$(INC_DIR)
LDFLAGS ?=
LDLIBS ?=

.PHONY: all clean run cli11

all: cli11 $(TARGET)

cli11:
	@if [ ! -s "$(CLI11_HEADER)" ] || grep -q '^404: Not Found$$' "$(CLI11_HEADER)"; then \
		mkdir -p $(dir $(CLI11_HEADER)); \
		if curl -fsSL "$(CLI11_URL)" -o "$(CLI11_HEADER)"; then \
			printf '%s\n' "Fetched CLI11.hpp"; \
		elif [ -s "$(CLI11_FALLBACK)" ]; then \
			cp "$(CLI11_FALLBACK)" "$(CLI11_HEADER)"; \
			printf '%s\n' "Copied CLI11.hpp from fallback"; \
		else \
			printf '%s\n' "Unable to obtain CLI11.hpp" >&2; \
			exit 1; \
		fi; \
	fi

$(TARGET): $(OBJS) | $(BUILD_DIR)
	$(CXX) $(OBJS) $(LDFLAGS) $(LDLIBS) -o $@

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp $(CLI11_HEADER) | $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) -MMD -MP -c $< -o $@

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

clean:
	rm -rf $(BUILD_DIR)

run: cli11 $(TARGET)
	./$(TARGET)

-include $(DEPS)
