/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const functions = require("firebase-functions");
const admin = require("firebase-admin");
const express = require("express");
const cors = require("cors");

// Initialize Firebase
admin.initializeApp();

// Initialize Firestore
const db = admin.firestore();

// Initialize Firestore with emulator settings if in development
if (process.env.FUNCTIONS_EMULATOR) {
  db.settings({
    host: "localhost:8080",
    ssl: false,
  });
}

// Initialize Express
const app = express();

// Configure CORS
app.use(
  cors({
    origin: true, // Allow all origins
    methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
    allowedHeaders: ["Content-Type", "Authorization"],
  }),
);

app.use(express.json());

// Collection reference
const todosCollection = "todos";

// Create todo
app.post("/todos", async (req, res) => {
  try {
    const { title, description } = req.body;

    if (!title) {
      return res.status(400).json({ error: "Title is required" });
    }

    const todo = {
      title: title.trim(),
      description: description ? description.trim() : "",
      completed: false,
      createdAt: new Date().toISOString(), // Use regular timestamp for now
    };

    console.log("Creating todo:", todo);

    const docRef = await db.collection(todosCollection).add(todo);

    console.log("Todo created with ID:", docRef.id);

    const todoDoc = await docRef.get();
    const todoData = todoDoc.data();

    return res.status(201).json({
      id: docRef.id,
      ...todoData,
    });
  } catch (error) {
    console.error("Error creating todo:", error);
    return res.status(500).json({
      error: "Failed to create todo",
      details: error.message,
      stack: process.env.FUNCTIONS_EMULATOR ? error.stack : undefined,
    });
  }
});

// Get all todos
app.get("/todos", async (req, res) => {
  try {
    const snapshot = await db
      .collection(todosCollection)
      .orderBy("createdAt", "desc")
      .get();

    const todos = [];
    snapshot.forEach((doc) => {
      todos.push({
        id: doc.id,
        ...doc.data(),
      });
    });

    return res.status(200).json(todos);
  } catch (error) {
    console.error("Error getting todos:", error);
    return res.status(500).json({
      error: "Failed to get todos",
      details: error.message,
    });
  }
});

// Update todo
app.put("/todos/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const { title, description, completed } = req.body;

    const todoRef = db.collection(todosCollection).doc(id);
    const todoDoc = await todoRef.get();

    if (!todoDoc.exists) {
      return res.status(404).json({ error: "Todo not found" });
    }

    const updateData = {
      updatedAt: new Date().toISOString(), // Use regular timestamp for now
    };

    if (title !== undefined) updateData.title = title.trim();
    if (description !== undefined) updateData.description = description.trim();
    if (completed !== undefined) updateData.completed = completed;

    await todoRef.update(updateData);
    const updatedDoc = await todoRef.get();

    return res.status(200).json({
      id: updatedDoc.id,
      ...updatedDoc.data(),
    });
  } catch (error) {
    console.error("Error updating todo:", error);
    return res.status(500).json({
      error: "Failed to update todo",
      details: error.message,
    });
  }
});

// Delete todo
app.delete("/todos/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const todoRef = db.collection(todosCollection).doc(id);
    const todoDoc = await todoRef.get();

    if (!todoDoc.exists) {
      return res.status(404).json({ error: "Todo not found" });
    }

    await todoRef.delete();
    return res.status(200).json({ message: "Todo deleted successfully" });
  } catch (error) {
    console.error("Error deleting todo:", error);
    return res.status(500).json({
      error: "Failed to delete todo",
      details: error.message,
    });
  }
});

// Export the API with public access
exports.api = functions.https.onRequest(
  {
    cors: true,
    maxInstances: 10,
    invoker: "public", // Allow unauthenticated access
  },
  app,
);
