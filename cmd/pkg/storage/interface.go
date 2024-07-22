package storage

import (
	//postgres "command-line-argumentsE:\\!!!VMWARE\\VM_GO\\windows\\project\\taskStorage\\cmd\\pkg\\storage\\postgres\\postgres.go"
	//"tracker/cmd/task/sortCustomTypes"
	"taskdb/cmd/pkg/storage/postgres"
)

type Interface interface {
	InsertUser(postgres.User) (int, error)
	SelectUsers(int) ([]postgres.User, error)
	Close()
}
