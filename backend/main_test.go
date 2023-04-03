package main

import "testing"

func Test_add(t *testing.T) {
	got := add(2, 2)
	if got != 4 {
		t.Errorf("Got %d, expected %d", got, 4)
	}
}
