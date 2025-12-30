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
const FormData = require("form-data");
const axios = require("axios");

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
  })
);

app.use(express.json());

// Collection reference
const todosCollection = "todos";

app.post("/todos", async (req, res) => {
  try {
    const {
      title,
      description,
      completed,
      category,
      createdAt,
      id,
      isUrgent,
      updatedAt,
      dueDate,
    } = req.body;

    if (!title) {
      return res.status(400).json({ error: "Title is required" });
    }
    console.log("Request body:", req.body);
    const todo = {
      title: title.trim(),
      description: description ? description.trim() : "",
      completed: completed,
      category: category,
      createdAt: createdAt,
      isUrgent: isUrgent,
      updatedAt: updatedAt,
      dueDate: dueDate,
    };

    console.log("Creating todo:", todo);
    const docRef = await db.collection(todosCollection).doc();
    todo.id = docRef.id;
    await docRef.set(todo);

    console.log("Todo created with ID:", docRef.id);

    const todoDoc = await docRef.get();
    const todoData = todoDoc.data();
    console.log("Todo data:", todoData);
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
function base64ToFile(base64Str, fileName, mimeType) {
  const byteCharacters = Buffer.from(base64Str, "base64");
  return {
    buffer: byteCharacters,
    size: byteCharacters.length,
    name: fileName,
    type: mimeType,
  };
}
app.post("/stripeProxy", async (req, res) => {
  try {
    console.log("Received request to /stripeProxy");
    // console.log("Request body:", req.body);

    const { headers, params, urlEndpoint, method, file, mimeType } = req.body;
    // console.log("Request body:", req.body);
    console.log("//////////////////////////////");
    console.log("Headers:", headers);
    console.log("Params:", params);
    console.log("URL Endpoint:", urlEndpoint);
    console.log("Method:", method);
    console.log("mimeType", mimeType);
    if (file) {
      console.log("File received:");
      const base64file = base64ToFile(file, "file", mimeType);
      const fileSize = base64file.size;
      console.log("File size:", fileSize / 1024, "KB");

      const buffer = Buffer.from(file, "base64");

      // Create multipart form
      const form = new FormData();
      form.append("file", buffer, "decoded.png");

      let resp = await axios
        .post(urlEndpoint, form, {
          headers: headers,

          params: params,
        })
        .then((res) => {
          console.log("Upload success:", res.data);
          return res;
        })
        .catch((err) => {
          console.error("Upload error:", err);
          return res.status(err.response.status).json({
            error: "Failed to upload file",
            details: err.message,
            statusCode: err.response.status,
          });
        });
      const statusCode = resp.status;
      const responsedata = resp.data;

      console.log("Response status code:", statusCode);
      console.log("Response data:", responsedata);
      return res.status(statusCode).json(responsedata);
    }
    return res.status(200).json({
      message: "Stripe proxy endpoint hit successfully",
      headers: headers,
      params: params,
      urlEndpoint: urlEndpoint,
      method: method,
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
    console.log("Fetching all todos");
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
    const { title, description, completed, isUrgent, dueDate } = req.body;
    //print id and params of body
    console.log("ID:", id);
    console.log("Params:", req.body);
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
    if (isUrgent !== undefined) updateData.isUrgent = isUrgent;
    if (dueDate !== undefined) updateData.dueDate = dueDate;

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
    //or check if a todo with "id" field that equates iq

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
  app
);
