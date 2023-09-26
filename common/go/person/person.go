package person

import (
	"fmt"
	"time"
)

type Identity interface {
  Username() string
}

type Person struct {
	identity Identity

	FullName string
	Address  string
	DOB			 string
}

var people = map[string]*Person{
	"anika": {
		FullName: "Anika Luciana", 
		Address: "1186 Martha Street, Whipoorwill, AZ 86510",
		DOB: "2004-04-21",
	},
	"ceci": {
		FullName: "Cecilia David", 
		Address: "3919 Hayhurst Lane, Southfield, MI 48075",
		DOB: "1995-10-15",
	},
	"kazi": {
		FullName: "Kazimír Tomislav", 
		Address: "3805 Ocala Street, Maitland, Fl 32751",
		DOB: "1999-11-11",
	},
}

func NewPerson(identity Identity) *Person {
	person := people[identity.Username()]
	if person != nil {
		person.identity = identity
	}
	return person
}

func (p *Person) Age() string {
	dob, err := time.Parse("2006-01-02", p.DOB)
	if err != nil {
		panic(err)
	}

	ageInDays := time.Since(dob).Hours() / 24
	ageInYears := ageInDays / 365
	ageInDays -= ageInYears * 365

	return fmt.Sprintf("%d Years %d Days", int(ageInYears), int(ageInDays))
}
