package main

import (
	"fmt"
	"log"
	"os"

	tea "github.com/charmbracelet/bubbletea"
	"github.com/charmbracelet/charm/kv"
)

type Meadow struct {
	keys     [][]byte         // items on the to-do list
	cursor   int              // which to-do list item our cursor is pointing at
	selected map[int]struct{} // which to-do items are selected
}

func initialModel() Meadow {
	db, err := kv.OpenWithDefaults("meadow.sh.test.db")
	if err != nil {
		panic(err)
	}
	defer db.Close()

	keys, err := db.Keys()
	if err != nil {
		panic(err)
	}
	return Meadow{
		keys:     keys,
		cursor:   0,
		selected: make(map[int]struct{}),
	}
}

func (m Meadow) Init() tea.Cmd {
	// Just return `nil`, which means "no I/O right now, please."
	return nil
}

func (m Meadow) Update(msg tea.Msg) (tea.Model, tea.Cmd) {
	switch msg := msg.(type) {

	// Is it a key press?
	case tea.KeyMsg:

		// Cool, what was the actual key pressed?
		switch msg.String() {

		// These keys should exit the program.
		case "ctrl+c", "q":
			return m, tea.Quit

		// The "up" and "k" keys move the cursor up
		case "up", "k":
			if m.cursor > 0 {
				m.cursor--
			}

		// The "down" and "j" keys move the cursor down
		case "down", "j":
			if m.cursor < len(m.keys)-1 {
				m.cursor++
			}

		// The "enter" key and the spacebar (a literal space) toggle
		// the selected state for the item that the cursor is pointing at.
		case "enter", " ":
			_, ok := m.selected[m.cursor]
			if ok {
				delete(m.selected, m.cursor)
			} else {
				m.selected[m.cursor] = struct{}{}
			}
		}
	}

	// Return the updated model to the Bubble Tea runtime for processing.
	// Note that we're not returning a command.
	return m, nil
}

func (m Meadow) View() string {
	// The header
	s := "What should we buy at the market?\n\n"

	// Iterate over our keys
	for i, key := range m.keys {

		// Is the cursor pointing at this keys?
		cursor := " " // no cursor
		if m.cursor == i {
			cursor = ">" // cursor!
		}

		// Is this key selected?
		checked := " " // not selected
		if _, ok := m.selected[i]; ok {
			checked = "x" // selected!
		}

		// Render the row
		s += fmt.Sprintf("%s [%s] %s\n", cursor, checked, key)
	}

	// The footer
	s += "\nPress q to quit.\n"

	// Send the UI for rendering
	return s
}

func sync_data_dir_to_db() {
	data_dir := "./data/audio"

	db, err := kv.OpenWithDefaults("meadow.sh.test.db")
	if err != nil {
		panic(err)
	}
	defer db.Close()

	f, err := os.Open(data_dir)
	if err != nil {
		log.Fatalf("Failed opening directory: %s", err)
	}
	defer f.Close()

	files, err := f.Readdir(-1)
	if err != nil {
		log.Fatalf("Failed reading directory: %s", err)
	}

	for _, file := range files {
		path := data_dir + "/" + file.Name()

		data, err := os.ReadFile(path)
		if err != nil {
			log.Fatalf("Failed to read the audio file: %v", err)
		}

		err = write_value_to_db(path, data)
		if err != nil {
			panic(err)
		}
	}
}

func write_value_to_db(key string, value []byte) error {
	max_size := 5000000

	db, err := kv.OpenWithDefaults("meadow.sh.test.db")
	if err != nil {
		panic(err)
	}
	defer db.Close()

	for i := 0; i < len(value); i += max_size {
		end := i + max_size

		if (end) > len(value) {
			end = len(value)
		}

		slice := value[i:end]
		slice_key := key + "/" + fmt.Sprint(i/max_size)

		err = db.Set([]byte(slice_key), []byte(slice))
		if err != nil {
			return err
		}

		fmt.Println("key:", key, "num_bytes:", len(slice))
	}

	return nil
}

func read_value_from_db(key string) {
	max_chunks := 100

	db, err := kv.OpenWithDefaults("meadow.sh.test.db")
	if err != nil {
		panic(err)
	}
	defer db.Close()

	for i := 0; i < max_chunks; i++ {
		key := key + "/" + fmt.Sprint(i)

		value, err := db.Get([]byte(key))
		if err != nil {
			if err.Error() == "Key not found" {
				break
			} else {
				panic(err)
			}
		}

		fmt.Println("key:", key, "num_bytes:", len(value))
	}
}

func main() {
	p := tea.NewProgram(initialModel())
	if _, err := p.Run(); err != nil {
		fmt.Printf("Alas, there's been an error: %v", err)
		os.Exit(1)
	}
}
