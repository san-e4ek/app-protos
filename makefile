.PHONY: codegen codegen-install

# Установка плагинов для protoc
codegen-install:
	go install google.golang.org/protobuf/cmd/protoc-gen-go@latest && \
	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest

# Генерация gRPC и protobuf кода
PROTO_FILES := $(shell find proto -name '*.proto')

codegen:
	protoc -I proto \
		$(PROTO_FILES) \
		--go_out=./gen/go --go_opt=paths=source_relative \
		--go-grpc_out=./gen/go --go-grpc_opt=paths=source_relative
