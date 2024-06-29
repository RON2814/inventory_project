const express = require("express");
const { MongoClient } = require("mongodb");
const dotenv = require("dotenv");

dotenv.config();
const app = express();

const uri = process.env.MONGODB_URI || "";

const client = new MongoClient(uri);

let connectedClient, db;

const col_products = "Products", col_accounts = "Accounts"; // Collection name !!!!

async function connectToMDB() {
    try {
        connectedClient = await client.connect();
        console.log("Connected to MongoDB");
    } catch (e) {
        console.log(e);
    } finally {
        db = connectedClient.db("inventory_system"); // <- database name
    }
}

app.listen(3000, () => {
    console.log("app is listening on port 3000");
});

connectToMDB();

// Test API Endpoint (req-request res-response)

app.get("/api/get_product", async (req, res) => {
    try {
        let collection = await db.collection(col_products);
        let product = await collection.find().toArray();

        res.status(200).json(product);
    } catch (e) {
        res.status(500).json({error: "Products could not be returned."});
    }
});

app.post("api/add_product", async (req, res) => {
    try {
        let collection = await db.collection(col_products);
        let product = req.body;
        let result = await collection.insertOne(product);

        res.status(200).json({request:"Insert success " + result});
    } catch (e) {
        res.status(500).json({error: "Can't add Product. Error is occur"});
    }
});

app.post("api/login", async (req, res) => {
    try {
        
    } catch (e) {
        res.status(500).json({error: "Login error"});
    }
});

app.post("api/signup", async (req, res) => {
    try {
        let collection = await db.collection(col_accounts);
        
        let signup = await db.collection.insertOne();
    } catch (e) {
        res.status(500).json({error: "Login error"});
    }
});


/*app.post("/delete-product", async (req, res) => {
    try {
        let collection = await db.collection(colProducts);
        let archiveProduct = await db.collection(colArchive);
        
        let products = req.body; // Expecting an array of products
        let responses = [];

        for (let prod of products) {
            let prodId = prod.id;
            try {
                // Validate prodId length
                if (!ObjectId.isValid(prodId)) {
                    responses.push({ id: prodId, status: 'Invalid Product ID', error: true });
                    continue; 
                }

                let objectId = ObjectId.createFromHexString(prodId);

                let result = await collection.findOne({ _id: objectId });

                if (!result) {
                    responses.push({ id: prodId, status: 'Product not found', error: true });
                    continue;
                }

                // Copy result to archive
                await archiveProduct.insertOne(result);

                // Remove product from collection
                await collection.deleteOne({ _id: objectId });

                responses.push({ id: prodId, status: 'Deleted and archived', error: false, isUpdated: true});
            } catch (innerError) {
                responses.push({ id: prodId, status: 'Delete operation failed', error: true, detailed: innerError.toString() });
            }
        }

        res.status(200).json({ message: "Products processed", results: responses });

    } catch (e) {
        res.status(500).json({ error: "Can't delete products. Error occurred.", detailed: e.toString() });
        console.log(e);
    }
}); */
