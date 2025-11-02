.PHONY: codegen codegen-install clean google-api-install

# === Настройки ===
PROTO_DIR := proto
GOOGLE_API_DIR := .
OUT_DIR := gen/go
OPENAPI_DIR := gen/openapi

# Собираем все .proto файлы (в любых подпапках)
PROTO_FILES := $(shell find $(PROTO_DIR) -name '*.proto')

# === Установка плагинов ===
codegen-install:
	go install google.golang.org/protobuf/cmd/protoc-gen-go@latest && \
	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest && \
	go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-grpc-gateway@latest && \
	go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv2@latest

# === Генерация кода из всех .proto ===
codegen:
	protoc -I $(PROTO_DIR) -I $(GOOGLE_API_DIR) \
		$(PROTO_FILES) \
		--go_out=$(OUT_DIR) --go_opt=paths=source_relative \
		--go-grpc_out=$(OUT_DIR) --go-grpc_opt=paths=source_relative \
		--grpc-gateway_out=$(OUT_DIR) --grpc-gateway_opt=paths=source_relative \
		--openapiv2_out=$(OPENAPI_DIR)

# === Установка google аннотаций ===
google-api-install:
	curl -sSL https://raw.githubusercontent.com/googleapis/googleapis/master/google/api/annotations.proto -o google/api/annotations.proto
	curl -sSL https://raw.githubusercontent.com/googleapis/googleapis/master/google/api/http.proto -o google/api/http.proto

# === Очистка сгенерированных файлов ===
clean:
	@echo "🧹 Cleaning generated folders..."
	@rm -rf $(OUT_DIR)/* $(OPENAPI_DIR)/* 2>/dev/null || true
	@echo "✅ Done!"

	# === Очистка + регенерация ===
regen: clean codegen
	@echo "🔄 Re-generated protobuf and gRPC code!"