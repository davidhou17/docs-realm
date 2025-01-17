    [
      { "_id": ObjectId("5f87976b7b800b285345a8b4"), "_partition": "Store 42", "color": "white", "name": "venus flytrap", "storeNumber": "42", "sunlight": "full", "type": "perennial" },
      { "_id": ObjectId("5f87976b7b800b285345a8b6"), "_partition": "Store 42", "color": "green", "name": "thai basil", "storeNumber": "42", "sunlight": "partial", "type": "perennial" },
      { "_id": ObjectId("5f87976b7b800b285345a8b7"), "_partition": "Store 42", "color": "yellow", "name": "helianthus", "storeNumber": "42", "sunlight": "full", "type": "annual" },
      { "_id": ObjectId("5f87a0dffc9013565c233612"), "_partition": "Store 42", "color": "purple", "name": "wisteria lilac", "storeNumber": "42", "sunlight": "partial", "type": "perennial" },
      { "_id": ObjectId("5f87a0dffc9013565c233613"), "_partition": "Store 42", "color": "yellow", "name": "daffodil", "storeNumber": "42", "sunlight": "full", "type": "perennial" },
      { "_id": ObjectId("5f1f63055512f2cb67f460a3"), "_partition": "Store 47", "color": "green", "name": "sweet basil", "storeNumber": "47", "sunlight": "full", "type": "perennial" }
    ]
    // :code-block-end
  )
});
test("Unwind Array Values", async () => {
  const plants = await getPlantsCollection();
  // :snippet-start: unwind-array-values
  const result = await plants.aggregate([
    { $group: { _id: "$type", colors: { $addToSet: "$color" } } },
    { $unwind: { path: "$colors" } },
    { $sort: { _id: 1, colors: 1 } },
  ]);
  console.log(result);