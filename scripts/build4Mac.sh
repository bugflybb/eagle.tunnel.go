echo "begin to build golang code for Mac"

CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 go build -o ${PublishPath}/et.go.mac ${SrcPath}/main.go

echo "done"