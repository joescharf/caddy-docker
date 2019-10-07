package main

import (
	"github.com/caddyserver/caddy/caddy/caddymain"
	// plug in plugins here, for example:
	_ "github.com/abiosoft/caddy-git"
	_ "github.com/echocat/caddy-filter"
	// _ "github.com/pieterlouw/caddy-net"
)

func main() {
	caddymain.EnableTelemetry = false
	caddymain.Run()
}
