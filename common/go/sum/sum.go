package sum

import "time"

func Sum(a, b int) int {
	return a + b
}

func SumLongRunning(a, b int) int {
	time.Sleep(5 * time.Second)
	return a + b
}

func SumWithCallback(a, b int, callback func(int) int) int {
	return callback(a + b)
}
