package person

import (
	"fmt"
	"time"

	"appbricks.io/gomobiletest/error"
)

type Identity interface {
	UserID() string
  Username() string
	Avatar() string
}

type Person struct {
	FullName string
	Address  string
	DOB			 string
}

var people = map[string]*Person{
	"001": {
		FullName: "Anika Luciana", 
		Address: "1186 Martha Street, Whipoorwill, AZ 86510",
		DOB: "2004-04-21",
	},
	"002": {
		FullName: "Cecilia David", 
		Address: "3919 Hayhurst Lane, Southfield, MI 48075",
		DOB: "1995-10-15",
	},
	"003": {
		FullName: "Kazimír Tomislav", 
		Address: "3805 Ocala Street, Maitland, Fl 32751",
		DOB: "1999-11-11",
	},
}

func NewPerson(identity Identity, errorHandler error.ErrorHandler) *Person {
	person := people[identity.UserID()]
	if person == nil {
		errorHandler.HandleError(
			404, 
			fmt.Sprintf(
				"Person not found with userid \"%s\" and username \"%s\".", 
				identity.UserID(),
				identity.Username(),
			),
		)
	}
	return person
}

func (p *Person) Age() string {
	dob, err := time.Parse("2006-01-02", p.DOB)
	if err != nil {
		panic(err)
	}

	ageInYears, ageInMonths := calculateAge(dob)
	return fmt.Sprintf("%d Years and %d Months", 
		int(ageInYears), int(ageInMonths))
}

func calculateAge(birthDate time.Time) (years, months int) {
	currentDate := time.Now()

	// Calculate years.
	years = currentDate.Year() - birthDate.Year()

	// Calculate months.
	if currentDate.Month() < birthDate.Month() ||
			(currentDate.Month() == birthDate.Month() && currentDate.Day() < birthDate.Day()) {
			months = 12 - int(birthDate.Month()) + int(currentDate.Month()) - 1
			years--
	} else {
			months = int(currentDate.Month()) - int(birthDate.Month())
	}

	return years, months
}