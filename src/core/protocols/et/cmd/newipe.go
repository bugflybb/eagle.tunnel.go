package cmd

import (
	"errors"
	"math/rand"
	"strings"

	"github.com/eaglexiang/eagle.tunnel.go/src/core/protocols/et/comm"
	myslice "github.com/eaglexiang/eagle.tunnel.go/src/slice"
	"github.com/eaglexiang/go-tunnel"
)

// NewIPE NEWPORT子协议
type NewIPE struct{}

// Handle 处理业务
func (p NewIPE) Handle(req string, tunnel *tunnel.Tunnel) (err error) {
	args := strings.Split(req, " ")
	if len(args) <= 1 {
		err = errors.New("invalid req: " + req)
	}
	oldIPE := args[1]
	newIPE := p.RandIPE(oldIPE)
	_, err = tunnel.WriteLeft([]byte(newIPE))
	return
}

// Send 发送请求
func (p NewIPE) Send(e *comm.NetArg) (err error) {
	result, err := sendQuery(p, comm.DefaultArg.RemoteIPE)
	if err != nil {
		return
	}
	comm.DefaultArg.RemoteIPE = result
	return
}

// Type 类型
func (p NewIPE) Type() (t comm.CMDType) {
	return comm.NEWIPE
}

// Name 名字
func (p NewIPE) Name() (name string) {
	return comm.NEWIPETxt
}

// RandIPE 从可用IPE中随机获取一个。应排除入参
func (p NewIPE) RandIPE(oldIPE string) (ipe string) {
	validIPEs := myslice.RemoveFromStringSlice(oldIPE, comm.DefaultArg.LocalIPEs)
	i := rand.Intn(len(validIPEs))
	ipe = validIPEs[i]
	return
}
