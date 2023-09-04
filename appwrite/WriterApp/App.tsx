import React, { useState } from 'react';
import {
  View,
  Text,
  TouchableOpacity,
  TextInput,
  FlatList,
  StyleSheet,
} from 'react-native';

// Define the Note type
type Note = {
  id: string;
  content: string;
  createdAt: string;
};

const HandwritingApp = () => {
  const [inputText, setInputText] = useState<string>('');
  const [notification, setNotification] = useState<string>('');
  const [notes, setNotes] = useState<Note[]>([]);

  const handleSave = () => {
    if (inputText) {
      const newNote: Note = {
        id: Date.now().toString(),
        content: inputText,
        createdAt: new Date().toLocaleString(),
      };

      setNotes((prevNotes) => [...prevNotes, newNote]);

      setInputText('');
      setNotification('Submitted successfully');

      setTimeout(() => {
        setNotification('');
      }, 3000);
    }
  };

  return (
    <View style={styles.container}>
      <TextInput
        placeholder="Start writing here..."
        multiline
        style={styles.textInput}
        value={inputText}
        onChangeText={(text) => setInputText(text)}
      />
      <TouchableOpacity
        style={styles.saveButton}
        onPress={handleSave}
        disabled={!inputText}
      >
        <Text style={styles.saveButtonText}>Save</Text>
      </TouchableOpacity>
      {notification ? (
        <Text style={styles.notification}>{notification}</Text>
      ) : null}
      <FlatList
        data={notes}
        keyExtractor={(item) => item.id.toString()}
        renderItem={({ item }) => (
          <View style={styles.noteContainer}>
            <Text style={styles.noteContent}>{item.content}</Text>
            <Text style={styles.noteCreatedAt}>{item.createdAt}</Text>
          </View>
        )}
      />
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 16,
    backgroundColor: '#f0f0f0', // Set a background color
  },
  textInput: {
    height: 200,
    borderWidth: 1,
    borderColor: '#ccc',
    borderRadius: 8,
    padding: 10,
    marginBottom: 16,
    backgroundColor: 'white', // White background for input
  },
  saveButton: {
    backgroundColor: 'blue',
    padding: 10,
    borderRadius: 8,
    alignItems: 'center',
    marginBottom: 16, // Add margin at the bottom
  },
  saveButtonText: {
    color: 'white',
    fontWeight: 'bold',
    fontSize: 18, // Increase font size
  },
  notification: {
    color: 'green',
    textAlign: 'center',
    marginTop: 10,
    fontSize: 16,
  },
  noteContainer: {
    borderWidth: 1,
    borderColor: '#ccc',
    borderRadius: 8,
    padding: 16,
    marginBottom: 16,
    backgroundColor: 'white', // White background for notes
  },
  noteContent: {
    fontSize: 18,
    marginBottom: 8,
  },
  noteCreatedAt: {
    fontSize: 14,
    color: '#888',
  },
});

export default HandwritingApp;
