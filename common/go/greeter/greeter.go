package greeter

import (
	"appbricks.io/gomobiletest/person"
)

// Printer types can print things.
type Printer interface {
  PrintSomething(s string)
}

// Greeter greets people.
type Greeter struct {
  printer Printer
}

// NewGreeter makes a new Greeter.
func NewGreeter(printer Printer) *Greeter {
  return &Greeter{
    printer: printer,
  }
}

// Greet greets someone.
func (g *Greeter) Greet(p *person.Person) {
  g.printer.PrintSomething("Hello " + p.FullName + "!")
}
